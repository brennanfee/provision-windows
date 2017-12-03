Import-Module -DisableNameChecking "$PSScriptRoot\..\Utilities\FileAndRegistryUtilities.psm1"

$key = 'HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Console'

# Setup fonts

Set-RegistryString "$key\TrueTypeFont" "000" "Hack NF"
Set-RegistryString "$key\TrueTypeFont" "0000" "Hasklig NF"
Set-RegistryString "$key\TrueTypeFont" "00000" "SourceCodePro NF"
