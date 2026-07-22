@echo off
REM M365 PowerShell Framework Intune Installer
REM This script is executed by Intune Win32 app deployment
REM Must run with SYSTEM privileges to write to ProgramData

REM Run the PowerShell installation script
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0Install.ps1"

REM Capture exit code
if %ERRORLEVEL% equ 0 (
    echo Installation succeeded
    exit /b 0
) else (
    echo Installation failed with code %ERRORLEVEL%
    exit /b 1
)
