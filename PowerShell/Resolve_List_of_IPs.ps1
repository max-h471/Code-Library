# This is a script to read the Hostnames of a buch of devices from a text file, resolve the IP addresses, and write them to another file

$InputFile = "C:\Users\xxxx\Documents\Hostname_List.txt"
$OutputFile = "C:\Users\xxxx\Documents\Hostname_IP_Output.txt"
foreach ($Hostname in Get-Content $InputFile) {
   Write-Host "Resolving $Hostname"
   $IPAddress = [System.Net.Dns]::GetHostAddresses($Hostname) | Select-Object -ExpandProperty IPAddressToString
   "$Hostname : $IPAddress" | Out-File -Append $OutputFile
}
Write-Host "Done! Check $OutputFile for the results."
