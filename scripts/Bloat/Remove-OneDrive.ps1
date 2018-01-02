#!/usr/bin/env powershell.exe

# This script will remove and disable OneDrive integration.

Import-Module -DisableNameChecking $PSScriptRoot\..\Utilities\FileAndRegistryUtilities.psm1

Write-Host "Kill OneDrive process"
taskkill.exe /F /IM "OneDrive.exe"
taskkill.exe /F /IM "explorer.exe"

Write-Host "Remove OneDrive"
if (Test-Path "$env:systemroot\System32\OneDriveSetup.exe") {
    & "$env:systemroot\System32\OneDriveSetup.exe" /uninstall
}
if (Test-Path "$env:systemroot\SysWOW64\OneDriveSetup.exe") {
    & "$env:systemroot\SysWOW64\OneDriveSetup.exe" /uninstall
}

Write-Host "Removing OneDrive leftovers"
Remove-Item -Recurse -Force -ErrorAction SilentlyContinue "$env:localappdata\Microsoft\OneDrive"
Remove-Item -Recurse -Force -ErrorAction SilentlyContinue "$env:programdata\Microsoft OneDrive"
Remove-Item -Recurse -Force -ErrorAction SilentlyContinue "$env:systemdrive\OneDriveTemp"
# check if directory is empty before removing:
If ((Get-ChildItem "$env:userprofile\OneDrive" -Recurse | Measure-Object).Count -eq 0) {
    Remove-Item -Recurse -Force -ErrorAction SilentlyContinue "$env:userprofile\OneDrive"
}

Write-Host "Disable OneDrive via Group Policies"
Set-RegistryInt "HKLM:\SOFTWARE\Wow6432Node\Policies\Microsoft\Windows\OneDrive" "DisableFileSyncNGSC" 1

Write-Host "Remove Onedrive from explorer sidebar"
# Can't easily and reliably access HKCR with PowerShell
cmd /c reg.exe ADD "HKCR\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" /v "System.IsPinnedToNameSpaceTree" /t REG_DWORD /d 0 /f
cmd /c reg.exe ADD "HKCR\Wow6432Node\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" /v "System.IsPinnedToNameSpaceTree" /t REG_DWORD /d 0 /f

Write-Host "Removing run hook for new users"
cmd /c reg.exe load "hku\Default" "C:\Users\Default\NTUSER.DAT"
cmd /c reg.exe delete "HKEY_USERS\Default\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v "OneDriveSetup" /f
cmd /c reg.exe unload "hku\Default"

Write-Output "Removing startmenu entry"
Remove-Item -Force -ErrorAction SilentlyContinue "$env:userprofile\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\OneDrive.lnk"

Write-Output "Removing scheduled task"
Get-ScheduledTask -TaskPath '\' -TaskName 'OneDrive*' -ErrorAction SilentlyContinue | Unregister-ScheduledTask -Confirm:$false

Write-Output "Restarting explorer"
Start-Process "explorer.exe"

Write-Output "Waiting for explorer to complete loading"
Start-Sleep 10

Write-Output "Removing additional OneDrive leftovers"
foreach ($item in (Get-ChildItem "$env:WinDir\WinSxS\*onedrive*")) {
    Takeown-Folder $item.FullName
    Remove-Item -Recurse -Force $item.FullName -ErrorAction SilentlyContinue
}
