#!/usr/bin/env powershell.exe

Write-Host "Installing guest additions..."
cmd /c "$env:ALLUSERSPROFILE\Chocolatey\choco.exe" install -y 7zip.portable

if (-Not (Test-Path "$env:TEMP\VBoxGuestAdditions.iso")) {
    Write-Host "Downloading"
    $virtualBoxVersion="5.1.30"
    (New-Object System.Net.WebClient).DownloadFile("http://download.virtualbox.org/virtualbox/$virtualBoxVersion/VBoxGuestAdditions_$virtualBoxVersion.iso", "$env:TEMP\VBoxGuestAdditions.iso")
}

Write-Host "Unzip the ISO"
cmd /c "$env:ALLUSERSPROFILE\chocolatey\bin\7z.exe" x "$env:TEMP\VBoxGuestAdditions.iso" "-o$env:TEMP\virtualbox"

Write-Host "Install the cert"
cmd /c "$env:SYSTEMROOT\System32\certutil.exe" -addstore -f "TrustedPublisher" "$env:TEMP\virtualbox\cert\oracle-vbox.cer"

Write-Host "Install the Guest Additions"
cmd /c "$env:TEMP\virtualbox\VBoxWindowsAdditions.exe" /S /with_wddm /xres=1024 /yres=768

Write-Host "Clean up"
Remove-Item "$env:TEMP\VBoxGuestAdditions.iso"
Remove-Item "$env:TEMP\virtualbox\*" -recurse
