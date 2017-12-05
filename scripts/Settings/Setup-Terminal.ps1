Import-Module -DisableNameChecking "$PSScriptRoot\..\Utilities\FileAndRegistryUtilities.psm1"

$fontkey = 'HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Console'
$key = 'HKCU:\Console'

# Setup fonts
Set-RegistryString "$fontkey\TrueTypeFont" "000" "Hack NF"
Set-RegistryString "$fontkey\TrueTypeFont" "0000" "Hasklig NF"
Set-RegistryString "$fontkey\TrueTypeFont" "00000" "SourceCodePro NF"

# Setup font for console
Set-RegistryString "$key" "FaceName" "SourceCodePro NF"
Set-RegistryInt "$key" "FontSize" 1310720

# Console settings
Set-RegistryInt "$key" "ForceV2" 1
Set-RegistryInt "$key" "LineSelection" 1
Set-RegistryInt "$key" "FilterOnPaste" 1
Set-RegistryInt "$key" "LineWrap" 1
Set-RegistryInt "$key" "CtrlKeyShortcutsDisabled" 0
Set-RegistryInt "$key" "ExtendedEditKey" 0
Set-RegistryInt "$key" "TrimLeadingZeros" 0
Set-RegistryInt "$key" "WindowsAlpha" 243
Set-RegistryInt "$key" "InsertMode" 1
Set-RegistryInt "$key" "QuickEdit" 1

Set-RegistryInt "$key" "HistoryBufferSize" 999
Set-RegistryInt "$key" "NumberOfHistoryBuffers" 4

# Powershell
Set-RegistryString "$key\%SystemRoot%_System32_WindowsPowerShell_v1.0_powershell.exe" "FaceName" "SourceCodePro NF"
Set-RegistryString "$key\%SystemRoot%_SysWOW64_WindowsPowerShell_v1.0_powershell.exe" "FaceName" "SourceCodePro NF"
Set-RegistryInt "$key\%SystemRoot%_System32_WindowsPowerShell_v1.0_powershell.exe" "FontSize" 1310720
Set-RegistryInt "$key\%SystemRoot%_SysWOW64_WindowsPowerShell_v1.0_powershell.exe" "FontSize" 1310720

Set-RegistryInt "$key\%SystemRoot%_System32_WindowsPowerShell_v1.0_powershell.exe" "QuickEdit" 1
Set-RegistryInt "$key\%SystemRoot%_SysWOW64_WindowsPowerShell_v1.0_powershell.exe" "QuickEdit" 1

