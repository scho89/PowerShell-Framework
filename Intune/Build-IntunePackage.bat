@echo off
REM Build Intune package wrapper
REM Usage: Build-IntunePackage.bat [output_path]

setlocal enabledelayedexpansion

REM Run PowerShell script
if "%1"=="" (
    powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0Build-IntunePackage.ps1"
) else (
    powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0Build-IntunePackage.ps1" -OutputPath "%1"
)

echo.
echo Build completed. Press any key to exit.
pause
