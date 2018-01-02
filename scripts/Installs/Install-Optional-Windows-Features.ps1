#!/usr/bin/env powershell.exe

<#
.SYNOPSIS
Install my selection of optional windows features.
.DESCRIPTION
A script to install optional windows features.  Can pass in a machine configuration to install.  Currently supports
two configurations Standard (the default) and Developer (includes IIS and some other dev features).
.PARAMETER Configuration
The machine configuration to be installed (Standard or Developer).  The default is Standard.
.NOTES
Name       : Install-Optional-Windows-Features
Version    : 1.0.0 11/13/2017 Brennan Fee
                - First release
Author     : Brennan Fee
#>
[cmdletBinding(SupportsShouldProcess = $true)]
param(
    [parameter(Position=0, ValueFromPipeline=$true, HelpMessage="The machine configuration to be installed (Standard or Developer).")]
    [ValidateSet('Standard', 'Developer')]
    $Configuration = 'Standard'
)

# To query installed features:  Get-WindowsOptionalFeature -Online | where {$_.State -eq "Enabled"} | select FeatureName

# Turn on developer mode, this is done on all machines for the symlink functionality (to not need admin console to create links)
cmd /c reg.exe ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock" /v AllowDevelopmentWithoutDevLicense /t REG_DWORD /d "1" /f

# For all desktops (these are installed by default in Windows 10), repeated here to be explicit
Enable-WindowsOptionalFeature -FeatureName MicrosoftWindowsPowerShellV2Root -Online -All -LimitAccess -NoRestart
Enable-WindowsOptionalFeature -FeatureName MicrosoftWindowsPowerShellV2 -Online -All -LimitAccess -NoRestart
Enable-WindowsOptionalFeature -FeatureName WorkFolders-Client -Online -All -LimitAccess -NoRestart
Enable-WindowsOptionalFeature -FeatureName MediaPlayback -Online -All -LimitAccess -NoRestart
Enable-WindowsOptionalFeature -FeatureName WindowsMediaPlayer -Online -All -LimitAccess -NoRestart
Enable-WindowsOptionalFeature -FeatureName WCF-Services45 -Online -All -LimitAccess -NoRestart
Enable-WindowsOptionalFeature -FeatureName WCF-TCP-PortSharing45 -Online -All -LimitAccess -NoRestart
Enable-WindowsOptionalFeature -FeatureName NetFx4-AdvSrvs -Online -All -LimitAccess -NoRestart
Enable-WindowsOptionalFeature -FeatureName Printing-PrintToPDFServices-Features -Online -All -LimitAccess -NoRestart
Enable-WindowsOptionalFeature -FeatureName Printing-XPSServices-Features -Online -All -LimitAccess -NoRestart
Enable-WindowsOptionalFeature -FeatureName MSRDC-Infrastructure -Online -All -LimitAccess -NoRestart
Enable-WindowsOptionalFeature -FeatureName SearchEngine-Client-Package -Online -All -LimitAccess -NoRestart
Enable-WindowsOptionalFeature -FeatureName SMB1Protocol -Online -All -LimitAccess -NoRestart
Enable-WindowsOptionalFeature -FeatureName SMB1Protocol-Client -Online -All -LimitAccess -NoRestart
Enable-WindowsOptionalFeature -FeatureName SMB1Protocol-Deprecation -Online -All -LimitAccess -NoRestart
Enable-WindowsOptionalFeature -FeatureName Xps-Foundation-Xps-Viewer -Online -All -LimitAccess -NoRestart
Enable-WindowsOptionalFeature -FeatureName Windows-Defender-Default-Definitions -Online -All -LimitAccess -NoRestart
Enable-WindowsOptionalFeature -FeatureName Printing-Foundation-Features -Online -All -LimitAccess -NoRestart
Enable-WindowsOptionalFeature -FeatureName FaxServicesClientPackage -Online -All -LimitAccess -NoRestart
Enable-WindowsOptionalFeature -FeatureName Printing-Foundation-InternetPrinting-Client -Online -All -LimitAccess -NoRestart
Enable-WindowsOptionalFeature -FeatureName SmbDirect -Online -All -LimitAccess -NoRestart
Enable-WindowsOptionalFeature -FeatureName Microsoft-Windows-NetFx3-OC-Package -Online -All -LimitAccess -NoRestart
Enable-WindowsOptionalFeature -FeatureName Microsoft-Windows-NetFx4-US-OC-Package -Online -All -LimitAccess -NoRestart
Enable-WindowsOptionalFeature -FeatureName Microsoft-Windows-NetFx3-WCF-OC-Package -Online -All -LimitAccess -NoRestart
Enable-WindowsOptionalFeature -FeatureName Microsoft-Windows-NetFx4-WCF-US-OC-Package -Online -All -LimitAccess -NoRestart
Enable-WindowsOptionalFeature -FeatureName Internet-Explorer-Optional-amd64 -Online -All -LimitAccess -NoRestart

# For all desktops ("Standard") machines
Enable-WindowsOptionalFeature -FeatureName SimpleTCP -Online -All -LimitAccess -NoRestart
Enable-WindowsOptionalFeature -FeatureName Microsoft-Windows-Subsystem-Linux -Online -All -LimitAccess -NoRestart
Enable-WindowsOptionalFeature -FeatureName IIS-HostableWebCore -Online -All -LimitAccess -NoRestart
Enable-WindowsOptionalFeature -FeatureName NetFx4Extended-ASPNET45 -Online -All -LimitAccess -NoRestart
Enable-WindowsOptionalFeature -FeatureName RasRip -Online -All -LimitAccess -NoRestart
Enable-WindowsOptionalFeature -FeatureName TelnetClient -Online -All -LimitAccess -NoRestart
Enable-WindowsOptionalFeature -FeatureName TFTP -Online -All -LimitAccess -NoRestart
Enable-WindowsOptionalFeature -FeatureName TIFFIFilter -Online -All -LimitAccess -NoRestart
Enable-WindowsOptionalFeature -FeatureName ServicesForNFS-ClientOnly -Online -All -LimitAccess -NoRestart
Enable-WindowsOptionalFeature -FeatureName ClientForNFS-Infrastructure -Online -All -LimitAccess -NoRestart
Enable-WindowsOptionalFeature -FeatureName NFS-Administration -Online -All -LimitAccess -NoRestart

# Extras for "dev" desktops
if ($Configuration -eq 'Developer') {
    Enable-WindowsOptionalFeature -FeatureName IIS-WebServerRole -Online -All -LimitAccess -NoRestart
    Enable-WindowsOptionalFeature -FeatureName IIS-WebServer -Online -All -LimitAccess -NoRestart
    Enable-WindowsOptionalFeature -FeatureName IIS-CommonHttpFeatures -Online -All -LimitAccess -NoRestart
    Enable-WindowsOptionalFeature -FeatureName IIS-HttpErrors -Online -All -LimitAccess -NoRestart
    Enable-WindowsOptionalFeature -FeatureName IIS-HttpRedirect -Online -All -LimitAccess -NoRestart
    Enable-WindowsOptionalFeature -FeatureName IIS-ApplicationDevelopment -Online -All -LimitAccess -NoRestart
    Enable-WindowsOptionalFeature -FeatureName IIS-NetFxExtensibility45 -Online -All -LimitAccess -NoRestart
    Enable-WindowsOptionalFeature -FeatureName IIS-HealthAndDiagnostics -Online -All -LimitAccess -NoRestart
    Enable-WindowsOptionalFeature -FeatureName IIS-HttpLogging -Online -All -LimitAccess -NoRestart
    Enable-WindowsOptionalFeature -FeatureName IIS-LoggingLibraries -Online -All -LimitAccess -NoRestart
    Enable-WindowsOptionalFeature -FeatureName IIS-RequestMonitor -Online -All -LimitAccess -NoRestart
    Enable-WindowsOptionalFeature -FeatureName IIS-HttpTracing -Online -All -LimitAccess -NoRestart
    Enable-WindowsOptionalFeature -FeatureName IIS-Security -Online -All -LimitAccess -NoRestart
    Enable-WindowsOptionalFeature -FeatureName IIS-RequestFiltering -Online -All -LimitAccess -NoRestart
    Enable-WindowsOptionalFeature -FeatureName IIS-IPSecurity -Online -All -LimitAccess -NoRestart
    Enable-WindowsOptionalFeature -FeatureName IIS-Performance -Online -All -LimitAccess -NoRestart
    Enable-WindowsOptionalFeature -FeatureName IIS-HttpCompressionDynamic -Online -All -LimitAccess -NoRestart
    Enable-WindowsOptionalFeature -FeatureName IIS-WebServerManagementTools -Online -All -LimitAccess -NoRestart
    Enable-WindowsOptionalFeature -FeatureName IIS-ManagementScriptingTools -Online -All -LimitAccess -NoRestart
    Enable-WindowsOptionalFeature -FeatureName WAS-WindowsActivationService -Online -All -LimitAccess -NoRestart
    Enable-WindowsOptionalFeature -FeatureName WAS-ProcessModel -Online -All -LimitAccess -NoRestart
    Enable-WindowsOptionalFeature -FeatureName WAS-ConfigurationAPI -Online -All -LimitAccess -NoRestart
    Enable-WindowsOptionalFeature -FeatureName WCF-HTTP-Activation45 -Online -All -LimitAccess -NoRestart
    Enable-WindowsOptionalFeature -FeatureName WCF-TCP-Activation45 -Online -All -LimitAccess -NoRestart
    Enable-WindowsOptionalFeature -FeatureName IIS-StaticContent -Online -All -LimitAccess -NoRestart
    Enable-WindowsOptionalFeature -FeatureName IIS-DefaultDocument -Online -All -LimitAccess -NoRestart
    Enable-WindowsOptionalFeature -FeatureName IIS-DirectoryBrowsing -Online -All -LimitAccess -NoRestart
    Enable-WindowsOptionalFeature -FeatureName IIS-WebSockets -Online -All -LimitAccess -NoRestart
    Enable-WindowsOptionalFeature -FeatureName IIS-ApplicationInit -Online -All -LimitAccess -NoRestart
    Enable-WindowsOptionalFeature -FeatureName IIS-ASPNET45 -Online -All -LimitAccess -NoRestart
    Enable-WindowsOptionalFeature -FeatureName IIS-ISAPIExtensions -Online -All -LimitAccess -NoRestart
    Enable-WindowsOptionalFeature -FeatureName IIS-ISAPIFilter -Online -All -LimitAccess -NoRestart
    Enable-WindowsOptionalFeature -FeatureName IIS-CustomLogging -Online -All -LimitAccess -NoRestart
    Enable-WindowsOptionalFeature -FeatureName IIS-HttpCompressionStatic -Online -All -LimitAccess -NoRestart
    Enable-WindowsOptionalFeature -FeatureName IIS-ManagementConsole -Online -All -LimitAccess -NoRestart
    Enable-WindowsOptionalFeature -FeatureName IIS-ManagementService -Online -All -LimitAccess -NoRestart
    Enable-WindowsOptionalFeature -FeatureName IIS-WindowsAuthentication -Online -All -LimitAccess -NoRestart
}
