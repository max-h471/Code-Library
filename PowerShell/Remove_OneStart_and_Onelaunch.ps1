# Onestart is a web browser and search engine that typically gets bundle-installed with other programs. It is a grayware/adware program that sets itself as the primary borwser and
# exports various information about a user and their device. This script removes it. It is so common to be bundled with other software that I had to create a script to remove it
# Onelaunch is basically the same thing with a slightly different UI

# Kill OneStart and OneLaunch processes
Taskkill /F /IM Onestart* /T
Taskkill /F /IM Onelaunch* /T

# Stop OneLaunch service if running
Stop-Service -Name "OneStart*" -ErrorAction SilentlyContinue
Stop-Service -Name "OneLaunch*" -ErrorAction SilentlyContinue

# Disable OneLaunch and OneStart service
Set-Service -Name "Onestart*" -StartupType Disabled
Set-Service -Name "OneLaunch*" -StartupType Disabled

# Remove scheduled task 
schtasks.exe /delete /TN 'OneLaunchUpdateTask' /F
schtasks.exe /delete /TN 'OneStartUpdateTask' /F

# Remove OneStart and OneLaunch file system artifacts
$OneStartPaths = @(
    "C:\Program Files\OneStart*",
    "C:\Program Files (x86)\OneStart*",
    "C:\Users\*\AppData\Local\OneStart*",
    "C:\Users\*\AppData\Roaming\OneStart*",
    "C:\Users\*\OneStart.ai",
    "C:\Users\*\OneStart*",
    "C:\Users\*\Downloads\pdfguruhub.msi",
    "C:\Users\*\Downloads\onestart*",
    "C:\Program Files\Onelaunch*",
    "C:\Program Files (x86)\Onelaunch*",
    "C:\Users\*\AppData\Local\Onelaunch*",
    "C:\Users\*\AppData\Roaming\Onelaunch*",
    "C:\Users\*\Onelaunch.ai",
    "C:\Users\*\Onelaunch*",
    "C:\Users\*\Downloads\pdfguruhub.msi",
    "C:\Users\*\Downloads\Onelaunch*"
)

foreach ($path in $OneStartPaths) {
    Get-ChildItem -Path $path -ErrorAction SilentlyContinue | ForEach-Object {
        Write-Host "Deleting folder: $($_.FullName)"
        Remove-Item -Path $_.FullName -Recurse -Force -ErrorAction SilentlyContinue
    }
}

# Remove and Unregister OneLaunch DLLs
$users = Get-ChildItem -Path "C:\Users" -Directory
foreach ($user in $users) {
    $OneLaunchPaths = "$($user.FullName)\AppData\Local\OneLaunch"
    if (Test-Path -Path $OneLaunchPaths) {
        $dlls = Get-ChildItem -Path "$OneLaunchPaths\*.dll"
        foreach ($dll in $dlls) {
            regsvr32 /u /s $dll.FullName
        }

    # Remove any OneLaunch*.exe files from Downloads folder if registry placed it back
    $downloadsPath = "$($user.FullName)\Downloads\OneLaunch*.exe"
    Remove-Item -Path $downloadsPath -Force -ErrorAction SilentlyContinue
    }
}

# Remove OneStart executable and folder from all user profiles
$users = Get-ChildItem -Path "C:\Users" -Directory
foreach ($user in $users) {
    $OneLaunchPaths = "$($user.FullName)\AppData\Local\OneStart"
    if (Test-Path -Path $OneStartPaths) {
        # Unregister all DLLs in the OneStart folder
        $dlls = Get-ChildItem -Path "$OneStartPaths\*.dll"
        foreach ($dll in $dlls) {
            regsvr32 /u /s $dll.FullName
        }
    # Remove any OneLaunch*.exe files from Downloads folder
    $downloadsPath = "$($user.FullName)\Downloads\OneStart*.exe"
    Remove-Item -Path $downloadsPath -Force -ErrorAction SilentlyContinue
    }
}

# Remove OneLaunch Reg Keys
Remove-Item -Path "Registry::HKU64\*\{4947c51a-26a9-4ed0-9a7b-c21e5ae0e71a}_is1" -Recurse
Remove-Item -Path "Registry::HKU\*\{4947c51a-26a9-4ed0-9a7b-c21e5ae0e71a}_is1" -Recurse

# Remove OneLaunch Reg Keys
$registryPaths = @(
    "HKLM:\SOFTWARE\OneStart*",
    "HKLM:\SOFTWARE\WOW6432Node\OneStart*",
    "HKCU:\Software\OneStart*",
    "HKEY_USERS\software\microsoft\windows\currentversion\run\OneStart*",
    "HKEY_CURRENT_USER\*\SOFTWARE\MICROSOFT\WINDOWS\CURRENTVERSION\RUN\OneStartChromium",
    "HKEY_CURRENT_USER\*\SOFTWARE\MICROSOFT\WINDOWS\CURRENTVERSION\RUN\OneStartUpdate",
    "HKEY_CURRENT_USER\SOFTWARE\MICROSOFT\WINDOWS\CURRENTVERSION\RUN\OneStartUpdate",
    "HKEY_CURRENT_USER\SOFTWARE\MICROSOFT\WINDOWS\CURRENTVERSION\RUN\OneStartChromium",
    "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tree\OneStartUser\*"

)
foreach ($registryPath in $registryPaths) {
    Remove-Item -Path $registryPath -Recurse -Force -ErrorAction SilentlyContinue
}

# Remove OneLaunch and OneStart service
sc.exe delete OneStart
sc.exe delete OneLaunch

Write-Output "OneLaunch and OneStart have been uninstalled silently from all profiles,
Downloads folders, and OneStart and OneLaunch folders, and any DLLs have been unregistered."
