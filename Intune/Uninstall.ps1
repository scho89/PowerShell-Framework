[CmdletBinding()]
param()

# Setup logging
$userName = $env:USERNAME
$userProfilePath = $env:USERPROFILE
$destinationRoot = Join-Path -Path $userProfilePath -ChildPath 'Documents\PowerShell\Framework'
$logPath = Join-Path -Path $userProfilePath -ChildPath 'Documents\PowerShell'
$logFile = Join-Path -Path $logPath -ChildPath 'Framework-Uninstall.log'

if (-not (Test-Path -LiteralPath $logPath)) {
    New-Item -Path $logPath -ItemType Directory -Force | Out-Null
}

function Write-Log {
    param([string]$Message)
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    "$timestamp : $Message" | Tee-Object -FilePath $logFile -Append
}

Write-Log "========================================="
Write-Log "PowerShell-Framework Uninstallation"
Write-Log "========================================="
Write-Log "User: $userName"

try {
    # Remove from PowerShell profile
    Write-Log "Cleaning up PowerShell profile..."

    $userProfile = $PROFILE.CurrentUserCurrentHost
    $companyProfilePath = Join-Path -Path $destinationRoot -ChildPath 'CompanyProfile.ps1'
    $loadCommand = ". '$companyProfilePath'"

    if (Test-Path -LiteralPath $userProfile) {
        Write-Log "Reading profile: $userProfile"
        $profileContent = Get-Content -Path $userProfile -Raw -ErrorAction SilentlyContinue
        
        if ($profileContent) {
            # Remove the load command and associated comment
            $updatedContent = $profileContent -replace "(?m)^# M365 PowerShell Framework\s*\r?\n.*?$([regex]::Escape($loadCommand)).*\r?\n?", ""
            
            if ($updatedContent -ne $profileContent) {
                Write-Log "Removing framework load command from profile"
                Set-Content -Path $userProfile -Value $updatedContent -Encoding UTF8 -ErrorAction Stop
                Write-Log "[OK] Profile cleaned"
            }
            else {
                Write-Log "Framework not found in profile"
            }
        }
    }

    # Remove installation directory
    if (Test-Path -LiteralPath $destinationRoot) {
        Write-Log "Removing installation directory: $destinationRoot"
        Remove-Item -Path $destinationRoot -Recurse -Force -ErrorAction Stop
        Write-Log "[OK] Installation directory removed"
    }
    else {
        Write-Log "Installation directory not found: $destinationRoot"
    }

    Write-Log "========================================="
    Write-Log "[OK] Uninstallation completed successfully"
    Write-Log "Log file: $logFile"
    Write-Log "========================================="
    
    exit 0
}
catch {
    Write-Log "ERROR: $($_.Exception.Message)"
    Write-Log "Stack Trace: $($_.ScriptStackTrace)"
    Write-Log "========================================="
    exit 1
}
