# This script disables unwanted Windows services. If you do not want to disable
# certain services comment out the corresponding lines below.

$services = @(
    "diagnosticshub.standardcollector.service" # Microsoft (R) Diagnostics Hub Standard Collector Service
    "DiagTrack"                                # Diagnostics Tracking Service
    "MapsBroker"                               # Downloaded Maps Manager, who uses Bing for maps?
    "RemoteAccess"                             # Routing and Remote Access
    "RemoteRegistry"                           # Remote Registry
    "WMPNetworkSvc"                            # Windows Media Player Network Sharing Service
    "ALG"                                      # Application Layer Gateway Service
    "irmon"                                    # Infrared Monitor Service (for transfering files with IR)
    "SharedAccess"                             # Internet Connection Sharing (ICS), not needed any more
    "iphlpsvc"                                 # IP Helper (old IPv6 helper techs)
    "IpxlatCfgSvc"                             # IP Translation Configuration Service (old IPv6 helper techs)
    "RetailDemo"                               # Retail Demo Service, odd this isn't disabled by default
    "icssvc"                                   # Windows Mobile Hotspot Service, only needed on devices with cellular data
    "WwanSvc"                                  # WWAN AutoConfig, only needed on devices with cellular data
)

foreach ($service in $services) {
    Write-Output "Trying to disable $service"
    Get-Service -Name $service | Set-Service -StartupType Disabled
}
