[CmdletBinding()]
param()

# Setup logging
$userName = $env:USERNAME
$userProfilePath = $env:USERPROFILE
$destinationRoot = Join-Path -Path $userProfilePath -ChildPath 'Documents\PowerShell\Framework'
$logPath = Join-Path -Path $userProfilePath -ChildPath 'Documents\PowerShell'
$logFile = Join-Path -Path $logPath -ChildPath 'Framework-Install.log'

if (-not (Test-Path -LiteralPath $logPath)) {
    New-Item -Path $logPath -ItemType Directory -Force | Out-Null
}

function Write-Log {
    param([string]$Message)
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    "$timestamp : $Message" | Tee-Object -FilePath $logFile -Append
}

Write-Log "========================================="
Write-Log "M365-PowerShell-Framework Installation"
Write-Log "========================================="
Write-Log "User: $userName"
Write-Log "PowerShell Version: $($PSVersionTable.PSVersion)"
Write-Log "Destination: $destinationRoot"

$sourceRoot = Split-Path -Parent $PSScriptRoot

Write-Log "Source: $sourceRoot"

try {
    if (-not (Test-Path -LiteralPath $destinationRoot)) {
        Write-Log "Creating directory: $destinationRoot"
        New-Item -Path $destinationRoot -ItemType Directory -Force | Out-Null
    }

    @(
        'CompanyProfile.ps1',
        'README.md',
        'INSTALLATION.md',
        'DEVELOPMENT.md',
        'CONTRIBUTING.md',
        'LICENSE',
        'Profile.d',
        'Functions',
        'Modules'
    ) | ForEach-Object {
        $sourceItemPath = Join-Path -Path $sourceRoot -ChildPath $_
        if (Test-Path -LiteralPath $sourceItemPath) {
            Write-Log "Copying: $_"
            Copy-Item -Path $sourceItemPath -Destination $destinationRoot -Recurse -Force -ErrorAction Stop
        }
        else {
            Write-Log "WARNING: Source not found: $_"
        }
    }

    $versionSourcePath = Join-Path -Path $sourceRoot -ChildPath 'Version.txt'
    $versionDestinationPath = Join-Path -Path $destinationRoot -ChildPath 'Version.txt'

    if (Test-Path -LiteralPath $versionSourcePath) {
        Write-Log "Copying Version.txt"
        Copy-Item -Path $versionSourcePath -Destination $versionDestinationPath -Force -ErrorAction Stop
    }
    else {
        Write-Log "Creating default Version.txt"
        Set-Content -Path $versionDestinationPath -Value '1.0.0' -Encoding UTF8 -ErrorAction Stop
    }

    # Verify installation
    if (Test-Path -LiteralPath $versionDestinationPath) {
        Write-Log "✓ Framework files installed successfully"
    }
    else {
        throw "Installation verification failed: Version.txt not found"
    }

    # Configure user's PowerShell profile to load the framework
    Write-Log "Configuring PowerShell profile..."

    $userProfile = $PROFILE.CurrentUserCurrentHost
    
    if (-not $userProfile) {
        throw "Could not determine user profile path"
    }

    $userProfileDir = Split-Path -Parent $userProfile
    if (-not (Test-Path -LiteralPath $userProfileDir)) {
        Write-Log "Creating profile directory: $userProfileDir"
        New-Item -Path $userProfileDir -ItemType Directory -Force | Out-Null
    }

    $companyProfilePath = Join-Path -Path $destinationRoot -ChildPath 'CompanyProfile.ps1'
    $loadCommand = ". '$companyProfilePath'"

    if (Test-Path -LiteralPath $userProfile) {
        Write-Log "Updating existing profile: $userProfile"
        $profileContent = Get-Content -Path $userProfile -Raw
        
        # Check if already present
        if ($profileContent -match [regex]::Escape($loadCommand)) {
            Write-Log "Profile already contains framework load command"
        }
        else {
            Add-Content -Path $userProfile -Value "`n# M365 PowerShell Framework`n$loadCommand" -Encoding UTF8 -ErrorAction Stop
            Write-Log "✓ Profile updated"
        }
    }
    else {
        Write-Log "Creating new profile: $userProfile"
        Set-Content -Path $userProfile -Value "# M365 PowerShell Framework`n$loadCommand" -Encoding UTF8 -ErrorAction Stop
        Write-Log "✓ Profile created"
    }

    Write-Log "========================================="
    Write-Log "✓ Installation completed successfully"
    Write-Log "Framework path: $destinationRoot"
    Write-Log "Profile: $userProfile"
    Write-Log "Log file: $logFile"
    Write-Log "========================================="
    Write-Log ""
    Write-Log "IMPORTANT: You must restart PowerShell for changes to take effect!"
    Write-Log ""
    Write-Log "Choose one of the following:"
    Write-Log "  Option 1 (Recommended): Close this PowerShell window and open a new one"
    Write-Log "  Option 2: Run this in current session to reload profile:"
    Write-Log "    . `$PROFILE"
    Write-Log ""
    Write-Log "After restart, verify installation with:"
    Write-Log "  Get-Command Connect-M365"
    Write-Log ""
    
    exit 0
}
catch {
    Write-Log "ERROR: $($_.Exception.Message)"
    Write-Log "Stack Trace: $($_.ScriptStackTrace)"
    Write-Log "========================================="
    exit 1
}
