# try Kill TextNow Application processes
try {taskkill /F /IM "textnow*" /T } catch {}

# Stop extNow Application service if running
Stop-Service -Name "*textnow*" -ErrorAction SilentlyContinue

# Disable extNow Application service
Set-Service -Name "*textnow*" -StartupType Disabled -ErrorAction SilentlyContinue

# Remove scheduled task 
try {schtasks.exe /delete /TN '*textnow*' /F} catch{}
# Remove TextNow Application file system artifacts
$textpaths = @(
    "C:\Program Files\WindowsApps\Enflick*",
    "C:\Program Files\WindowsApps\textnow*",
    "C:\Program Files (x86)\textnow*",
    "C:\Program Files (x86)\enflick*",
    "C:\Users\*\AppData\Local\textnow*",
    "C:\Users\*\AppData\Local\enflick*",
    "C:\Users\*\AppData\Roaming\textnow*",
    "C:\Users\*\AppData\Roaming\enflick*"
)

foreach ($path in $textpaths) {
    Get-ChildItem -Path $path -ErrorAction SilentlyContinue | ForEach-Object {
        Write-Host "Deleting folder: $($_.FullName)"
        Remove-Item -Path $_.FullName -Recurse -Force -ErrorAction SilentlyContinue
    }
}


# Remove TextNow Application executable and folder from all user profiles
$users = Get-ChildItem -Path "C:\Users" -Directory
foreach ($user in $users) {
    $textpaths = "$($user.FullName)\AppData\Local\textnow"
    if (Test-Path -Path $textpaths) {
        # Unregister all DLLs in the OneStart folder
        $dlls = Get-ChildItem -Path "$tvpaths\*.dll"
        foreach ($dll in $dlls) {
            regsvr32 /u /s $dll.FullName
        }

    # Remove any textnow*.exe files from Downloads folder
    $downloadsPath = "$($user.FullName)\Downloads\textnow*.exe"
    Remove-Item -Path $downloadsPath -Force -ErrorAction SilentlyContinue
}

# Remove textnow service
sc.exe delete textnow -ErrorAction SilentlyContinue

# Remove Registry artifacts
$keys = @(
    "Registry::HKU64\*\7c8e5a2ea8238344b0ae5d043376b070",
    "Registry::HKU64\*\64c2663eaa40c06b8d8b3aa747353aad"
    # more keys might be needed depending on if there is more persistence, use EDR shell to check registry 
)

foreach ($key in $keys) {
    if (Test-Path $key) {
        Remove-Item -Path $key -Recurse -Force
    }
}
Write-Output "textnow has been uninstalled silently from all profiles,
Downloads folders, and Shift folders."
}
