# try to Kill TeamViewer processes
try {taskkill /F /IM "teamviewer*" /T } catch {}

# Stop TeamViewer service if running
Stop-Service -Name "TeamViewer" -ErrorAction SilentlyContinue

# Disable TeamViewer service
Set-Service -Name "TeamViewer" -StartupType Disabled -ErrorAction SilentlyContinue

# Remove scheduled task 
try {schtasks.exe /delete /TN 'TVINSTALLRESTORE' /F} catch{}
# Remove TeamViewer file system artifacts
$teamviewerPaths = @(
    "C:\Program Files\TeamViewer*",
    "C:\Program Files (x86)\TeamViewer*",
    "C:\Users\*\AppData\Local\TeamViewer*",
    "C:\Users\*\AppData\Roaming\TeamViewer*"
)

foreach ($path in $teamviewerPaths) {
    Get-ChildItem -Path $path -ErrorAction SilentlyContinue | ForEach-Object {
        Write-Host "Deleting folder: $($_.FullName)"
        Remove-Item -Path $_.FullName -Recurse -Force -ErrorAction SilentlyContinue
    }
}

# Remove TeamViewer executable and folder from all user profiles
$users = Get-ChildItem -Path "C:\Users" -Directory
foreach ($user in $users) {
    $tvpaths = "$($user.FullName)\AppData\Local\TeamViewer"
    if (Test-Path -Path $tvpaths) {
        # Unregister all DLLs in the Teamviewer folders
        $dlls = Get-ChildItem -Path "$tvpaths\*.dll"
        foreach ($dll in $dlls) {
            regsvr32 /u /s $dll.FullName
        }

# Remove any TeamViewer*.exe files from Downloads folder
    $downloadsPath = "$($user.FullName)\Downloads\TeamViewer*.exe"
    Remove-Item -Path $downloadsPath -Force -ErrorAction SilentlyContinue
}

# Fully delete Teamviewer service
sc.exe delete TeamViewer -ErrorAction SilentlyContinue

Write-Output "TeamViewer has been uninstalled silently from all profiles,
Downloads folders, and TeamViewer folders."
}
