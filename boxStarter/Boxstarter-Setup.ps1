$ProgressPreference="SilentlyContinue"
$Boxstarter.RebootOk=$true

# This script is to be run by Boxstarter and assumes that we are installing
# to at least Windows 10 build 1709 (a.k.a Fall Creators Update).

# Download some helper scripts, these will stay permanantly on the machine
# I put these files into two locations, one is only for provision scripts the other is for shared powershell scripts.

# URL: http://boxstarter.org/package/url?https://git.io/vF5zn

Update-ExecutionPolicy -Policy Unrestricted

# Set up some global variables
$extractRoot = "$env:ALLUSERSPROFILE\provision-windows"
$outputPath = "$extractRoot\output"
$scriptPath = "$extractRoot\provision-windows-master\scripts"

### Phase 1 - Download and extract the scripts
if (!(Test-Path "$extractRoot\provision-windows-master\README.md")) {
    # Download the master branch
    $zipFile = "$env:TEMP\provision-windows.zip"
    iwr https://github.com/brennanfee/provision-windows/archive/master.zip -UseBasicParsing -o $zipFile

    # Extract it
    Expand-Archive $zipFile -DestinationPath $extractRoot

    # Create the output directory
    New-Item $outputPath -ItemType Directory -Force
}

Import-Module -DisableNameChecking "$scriptPath\Utilities\Get-ComputerDetails.psm1"
$computerDetails = Get-ComputerDetails

### Phase 2 - Install the optional windows features
if (!(Test-Path "$outputPath\reboot-features.txt")) {
    Write-BoxstarterMessage "Installing Windows Features"

    # Do this before running updates so updates to these will be included

    # The boxstarter commands
    Enable-RemoteDesktop
    Enable-MicrosoftUpdate

    # My list of features
    & "$scriptPath\Installs\Install-Optional-Windows-Features.ps1" -Configuration Developer

    New-Item "$outputPath\reboot-features.txt" -type file
    Invoke-Reboot
}

### Phase 3 - Run Windows Updates
if (!(Test-Path "$outputPath\reboot-updates.txt")) {
    Write-BoxstarterMessage "Install Windows Updates"
    Install-WindowsUpdate -AcceptEula
    if(Test-PendingReboot){ Invoke-Reboot }

    # Another round of windows updates, in case installed applications have windows updates (like IIS, .NET)
    Write-BoxstarterMessage "Install Windows Updates (Post Application Installs)"
    Install-WindowsUpdate -AcceptEula
    if(Test-PendingReboot){ Invoke-Reboot }

    New-Item "$outputPath\reboot-updates.txt" -type file
    Invoke-Reboot
}

### Phase 4 - Install Virtualization Tools, if necessary
#TODO: Write support for other VM techs, at present only supports VirtualBox
if (!(Test-Path "$outputPath\reboot-virtualization.txt")) {
    Write-BoxstarterMessage "Checking if virtualization required..."
    if ($computerDetails.IsVirtual)
    {
        if (-Not (Test-Path "$env:ProgramFiles\Oracle\VirtualBox Guest Additions")) {
            & "$scriptPath\Installs\Install-Virtualbox-Additions.ps1"
        }
        else {
            Write-BoxstarterMessage "Guest additions already installed."
        }
    }
    else
    {
        Write-BoxstarterMessage "VM drivers skipped since machine is not a VM."
    }

    New-Item "$outputPath\reboot-virtualization.txt" -type file
    Invoke-Reboot
}

### Phase 5 - Base Applications
if (!(Test-Path "$outputPath\reboot-apps.txt")) {
    Write-BoxstarterMessage "Installing apps"

    # Needed for sdelete64.exe later on
    cmd /c "$env:ALLUSERSPROFILE\Chocolatey\choco.exe" install -y sysinternals

    # Needed by numerous scripts to manage zip/iso files
    cmd /c "$env:ALLUSERSPROFILE\Chocolatey\choco.exe" install -y 7zip.portable

    # Needed as next step in provisioning (manually pull my DotFiles)
    cmd /c "$env:ALLUSERSPROFILE\Chocolatey\choco.exe" install Git -y --package-parameters="'/GitAndUnixToolsOnPath /NoAutoCrlf /WindowsTerminal /NoShellIntegration'"

    New-Item "$outputPath\reboot-apps.txt" -type file
    Invoke-Reboot
}

### Phase 6 - Main configurations (registry tweaks, settings, etc.)
if (!(Test-Path "$outputPath\reboot-configurations.txt")) {
    Write-BoxstarterMessage "Writing configurations"

    Get-ChildItem "$scriptPath\Settings" -File -Filter "*.ps1" | Sort-Object "FullName" | Foreach-Object {
        & "$_.FullName"
    }

    New-Item "$outputPath\reboot-configurations.txt" -type file
    Invoke-Reboot
}

### Phase 7 - Remove Windows bloat (uninstall, remove things I don't want)
if (!(Test-Path "$outputPath\reboot-bloat.txt")) {
    Write-BoxstarterMessage "Removing bloat"

    Get-ChildItem "$scriptPath\Bloat" -File -Filter "*.ps1" | Sort-Object "FullName" | Foreach-Object {
        & "$_.FullName"
    }

    New-Item "$outputPath\reboot-bloat.txt" -type file
    Invoke-Reboot
}

### Phase 8 - Clean up (this is mostly to prepare for VM shrink and/or a SysPrep)
if (!(Test-Path "$outputPath\reboot-clean.txt")) {
    Write-BoxstarterMessage "Cleaning up..."

    Write-BoxstarterMessage "Removing temp files"
    @(
        "$env:localappdata\Nuget",
        "$env:TEMP\*",
        "$env:SYSTEMROOT\logs",
        "$env:SYSTEMROOT\panther",
        "$env:SYSTEMROOT\temp\*",
        "$env:SYSTEMROOT\prefetch\*",
        "$env:SYSTEMROOT\winsxs\manifestcache"
    ) | % {
        if(Test-Path $_) {
            Write-BoxstarterMessage "Removing $_"
            cmd /c Takeown /d Y /R /f $_
            cmd /c Icacls $_ /GRANT:r administrators:F /T /c /q  2>&1 | Out-Null
            Remove-Item $_ -Recurse -Force -ErrorAction SilentlyContinue | Out-Null
        }
    }

    Write-BoxstarterMessage "Cleaning SxS..."
    cmd /c dism.exe /Online /Cleanup-Image /SPSuperseded
    cmd /c dism.exe /Online /Cleanup-Image /StartComponentCleanup /ResetBase

    Write-BoxstarterMessage "Defragging..."
    Optimize-Volume -DriveLetter C

    Write-BoxstarterMessage "Cleaning up desktop"
    $UsersDesktopPath = [Environment]::GetFolderPath("Desktop") + "\*.lnk"
    Remove-Item $UsersDesktopPath
    Remove-Item "$env:Public\Desktop\*.lnk"

    Write-BoxstarterMessage "Zeroing out empty space..."
    cmd /c "$env:ALLUSERSPROFILE\chocolatey\bin\sdelete64.exe" /accepteula -z "$env:SystemDrive"

    New-Item "$outputPath\reboot-clean.txt" -type file
    Invoke-Reboot
}

### Phase 9 - Setup WinRM
if (!(Test-Path "$outputPath\reboot-winrm.txt")) {
    Write-BoxstarterMessage "Setting up WinRM"

    & "$scriptPath\Installs\Setup-WinRm.ps1"

    Enable-UAC

    New-Item "$outputPath\reboot-winrm.txt" -type file
    Invoke-Reboot
}

### ABOVE WAS LAST REBOOT - All below is to prepare for SysPrep (if needed)

# If an automated install and there is an post-unattend file, copy it locally
if(Test-Path a:\postunattend.xml)
{
    Write-BoxstarterMessage "Copy unattend scripts to local drive..."
    New-Item "$env:SYSTEMROOT\Panther\Unattend" -type directory
    Copy-Item a:\postunattend.xml "$env:SYSTEMROOT\Panther\Unattend\unattend.xml"
}

Write-BoxstarterMessage "Set PowerShell policy"
Update-ExecutionPolicy -Policy RemoteSigned

#TODO: Validate if needed
#Write-BoxstarterMessage "Disabling Auto Login"
#New-ItemProperty -Path "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name "AutoAdminLogon" -Value "0" -PropertyType DWord

Write-BoxstarterMessage "PROVISION COMPLETE!!!"
