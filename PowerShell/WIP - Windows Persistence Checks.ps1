$Users = Get-ChildItem -Path 'C:\Users' -Directory | Select-Object -ExpandProperty Name

foreach ($User in $Users) {
    Write-Host "`nStartup folder for $User ---"
    $Items = Get-ChildItem -Path "C:\Users\$User\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup" -ErrorAction SilentlyContinue
    if ($Items) {
        $Items
    } else {
        Write-Host "No startup items were found for $User"
    }
}

Write-Host "`nGlobal Startup Folder below ---"
$GlobalStartup = Get-ChildItem -Path "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp" -ErrorAction SilentlyContinue
if ($GlobalStartup) {
    $GlobalStartup
} else {
    Write-Host "No global startup items were found"
}

# Registry startup items
function Show-RegistryItem {
    param (
        [string]$Path,
        [string]$Label
    )
    Write-Host "`n$Label ---"
    try {
        $Item = Get-Item -Path $Path -ErrorAction Stop
        if ($Item) {
            $Item
        }
    } catch {
        Write-Host "No startup items were found in $Label"
    }
}

# Startup folders in registry
Show-RegistryItem "HKLM:\Software\Microsoft\Windows\CurrentVersion\RunOnceEx" "RunOnceEx (HKLM)"
Show-RegistryItem "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" "User Shell Folders (HKCU)"
Show-RegistryItem "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders" "Shell Folders (HKCU)"
Show-RegistryItem "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders" "Shell Folders (HKLM)"
Show-RegistryItem "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" "User Shell Folders (HKLM)"

# Startup services in registry
Show-RegistryItem "HKLM:\Software\Microsoft\Windows\CurrentVersion\RunServicesOnce" "RunServicesOnce (HKLM)"
Show-RegistryItem "HKCU:\Software\Microsoft\Windows\CurrentVersion\RunServicesOnce" "RunServicesOnce (HKCU)"
Show-RegistryItem "HKLM:\Software\Microsoft\Windows\CurrentVersion\RunServices" "RunServices (HKLM)"
Show-RegistryItem "HKCU:\Software\Microsoft\Windows\CurrentVersion\RunServices" "RunServices (HKCU)"

# Startup policies in registry
Show-RegistryItem "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\Run" "Policies Run (HKLM)"
Show-RegistryItem "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer
