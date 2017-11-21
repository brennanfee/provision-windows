#TODO: Make a secure version of this, have a param passed to this script to decide secure or 'open'
Write-Host "Setup network connections"
Get-NetConnectionProfile | Set-NetConnectionProfile -NetworkCategory Private

Write-Host "Setting up winrm"
& "$PSScriptRoot\..\Utilities\ConfigureRemotingForAnsible.ps1" -CertValidityDays 3650 -ForceNewSSLCert -Verbose

#cmd /c winrm set winrm/config '@{MaxTimeoutms="1800000"}'
#cmd /c winrm set winrm/config/client/auth '@{Basic="true"}'
#cmd /c winrm set winrm/config/service/auth '@{Basic="true"}'
#cmd /c winrm set winrm/config/service '@{AllowUnencrypted="true"}'
#cmd /c `"sc config winrm start= auto`"
