<#
.SYNOPSIS
Install the Hyper-V features on Windows 10.
.DESCRIPTION
Generally, I don't use Hyper-V because I perfer VirtualBox and the two don't play nice together.  However, this
script can be used on a machine where Hyper-V is desired (for instance when Docker is going to be used).  [I usually use
Linux, as it is superior, especially for Docker use.]
.NOTES
Name       : Install-Hyper-V-Features
Version    : 1.0.0 11/13/2017 Brennan Fee
                - First release
Author     : Brennan Fee
#>
[cmdletBinding(SupportsShouldProcess = $true)]
param(
)

# To query installed features:  Get-WindowsOptionalFeature -Online | where {$_.State -eq "Enabled"} | select FeatureName

Enable-WindowsOptionalFeature -FeatureName Containers -Online -All -LimitAccess -NoRestart
Enable-WindowsOptionalFeature -FeatureName Microsoft-Hyper-V-All -Online -All -LimitAccess -NoRestart
Enable-WindowsOptionalFeature -FeatureName Microsoft-Hyper-V -Online -All -LimitAccess -NoRestart
Enable-WindowsOptionalFeature -FeatureName Microsoft-Hyper-V-All-Tools-All -Online -All -LimitAccess -NoRestart
Enable-WindowsOptionalFeature -FeatureName Microsoft-Hyper-V-Management-PowerShell -Online -All -LimitAccess -NoRestart
Enable-WindowsOptionalFeature -FeatureName Microsoft-Hyper-V-Management-Clients -Online -All -LimitAccess -NoRestart
Enable-WindowsOptionalFeature -FeatureName Microsoft-Hyper-V-Hypervisor -Online -All -LimitAccess -NoRestart
Enable-WindowsOptionalFeature -FeatureName Microsoft-Hyper-V-Services -Online -All -LimitAccess -NoRestart
Enable-WindowsOptionalFeature -FeatureName HostGuardian -Online -All -LimitAccess -NoRestart
