# Kill RustDesk process if running
Stop-Process -Name "rustdesk" -Force -ErrorAction SilentlyContinue

# Stop RustDesk service if running
Stop-Service -Name "RustDesk" -ErrorAction SilentlyContinue

# Disable RustDesk service
Set-Service -Name "RustDesk" -StartupType Disabled

# Remove RustDesk executable from Program Files
Remove-Item -Path "C:\Program Files\RustDesk\RustDesk.exe" -Force -ErrorAction SilentlyContinue

# Remove RustDesk configuration files from ProgramData
Remove-Item -Path "C:\ProgramData\RustDesk" -Recurse -Force -ErrorAction SilentlyContinue

# Remove RustDesk executable and folder from all user profiles
$users = Get-ChildItem -Path "C:\Users" -Directory
foreach ($user in $users) {
    $rustdeskPath = "$($user.FullName)\AppData\Local\rustdesk"
    if (Test-Path -Path $rustdeskPath) {
        # Unregister all DLLs in the RustDesk folder
        $dlls = Get-ChildItem -Path "$rustdeskPath\*.dll"
        foreach ($dll in $dlls) {
            regsvr32 /u /s $dll.FullName
        }

        # Remove the RustDesk folder
        Remove-Item -Path $rustdeskPath -Recurse -Force -ErrorAction SilentlyContinue
    }

    # Remove any rustdesk*.exe files from Downloads folder
    $downloadsPath = "$($user.FullName)\Downloads\rustdesk*.exe"
    Remove-Item -Path $downloadsPath -Force -ErrorAction SilentlyContinue
}

# Remove RustDesk service
sc.exe delete RustDesk

Write-Output "RustDesk has been uninstalled silently from all user profiles,
Downloads folders, and RustDesk folders."
