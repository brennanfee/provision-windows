#!/usr/bin/env powershell.exe

Import-Module -DisableNameChecking "$PSScriptRoot\..\Utilities\FileAndRegistryUtilities.psm1"

$key = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer'

# Show file extensions
Set-RegistryInt "$key\Advanced" "HideFileExt" 0

# Show hidden files, folders, and drives
Set-RegistryInt "$key\Advanced" "Hidden" 1

# Disable showing protected OS files
Set-RegistryInt "$key\Advanced" "ShowSuperHidden" 0

# Show the full path in the title bar of explorer
Set-RegistryInt "$key\CabinetState" "FullPath" 1

# Hide Ribbon in Explorer
Set-RegistryInt "$key\Ribbon" "MinimizedStateTabletModeOff" 1

# Run explorer sessions in separate processes
Set-RegistryInt "$key\Advanced" "SeparateProcess" 1

# Use "Peek" to preview desktop when hovered over bottom-right
Set-RegistryInt "$key\Advanced" "DisablePreviewDesktop" 0

# Turn off "Show sync provider notifications" (advertising)
Set-RegistryInt "$key\Advanced" "ShowSyncProviderNotifications" 0

