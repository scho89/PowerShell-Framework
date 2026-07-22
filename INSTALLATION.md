# Installation Guide

## Per-User Installation (Recommended)

Each user installs the framework individually in their own profile.

### Quick Start

1. **Download or clone the repository**

2. **Run the installer:**
   ```powershell
   .\Intune\Install.ps1
   ```

3. **Restart PowerShell** ⚠️ IMPORTANT!
   - Close the current PowerShell window completely
   - Open a new PowerShell window
   - The framework will load automatically
   
   **OR** reload the profile in current session:
   ```powershell
   . $PROFILE
   ```

4. **Verify installation:**
   ```powershell
   Get-Command Connect-M365
   ```

**Log File:**
```
$HOME\Documents\PowerShell\Framework-Install.log
```

### Verification

```powershell
# Check installation
Get-Content "$HOME\Documents\PowerShell\Framework-Install.log"

# Test command availability
Get-Command Connect-M365
```

### Customization

Users can customize the framework by editing files in their installation directory:
- `$HOME\Documents\PowerShell\Framework\Profile.d\` - Profile scripts
- `$HOME\Documents\PowerShell\Framework\Functions\` - Custom functions
- `$HOME\Documents\PowerShell\Framework\Modules\` - Custom modules

Changes are isolated to each user and don't affect others.

### Uninstall

```powershell
.\Intune\Uninstall.ps1
```

This removes:
- Framework files from `$HOME\Documents\PowerShell\Framework`
- Load command from the user's PowerShell profile

## Intune Win32 Deployment (Optional)

For enterprise deployment via Intune, build a Win32 package:

### Build Package

```powershell
cd .\Intune
.\Build-IntunePackage.ps1
```

See [Intune/README.md](Intune/README.md) for detailed instructions.

### Intune Configuration

**Install command**: `Install.bat`
**Uninstall command**: `Uninstall.ps1`
**Detection script**: `Detection.ps1`

### Deployment Behavior

- Installs per-user to `$HOME\Documents\PowerShell\Framework`
- Updates only the individual user's PowerShell profile
- Each user has independent installation and customization
- No administrator privileges required (regular user context)

### Automatic Logging

Installation logs are created per user at:
```
$HOME\Documents\PowerShell\Framework-Install.log
$HOME\Documents\PowerShell\Framework-Uninstall.log
```

**To verify on target machine:**
```powershell
Get-Content "$HOME\Documents\PowerShell\Framework-Install.log"
```

## What Gets Installed

The installation process copies:

- `CompanyProfile.ps1` - Main profile loader
- `Profile.d/` - Initialization scripts (aliases, modules, PSReadLine, prompt)
- `Functions/` - All PowerShell functions
- `Modules/` - Custom modules
- Documentation files
- `Version.txt` - Version tracking

**Installation Location**: `$HOME\Documents\PowerShell\Framework`

**Example for user 'john'**: `C:\Users\john\Documents\PowerShell\Framework`

## Automatic Profile Integration

The installer automatically adds the framework to the user's PowerShell profile:

**User Profile Path**:
- PowerShell 7+: `$PROFILE.CurrentUserCurrentHost`
- Windows PowerShell 5.1: `$PROFILE.CurrentUserCurrentHost`

**Load Command**:
```powershell
. '$HOME\Documents\PowerShell\Framework\CompanyProfile.ps1'
```

This is added only to the individual user's profile, not shared system-wide.

## Uninstallation

To remove the framework:

```powershell
.\Intune\Uninstall.ps1
```

This will:
- Remove the load command from the user's PowerShell profile
- Delete the installation directory (`$HOME\Documents\PowerShell\Framework`)

## Validation

After installation:

1. **Launch PowerShell** - Framework should load automatically
2. **Check prompt** - Should show timestamp and execution time
3. **Test command** - Run `Get-Command Connect-M365`
4. **Verify location** - `$HOME\Documents\PowerShell\Framework` should exist
5. **Check log** - Review `$HOME\Documents\PowerShell\Framework-Install.log`
