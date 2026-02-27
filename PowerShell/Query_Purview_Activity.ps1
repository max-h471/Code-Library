# This script will query events from the M365 Activity explorer and output to a CSV file.
# Prior to running, you need to use modules Connect-IPPSSession or Connect-ExchangeOnline to connect to your tenant
# This sample targets the event "FileCopiedToRemovableMedia" created by purview and queryable in the M365 Activity Explorer

$start  = [datetime]"08/01/2025 00:15 AM" # change to fit your needs
$end    = [datetime]"02/16/2026 12:59 PM" # change to fit your needs
$pageSz = 5000 # API is rate limited to a 5000 page size, anything larget will error
# change the excel title to what fits for you
$outCsv = Join-Path $PWD "ActivityExplorer_FileCopiedToRemovableMedia_$(Get-Date -Format yyyyMMdd-HHmmss).csv"

$res = Export-ActivityExplorerData `
  -StartTime $start `
  -EndTime   $end `
  -PageSize  $pageSz `
# The below 'Activity' can be replaced by any activities found here:
# https://learn.microsoft.com/en-us/powershell/module/exchangepowershell/export-activityexplorerdata?view=exchange-ps
  -Filter1 @('Activity','FileCopiedToRemovableMedia') `
  -OutputFormat Csv # can also be JSON

# Write the first page (includes header)
$res.ResultData | Set-Content -Path $outCsv -Encoding UTF8

# as referenced in the -PageCookie section of the above link, we have to 'page' through the results to iterate the findings to format correctly in excel
while ($res.LastPage -ne $true) {
    $cookie = $res.WaterMark   
    $res = Export-ActivityExplorerData `
        -StartTime $start `
        -EndTime   $end `
        -PageSize  $pageSz `
        -OutputFormat Csv `
        -PageCookie $cookie

    # The service returns the header on each page; drop it when appending
    $lines = $res.ResultData -split "`r?`n"
    if ($lines.Count -gt 0) {
        $dataRows = $lines | Select-Object -Skip 1  # skip header
        if ($dataRows -and $dataRows.Trim()) {
            Add-Content -Path $outCsv -Value $dataRows -Encoding UTF8
        }
    }
}

Write-Host "CSV exported to: $outCsv"
``
