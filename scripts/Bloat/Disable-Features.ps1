Import-Module -DisableNameChecking "$PSScriptRoot\..\Utilities\FileAndRegistryUtilities.psm1"

# Disable Bing Search
$winkey = 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion'
Set-RegistryInt "$winkey\Search" "BingSearchEnabled" 0

# Disable Game Bar Tips
Set-RegistryInt "HKCU:\SOFTWARE\Microsoft\GameBar" "ShowStartupPanel" 0

# Disable Internet Explorer ESC protections, this is usually only turned on for servers
$compsPath = "SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A7-37EF-4b3f-8CFC-4F3A74704073}"
Set-RegistryInt "HKLM:\$compsPath" "IsInstalled" 0
Set-RegistryInt "HKCU:\$compsPath" "IsInstalled" 0
