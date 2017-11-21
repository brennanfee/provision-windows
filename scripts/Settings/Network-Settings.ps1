# Trun all network connections to "Private"
Get-NetConnectionProfile | Set-NetConnectionProfile -NetworkCategory Private
