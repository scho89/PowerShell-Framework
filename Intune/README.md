# Intune Deployment & Auto-Update

## Overview

This folder contains scripts for deploying and maintaining the PowerShell-Framework through Intune:

1. **Win32 Package Deployment** - One-time installation via `.intunewin` package
   - Build, package, and deploy the complete framework
   
2. **Automatic Updates** - Periodic version checks and automatic installation via Remediation Scripts
   - Detect when updates are available on GitHub
   - Automatically download and install latest version
   - Keep devices in compliance with latest framework version

## Build the Win32 Package

This section describes how to build an Intune Win32 application package (.intunewin) for the M365 PowerShell Framework.

## Contents

- **Install.ps1** - Installation script executed during Intune deployment
- **Uninstall.ps1** - Uninstall script for package removal
- **Detection.ps1** - Detection script for Intune to determine if the app is installed
- **Build-IntunePackage.ps1** - PowerShell script to build the .intunewin package
- **Build-IntunePackage.bat** - Batch wrapper for easy execution
- **Remediation-Detection.ps1** - Detects if update is available (GitHub version check)
- **Remediation-Remediate.ps1** - Downloads and installs latest version automatically
- **REMEDIATION.md** - Guide for auto-update setup using Intune Remediation Scripts

## Prerequisites

- Windows OS (required by IntuneWinAppUtil)
- PowerShell 5.1 or later
- Internet connection (to download IntuneWinAppUtil automatically)
- Administrator privileges (for local testing only; Intune deployment handles privileges)

## Building the Package

### Option 1: Double-click (Easiest)
```
Double-click Build-IntunePackage.bat
```

### Option 2: PowerShell Command Line
```powershell
.\Build-IntunePackage.ps1
```

### Option 3: Custom Output Path
```powershell
.\Build-IntunePackage.ps1 -OutputPath "C:\MyPackages"
```

## Build Process

1. **Script prepares package files**
2. **IntuneWinAppUtil GUI launches** - You'll see a dialog window
3. **In the dialog:**
   - Source folder is pre-filled: `C:\Users\<username>\AppData\Local\Temp\IntuneWinAppUtil\PackageSource`
   - Setup file is pre-filled: `Install.bat`
   - Output folder is pre-filled: `<project>\output`
4. **Click "Create"** to build the package
5. **Script monitors for the .intunewin file** and renames it with a timestamp

## Installation Behavior

When deployed via Intune:

- Installs **per-user** to `$HOME\Documents\PowerShell\Framework`
- Each user gets their own independent copy
- User's PowerShell profile is automatically updated
- No administrator privileges required
- Installation logs: `$HOME\Documents\PowerShell\Framework-Install.log`

## What the Script Does

1. **Checks for IntuneWinAppUtil** - Downloads from Microsoft if not present
2. **Prepares package content**:
   - Copies all Intune scripts (Install.ps1, Uninstall.ps1, Detection.ps1)
   - **Includes entire M365 PowerShell Framework**:
     - CompanyProfile.ps1
     - Functions/ (all PowerShell functions)
     - Profile.d/ (profile scripts)
     - Modules/ (optional modules)
     - README.md and documentation
   - Creates Install.bat wrapper (required by IntuneWinAppUtil)
3. **Launches IntuneWinAppUtil GUI** with pre-filled paths
4. **Monitors for output** and renames the package with timestamp
5. **Saves to output/** directory:
   - Named as: `PowerShell-Framework_YYYYMMDD-HHMMSS.intunewin`

## Output

The generated `.intunewin` file can be uploaded to Microsoft Intune:

1. Go to Microsoft Intune Admin Center
2. Select **Apps > All apps > New**
3. Choose **Windows app (Win32)**
4. Upload the `.intunewin` file
5. **Install command**: `Install.bat`
6. **Uninstall command**: `Uninstall.ps1`
7. **Detection script**: `Detection.ps1` (File or folder detection rule)
   - Path: `$env:USERPROFILE\Documents\PowerShell\Framework\Version.txt`
   - Detection method: File exists
8. Configure installation context as needed

## Troubleshooting

### Script execution policy error
```powershell
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope CurrentUser
```

### IntuneWinAppUtil download fails
- Check internet connection
- Manually download from: https://github.com/microsoft/Microsoft-Win32-Content-Prep-Tool/raw/master/IntuneWinAppUtil.exe
- Place in `$env:TEMP\IntuneWinAppUtil\`

### Detection Script Not Working
Ensure Detection.ps1 returns proper exit codes:
- Exit 0 = App is installed
- Any other exit code = App is not installed

## Notes

- This script is designed for local/manual builds
- For automated CI/CD, consider using GitHub Actions with Windows runners
- The build output includes the source folder structure and all dependencies

## Troubleshooting

### Installation Failed

Check the installation log:
```powershell
Get-Content "$HOME\Documents\PowerShell\Framework-Install.log"
```

### Common Issues

**Issue**: "Access Denied" errors
- **Cause**: Profile directory doesn't exist or no write permissions
- **Solution**: Ensure `$HOME\Documents\PowerShell\` is writable; run fresh PowerShell session

**Issue**: Version.txt not created
- **Cause**: Source path not found in package or file copy error
- **Solution**: Check the install log for specific error messages

**Issue**: Profile not loading automatically
- **Cause**: Profile file not created or load command not added correctly
- **Solution**: Check install log; verify `$PROFILE` path exists and is readable

**Issue**: Intune deployment shows success but app not detected
- **Cause**: Detection script doesn't match installation path
- **Solution**: Verify detection path: `$env:USERPROFILE\Documents\PowerShell\Framework\Version.txt`

## Intune Deployment Best Practices

1. **Test locally first**: Run `Install.bat` without admin rights to match user context
2. **Monitor deployment**: Check device health and app assignment status
3. **Verify detection**: Run `Detection.ps1` to confirm installation
4. **Review logs**: Check installation log on target machines
5. **User context**: Deploy in **user context** to avoid permission issues

### CMTrace Log Location

After Intune deployment, check logs at:
```
C:\Windows\CCM\Logs\AppIntentEval.log
C:\Windows\CCM\Logs\AppsDeploymentClient.log
```

Check per-user logs at:
```
$env:USERPROFILE\Documents\PowerShell\Framework-Install.log
```

## Automatic Updates with Remediation Scripts

For **automatic version updates without Win32 redeployment**, use Intune Remediation Scripts.

### How It Works

1. **Detection Script** (`Remediation-Detection.ps1`)
   - Checks installed version vs. latest GitHub release
   - Runs on configurable schedule (daily, weekly, etc.)

2. **Remediation Script** (`Remediation-Remediate.ps1`)
   - Automatically downloads and installs latest version when update detected
   - Runs in user context
   - Handles cleanup and logging

### Quick Setup

1. **Configure GitHub Details**
   ```powershell
   # Edit both Remediation scripts
   $GitHubOwner = "your-github-username"
   $GitHubRepo = "PowerShell-Framework"
   ```

2. **Deploy to Intune**
   - Intune Admin Center > Devices > Remediation Scripts
   - Upload Detection script
   - Upload Remediation script
   - Set frequency (recommended: Daily or Weekly)
   - Assign to device groups

3. **GitHub Releases**
   - Update Version.txt in repository
   - Create GitHub Release tag (v1.0.1, etc.)
   - Remediation automatically detects and installs

### Benefits

✅ **Automatic Updates** - No user intervention needed
✅ **Version Control** - GitHub is source of truth
✅ **Compliance Tracking** - Intune reports on framework version
✅ **Rollback Capable** - Can revert to previous versions
✅ **User Context** - Isolated per-user updates
✅ **Full Logging** - Audit trail for compliance

### See Also

For complete setup instructions, troubleshooting, and best practices:
→ **[REMEDIATION.md](REMEDIATION.md)**
