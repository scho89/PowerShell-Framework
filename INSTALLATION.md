# Installation Guide

## Intune Win32 Deployment Model

Package this repository content as a Win32 application and use the included scripts:

- **Install command**: `powershell.exe -ExecutionPolicy Bypass -File .\Intune\Install.ps1`
- **Uninstall command**: `powershell.exe -ExecutionPolicy Bypass -File .\Intune\Uninstall.ps1`
- **Detection rule script**: `Intune\Detection.ps1`

## Installation Behavior

`Install.ps1`:

1. Creates `C:\ProgramData\Company\PowerShell`
2. Copies framework files from the package root
3. Ensures `Version.txt` exists

## Lightweight User Profile Integration

Add the following to each engineer's profile (`$PROFILE`):

```powershell
$frameworkProfile = 'C:\ProgramData\Company\PowerShell\CompanyProfile.ps1'
if (Test-Path -LiteralPath $frameworkProfile) {
    . $frameworkProfile
}
```

## Validation

- Launch PowerShell and confirm prompt format is loaded
- Run `Get-Command Connect-M365`
- Verify `C:\ProgramData\Company\PowerShell\Version.txt` exists
