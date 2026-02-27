# Import the Active Directory module
Import-Module ActiveDirectory

# Define the search pattern
# Replace with your naming convention for Local Admin groups
$searchPattern = "*- Local Administrator"

# Get AD groups that match the search pattern
$groups = Get-ADGroup -Filter {Name -like $searchPattern}

# Display the results
$groups | ForEach-Object {
    Write-Output $_.Name
}
