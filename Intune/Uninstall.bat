@echo off
REM M365 PowerShell Framework Intune Uninstaller
REM This script is executed by Intune Win32 app removal

REM Run the PowerShell uninstall script
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0Uninstall.ps1"

REM Capture exit code
if %ERRORLEVEL% equ 0 (
    echo Uninstallation succeeded
    exit /b 0
) else (
    echo Uninstallation failed with code %ERRORLEVEL%
    exit /b 1
)
