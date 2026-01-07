# Onestart is a web browser and search engine that typically gets bundle-installed with other programs. It is a grayware/adware program that sets itself as the primary borwser and
# exports various information about a user and their device. This script removes it. It is so common to be bundled with other software that I had to create a script to remove it

# Kill OneStart processes
Taskkill /F /IM Onestart* /T

# Stop OneStart service if running
Stop-Service -Name "OneStart*" -ErrorAction SilentlyContinue

# Disable OneStart service
Set-Service -Name "Onestart" -StartupType Disabled

# Remove OneStart file system artifacts with * flag. Some folders are called onestart, some folders are called onestart.ai
{ 
$onestartpaths = @(
    "C:\Program Files\OneStart*",
    "C:\Program Files (x86)\OneStart*",
    "C:\Users\*\AppData\Local\OneStart*",
    "C:\Users\*\AppData\Roaming\OneStart*",
    "C:\Users\*\OneStart.ai",
    "C:\Users\*\OneStart*",
    "C:\Users\*\Downloads\pdfguruhub.msi",
    "C:\Users\*\Downloads\onestart*"
)
foreach ($onestartpaths in $onestartpathss) {
    Remove-Item -Path $onestartpaths -Recurse -Force -ErorAction SilentlyContinue}
}

# Remove OneStart executable and folder from all user profiles
$users = Get-ChildItem -Path "C:\Users" -Directory
foreach ($user in $users) {
    $onestartpaths2 = "$($user.FullName)\AppData\Local\Onestart"
    if (Test-Path -Path $onestartpaths2) {
        # Unregister all DLLs in the OneStart folder
        $dlls = Get-ChildItem -Path "$onestartpaths2\*.dll"
        foreach ($dll in $dlls) {
            regsvr32 /u /s $dll.FullName
        }

    # Remove any onestart files from Downloads folder
    $downloadsPath = "$($user.FullName)\Downloads\onestart*.exe"
    Remove-Item -Path $downloadsPath -Force -ErrorAction SilentlyContinue
}
}


# Remove OneStart registry artifacts
$registryPaths = @(
    "HKLM:\SOFTWARE\OneStart*",
    "HKLM:\SOFTWARE\WOW6432Node\OneStart*",
    "HKCU:\Software\OneStart*",
    "HKEY_USERS\software\microsoft\windows\currentversion\run\OneStart*",
    "HKEY_CURRENT_USER\*\SOFTWARE\MICROSOFT\WINDOWS\CURRENTVERSION\RUN\OneStartChromium",
    "HKEY_CURRENT_USER\*\SOFTWARE\MICROSOFT\WINDOWS\CURRENTVERSION\RUN\OneStartUpdate",
    "HKEY_CURRENT_USER\SOFTWARE\MICROSOFT\WINDOWS\CURRENTVERSION\RUN\OneStartUpdate",
    "HKEY_CURRENT_USER\SOFTWARE\MICROSOFT\WINDOWS\CURRENTVERSION\RUN\OneStartChromium",
    "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tree\OneStartUser\*

)
foreach ($registryPath in $registryPaths) {
    Remove-Item -Path $registryPath -Recurse -Force -ErrorAction SilentlyContinue
}


# Fully delete the onestart service 
sc.exe delete OneStart

Write-Output "OneStart has been uninstalled silently from all profiles,
Downloads folders, and OneStart folders."
