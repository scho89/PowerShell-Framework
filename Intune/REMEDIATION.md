# Intune Remediation Scripts - Auto Update

This directory contains scripts for **automatic update and maintenance** of the PowerShell-Framework using Intune's Remediation Scripts feature.

## Overview

### How It Works

1. **Detection Script** (`Remediation-Detection.ps1`)
   - Runs periodically on enrolled devices (configurable frequency)
   - Checks installed version vs. latest GitHub release
   - Returns exit code 1 if update needed, 0 if up-to-date

2. **Remediation Script** (`Remediation-Remediate.ps1`)
   - Executes automatically when Detection returns "non-compliant" (exit 1)
   - Downloads latest release from GitHub
   - Extracts and runs Install.ps1
   - Cleans up temporary files

### Benefits

✅ **Automatic Updates** - Users don't need to manually update
✅ **Version Control** - GitHub releases are the source of truth
✅ **Compliance Tracking** - Intune reports on framework version compliance
✅ **Rollback Capable** - Can deploy older versions by adjusting detection
✅ **User Context** - Runs in user session, isolated updates
✅ **Logging** - Full audit trail in `$HOME\Documents\PowerShell\Framework-Remediation.log`

## Prerequisites

1. **GitHub Repository**
   - Must be public or have access token
   - Must use releases with semantic versioning (v1.0.0, v1.0.1, etc.)
   - Source code must be accessible as zip download

2. **Version.txt Management**
   - Keep Version.txt in sync with GitHub releases
   - Use semantic versioning: MAJOR.MINOR.PATCH

3. **Intune Setup**
   - Intune subscription
   - Enrolled Windows 10/11 devices
   - User context execution permission

## Setup Steps

### 1. Configure GitHub Details

Edit both scripts and update:

```powershell
$GitHubOwner = "your-github-username"      # Your GitHub user/org
$GitHubRepo = "PowerShell-Framework"       # Repository name
```

**Location in both scripts:**
```powershell
# Line ~27 in both Remediation-Detection.ps1 and Remediation-Remediate.ps1
```

### 2. Create GitHub Releases

Every time you update Version.txt:

```bash
git tag v1.0.1
git push origin v1.0.1
```

This creates a GitHub Release that the remediation scripts will find.

### 3. Deploy to Intune

1. Go to **Intune Admin Center**
2. Select **Devices > Compliance > Remediation scripts**
3. Click **Create**
4. **General Info**:
   - Name: `M365 PowerShell Framework Update`
   - Description: `Automatically updates framework to latest version`

5. **Settings**:
   - Script file (Detection): Upload `Remediation-Detection.ps1`
   - Remediation script: Upload `Remediation-Remediate.ps1`
   - Run script in 64-bit PowerShell: Yes
   - Run as signed-in user: Yes ⚠️ IMPORTANT
   - Enforce script signature check: No (unless you sign scripts)

6. **Scope Tags**: Assign to your organization

7. **Assignments**: Select device groups to target

8. **Frequency**: 
   - Recommended: **Daily** or **Weekly**
   - Configure based on your update cadence

### 4. Verify Deployment

**On target device:**

```powershell
# Check remediation log
Get-Content "$HOME\Documents\PowerShell\Framework-Remediation.log"

# Verify installed version
Get-Content "$HOME\Documents\PowerShell\Framework\Version.txt"

# Check Intune compliance
# Intune Admin Center > Devices > Compliance > [Your Script]
```

## Version Management

### Release Workflow

1. **Update code in repository**
   ```bash
   git add .
   git commit -m "Feature: Add new functionality"
   ```

2. **Update Version.txt**
   ```
   1.0.0  →  1.0.1  (patch)
   1.0.0  →  1.1.0  (minor)
   1.0.0  →  2.0.0  (major)
   ```

3. **Create GitHub Release**
   ```bash
   git tag v1.0.1
   git push origin v1.0.1
   ```

4. **Intune Auto-Updates**
   - Next scheduled detection run (daily/weekly)
   - Remediation script downloads and installs v1.0.1
   - Framework is updated on all enrolled devices

## Troubleshooting

### Detection Script Issues

**Check the log:**
```powershell
Get-Content "$HOME\Documents\PowerShell\Framework-Remediation.log" -Tail 50
```

**Common Issues:**

| Issue | Cause | Solution |
|-------|-------|----------|
| `GitHub API rate limit` | Too many requests | Use GitHub token authentication |
| `Cannot find module` | Network blocked GitHub | Check corporate firewall/proxy |
| `Invalid version format` | Version.txt format wrong | Ensure semantic versioning (1.0.0) |
| `GitHub owner not found` | $GitHubOwner misconfigured | Verify username in script |

### Remediation Script Issues

| Issue | Cause | Solution |
|-------|-------|----------|
| `Download failed` | Network issue | Check internet connectivity |
| `Install.ps1 not found` | Release structure wrong | Ensure release contains Install.ps1 |
| `Permission denied` | User lacks write permissions | Check $HOME\Documents permissions |

### In Intune Admin Center

1. **Script not running?**
   - Check device is enrolled and online
   - Verify assignment to device groups
   - Check device logs: `Event Viewer > Applications and Services > Microsoft > Windows > DeviceManagement-Enterprise-Diagnostic-Provider`

2. **Compliance not updating?**
   - Force sync: **Device > Sync** in Company Portal
   - Wait for next scheduled run (usually within 24 hours)

3. **Rollback to previous version?**
   - Edit `Remediation-Detection.ps1`
   - Change detection logic to allow specific version
   - Deploy remediation script with Install.ps1 from older release

## Advanced Configuration

### Using GitHub Token for Private Repos

If repository is private, modify the Invoke-RestMethod calls:

```powershell
$headers = @{
    Authorization = "Bearer $GitHubToken"
}
$releaseInfo = Invoke-RestMethod -Uri $apiUrl -Headers $headers
```

### Custom Pre/Post-Update Actions

Extend `Remediation-Remediate.ps1` to add custom logic:

```powershell
# Before update
Write-Log "Backing up current configuration..."
# Add backup logic here

# ... existing update code ...

# After update
Write-Log "Running post-update tasks..."
# Add post-update logic here
```

## Monitoring & Reporting

### Intune Dashboard

**View compliance status:**
1. Intune Admin Center > Devices > Compliance
2. Select the remediation script
3. View devices by status:
   - **Compliant** - Up-to-date
   - **Non-compliant** - Update available/in progress
   - **Error** - Update failed

### Log Analysis

Collect logs from devices for analysis:

```powershell
# On each device
Get-Content "$HOME\Documents\PowerShell\Framework-Remediation.log" | 
    Select-String "ERROR|Update|Version"
```

## Best Practices

1. **Test before production**
   - Pilot remediation script to small device group first
   - Monitor logs and compliance status
   - Expand to larger groups gradually

2. **Maintain Version.txt**
   - Always keep in sync with GitHub releases
   - Use semantic versioning consistently
   - Document changes in release notes

3. **GitHub Release Notes**
   - Document each release
   - Include breaking changes
   - Provide migration guides if needed

4. **Frequency Considerations**
   - Daily: For critical security updates
   - Weekly: For regular features
   - Monthly: For stable, less frequent updates

5. **User Communication**
   - Notify users of auto-update schedule
   - Provide change logs
   - Set expectations for potential restarts

## Examples

### Example 1: Monthly Feature Release

```
Version.txt: 1.0.0
GitHub Tag: v1.0.0
Detection: Monthly check (Intune schedule)
Remediation: Auto-install on next weekly run
```

### Example 2: Urgent Security Patch

```
Version.txt: 1.0.1 (security patch)
GitHub Tag: v1.0.1
Deploy: Immediately to all devices
Frequency: Daily detection to ensure coverage
```

### Example 3: Phased Rollout

```
Week 1: Deploy to IT department (pilot group)
Week 2: Monitor logs, expand to support
Week 3: Expand to remaining teams
Frequency: Daily to catch non-compliant devices
```

## References

- [Intune Remediation Scripts](https://docs.microsoft.com/en-us/mem/intune/remote-actions/remediate-detected-issues)
- [GitHub API - Releases](https://docs.github.com/en/rest/releases)
- [PowerShell Semantic Versioning](https://semver.org/)
