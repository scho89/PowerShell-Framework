[CmdletBinding()]
param()

<#
.SYNOPSIS
    Detection script for M365-PowerShell-Framework Remediation
    Checks if installed version matches the latest GitHub release version

.DESCRIPTION
    This script is used by Intune Remediation Scripts to detect if an update is needed.
    - Exit 0: Framework is up-to-date
    - Exit 1: Update is required

.NOTES
    Configure these variables before deployment:
    - $GitHubOwner: Your GitHub username
    - $GitHubRepo: Repository name (default: PowerShell-Framework)
#>

# ===== CONFIGURATION =====
# Change these to your GitHub repository details
$GitHubOwner = "your-github-username"      # TODO: Update with your GitHub username
$GitHubRepo = "PowerShell-Framework"

# Installation path
$userProfilePath = $env:USERPROFILE
$frameworkPath = Join-Path -Path $userProfilePath -ChildPath 'Documents\PowerShell\Framework'
$installedVersionFile = Join-Path -Path $frameworkPath -ChildPath 'Version.txt'

# Logging
$logPath = Join-Path -Path $userProfilePath -ChildPath 'Documents\PowerShell'
$logFile = Join-Path -Path $logPath -ChildPath 'Framework-Remediation.log'

function Write-Log {
    param([string]$Message)
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    "$timestamp : $Message" | Tee-Object -FilePath $logFile -Append -ErrorAction SilentlyContinue
}

try {
    # Ensure log directory exists
    if (-not (Test-Path -LiteralPath $logPath)) {
        New-Item -Path $logPath -ItemType Directory -Force | Out-Null
    }

    Write-Log "========================================="
    Write-Log "Remediation Detection: Version Check"
    Write-Log "========================================="

    # Check if framework is installed
    if (-not (Test-Path -LiteralPath $installedVersionFile)) {
        Write-Log "Framework not installed at: $frameworkPath"
        Write-Log "Remediation needed: Missing installation"
        exit 1
    }

    # Get installed version
    $installedVersion = (Get-Content -Path $installedVersionFile -Raw).Trim()
    Write-Log "Installed version: $installedVersion"

    # Get latest version from GitHub API
    Write-Log "Checking latest version from GitHub..."
    $apiUrl = "https://api.github.com/repos/$GitHubOwner/$GitHubRepo/releases/latest"
    
    $releaseInfo = Invoke-RestMethod -Uri $apiUrl -ErrorAction Stop
    $latestVersion = $releaseInfo.tag_name -replace '^v', ''  # Remove 'v' prefix if present
    
    Write-Log "Latest version: $latestVersion"

    # Compare versions
    if ([version]$installedVersion -eq [version]$latestVersion) {
        Write-Log "✓ Versions match. No remediation needed."
        Write-Log "========================================="
        exit 0
    }
    else {
        Write-Log "⚠ Version mismatch detected."
        Write-Log "  Installed: $installedVersion"
        Write-Log "  Latest: $latestVersion"
        Write-Log "Remediation needed: Update available"
        Write-Log "========================================="
        exit 1
    }
}
catch {
    Write-Log "ERROR during version check: $($_.Exception.Message)"
    Write-Log "Assuming update is needed due to error"
    Write-Log "========================================="
    
    # If we can't check, assume remediation is needed
    exit 1
}
