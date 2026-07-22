[CmdletBinding()]
param()

<#
.SYNOPSIS
    Remediation script for M365-PowerShell-Framework
    Downloads and installs the latest version from GitHub

.DESCRIPTION
    This script is executed by Intune when the Detection script returns exit code 1.
    It will:
    1. Download the latest release from GitHub
    2. Extract to temporary location
    3. Run Install.ps1 to update the framework
    4. Clean up temporary files

.NOTES
    Configure these variables before deployment:
    - $GitHubOwner: Your GitHub username
    - $GitHubRepo: Repository name (default: PowerShell-Framework)
#>

# ===== CONFIGURATION =====
# Change these to your GitHub repository details
$GitHubOwner = "your-github-username"      # TODO: Update with your GitHub username
$GitHubRepo = "PowerShell-Framework"

# Paths
$userProfilePath = $env:USERPROFILE
$tempDir = Join-Path -Path $env:TEMP -ChildPath "M365-Framework-Update-$(Get-Random)"
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
    Write-Log "Remediation: Update Framework"
    Write-Log "========================================="
    Write-Log "User: $env:USERNAME"
    Write-Log "Temp directory: $tempDir"

    # Get latest release info from GitHub
    Write-Log "Fetching latest release from GitHub..."
    $apiUrl = "https://api.github.com/repos/$GitHubOwner/$GitHubRepo/releases/latest"
    $releaseInfo = Invoke-RestMethod -Uri $apiUrl -ErrorAction Stop
    
    $latestVersion = $releaseInfo.tag_name -replace '^v', ''
    Write-Log "Latest version: $latestVersion"

    # Find the source code zip download URL
    $downloadUrl = $releaseInfo.zipball_url
    if (-not $downloadUrl) {
        throw "Could not find download URL in release"
    }
    Write-Log "Download URL: $downloadUrl"

    # Create temp directory
    if (-not (Test-Path -LiteralPath $tempDir)) {
        New-Item -Path $tempDir -ItemType Directory -Force | Out-Null
    }

    # Download the release
    Write-Log "Downloading release..."
    $zipFile = Join-Path -Path $tempDir -ChildPath "release.zip"
    Invoke-WebRequest -Uri $downloadUrl -OutFile $zipFile -ErrorAction Stop
    Write-Log "✓ Download complete: $zipFile"

    # Extract the zip file
    Write-Log "Extracting files..."
    $extractPath = Join-Path -Path $tempDir -ChildPath "extract"
    New-Item -Path $extractPath -ItemType Directory -Force | Out-Null
    
    Expand-Archive -Path $zipFile -DestinationPath $extractPath -ErrorAction Stop
    Write-Log "✓ Extraction complete"

    # Find the extracted folder (GitHub creates owner-repo-hash folder)
    $extractedFolder = Get-ChildItem -Path $extractPath -Directory | Select-Object -First 1
    if (-not $extractedFolder) {
        throw "Could not find extracted folder"
    }
    
    Write-Log "Extracted folder: $($extractedFolder.FullName)"

    # Locate Install.ps1 in the extracted content
    $installScript = Get-ChildItem -Path $extractedFolder.FullName -Recurse -Filter "Install.ps1" | Select-Object -First 1
    if (-not $installScript) {
        throw "Could not find Install.ps1 in release"
    }

    Write-Log "Found Install.ps1: $($installScript.FullName)"
    Write-Log "Running installation..."

    # Execute Install.ps1
    & $installScript.FullName -ErrorAction Stop
    
    if ($LASTEXITCODE -eq 0) {
        Write-Log "✓ Installation completed successfully"
        Write-Log "Updated to version: $latestVersion"
    }
    else {
        throw "Installation script returned exit code $LASTEXITCODE"
    }

    Write-Log "========================================="
    Write-Log "✓ Update completed successfully"
    Write-Log "========================================="

    exit 0
}
catch {
    Write-Log "ERROR during remediation: $($_.Exception.Message)"
    Write-Log "Stack Trace: $($_.ScriptStackTrace)"
    Write-Log "========================================="
    exit 1
}
finally {
    # Cleanup temporary files
    if (Test-Path -LiteralPath $tempDir) {
        Write-Log "Cleaning up temporary files..."
        Remove-Item -Path $tempDir -Recurse -Force -ErrorAction SilentlyContinue
        Write-Log "✓ Cleanup complete"
    }
}
