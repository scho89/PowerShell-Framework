#!/usr/bin/env pwsh

<#
.SYNOPSIS
    Build Intune Win32 package (.intunewin) for M365 PowerShell Framework

.DESCRIPTION
    Downloads IntuneWinAppUtil if needed and creates an Intune Win32 application package
    from the Intune folder contents.

.EXAMPLE
    .\Build-IntunePackage.ps1
    
.NOTES
    Requires Windows OS and administrative privileges
    IntuneWinAppUtil will be downloaded automatically if not present
#>

param(
    [string]$OutputPath = "$PSScriptRoot\..\output",
    [string]$ToolsPath = "$env:TEMP\IntuneWinAppUtil"
)

# Ensure we're on Windows
if ($PSVersionTable.Platform -eq 'Unix') {
    Write-Error "This script requires Windows PowerShell"
    exit 1
}

# Create output directory
if (-not (Test-Path -LiteralPath $OutputPath)) {
    Write-Verbose "Creating output directory: $OutputPath"
    New-Item -Path $OutputPath -ItemType Directory -Force | Out-Null
}

# Download IntuneWinAppUtil if needed
function Get-IntuneWinAppUtil {
    param(
        [string]$ToolsPath
    )
    
    $exePath = Join-Path -Path $ToolsPath -ChildPath "IntuneWinAppUtil.exe"
    
    if (Test-Path -LiteralPath $exePath) {
        Write-Verbose "IntuneWinAppUtil already present at $exePath"
        return $exePath
    }
    
    Write-Host "Downloading IntuneWinAppUtil..." -ForegroundColor Green
    
    if (-not (Test-Path -LiteralPath $ToolsPath)) {
        New-Item -Path $ToolsPath -ItemType Directory -Force | Out-Null
    }
    
    # Download from Microsoft
    $url = "https://github.com/microsoft/Microsoft-Win32-Content-Prep-Tool/raw/master/IntuneWinAppUtil.exe"
    $downloadPath = Join-Path -Path $ToolsPath -ChildPath "IntuneWinAppUtil.exe"
    
    try {
        Invoke-WebRequest -Uri $url -OutFile $downloadPath -ErrorAction Stop
        Write-Verbose "Downloaded to $downloadPath"
    }
    catch {
        Write-Error "Failed to download IntuneWinAppUtil: $_"
        exit 1
    }
    
    return $downloadPath
}

# Create package content directory
$packageSourcePath = Join-Path -Path $ToolsPath -ChildPath "PackageSource"
if (Test-Path -LiteralPath $packageSourcePath) {
    Remove-Item -Path $packageSourcePath -Recurse -Force
}
New-Item -Path $packageSourcePath -ItemType Directory -Force | Out-Null

# Copy Intune scripts to package source
Write-Host "Preparing package content..." -ForegroundColor Green
Copy-Item -Path "$PSScriptRoot\Install.ps1" -Destination $packageSourcePath -Force
Copy-Item -Path "$PSScriptRoot\Install.bat" -Destination $packageSourcePath -Force
Copy-Item -Path "$PSScriptRoot\Uninstall.ps1" -Destination $packageSourcePath -Force
Copy-Item -Path "$PSScriptRoot\Uninstall.bat" -Destination $packageSourcePath -Force
Copy-Item -Path "$PSScriptRoot\Detection.ps1" -Destination $packageSourcePath -Force

# Copy entire framework (required by Install.ps1)
Write-Host "Including framework files..." -ForegroundColor Green
$frameworkRoot = Join-Path -Path $PSScriptRoot -ChildPath ".."

@(
    'CompanyProfile.ps1',
    'README.md',
    'INSTALLATION.md',
    'DEVELOPMENT.md',
    'CONTRIBUTING.md',
    'LICENSE',
    'Version.txt',
    'Profile.d',
    'Functions',
    'Modules'
) | ForEach-Object {
    $sourceItemPath = Join-Path -Path $frameworkRoot -ChildPath $_
    if (Test-Path -LiteralPath $sourceItemPath) {
        Write-Verbose "Including: $_"
        Copy-Item -Path $sourceItemPath -Destination $packageSourcePath -Recurse -Force
    }
}

# Create wrapper batch file for installation
$installBatContent = @"
@echo off
REM M365 PowerShell Framework Intune Installer
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0Install.ps1"
exit /b %ERRORLEVEL%
"@

$installBatPath = Join-Path -Path $packageSourcePath -ChildPath "Install.bat"
Set-Content -Path $installBatPath -Value $installBatContent -Encoding ASCII

# Get IntuneWinAppUtil
$intuneWinUtil = Get-IntuneWinAppUtil -ToolsPath $ToolsPath

# Build package
Write-Host "Building Intune package..." -ForegroundColor Green

$packageName = "PowerShell-Framework"
$timestamp = Get-Date -Format "yyyyMMdd-HHmmss"

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "IntuneWinAppUtil Instructions" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "The IntuneWinAppUtil application will open." -ForegroundColor Yellow
Write-Host "Please follow these steps:" -ForegroundColor Yellow
Write-Host ""
Write-Host "  1. Source folder:" -ForegroundColor White
Write-Host "     $packageSourcePath" -ForegroundColor Gray
Write-Host ""
Write-Host "  2. Setup file:" -ForegroundColor White
Write-Host "     Install.bat" -ForegroundColor Gray
Write-Host ""
Write-Host "  3. Output folder:" -ForegroundColor White
Write-Host "     $OutputPath" -ForegroundColor Gray
Write-Host ""
Write-Host "  4. Click [Create] to build the package" -ForegroundColor White
Write-Host ""
Write-Host "A file browser will open to the package source folder." -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Open file browser to package source
Write-Host "Opening package source folder..." -ForegroundColor Green
Start-Process explorer.exe -ArgumentList $packageSourcePath

try {
    # Launch IntuneWinAppUtil
    Write-Host "Launching IntuneWinAppUtil..." -ForegroundColor Green
    Start-Process -FilePath $intuneWinUtil -Wait
    
    # Wait for file to be created
    Write-Host "Monitoring for package creation..." -ForegroundColor Cyan
    
    $maxRetries = 10
    $retryCount = 0
    $intunewinFile = $null
    
    while ($retryCount -lt $maxRetries) {
        Start-Sleep -Seconds 1
        $intunewinFile = Get-ChildItem -Path $OutputPath -Filter "*.intunewin" -ErrorAction SilentlyContinue | Sort-Object LastWriteTime -Descending | Select-Object -First 1
        
        if ($intunewinFile) {
            break
        }
        $retryCount++
    }
    
    if ($intunewinFile) {
        # Rename with timestamp
        $newName = "{0}_{1}.intunewin" -f $packageName, $timestamp
        $newPath = Join-Path -Path $OutputPath -ChildPath $newName
        
        # Handle case where file might still be in use
        try {
            Rename-Item -Path $intunewinFile.FullName -NewName $newName -Force
        }
        catch {
            $newPath = $intunewinFile.FullName
        }
        
        Write-Host ""
        Write-Host "[OK] Package created successfully!" -ForegroundColor Green
        Write-Host "  Output: $newPath" -ForegroundColor Cyan
        
        $fileSize = (Get-Item $newPath).Length / 1MB
        Write-Host ("  Size: {0:N2} MB" -f $fileSize) -ForegroundColor Cyan
        
        Write-Host ""
        Write-Host "The package is ready to upload to Microsoft Intune." -ForegroundColor Green
    }
    else {
        Write-Host ""
        Write-Warning "No .intunewin file was created."
        Write-Host "This could happen if:" -ForegroundColor Yellow
        Write-Host "  - You cancelled the IntuneWinAppUtil dialog" -ForegroundColor Yellow
        Write-Host "  - The package creation failed in IntuneWinAppUtil" -ForegroundColor Yellow
        Write-Host ""
        Write-Host "Please check the output folder:" -ForegroundColor Cyan
        Write-Host "  $OutputPath" -ForegroundColor Gray
        Write-Host ""
        Start-Process explorer.exe -ArgumentList $OutputPath
    }
}
catch {
    Write-Error "Failed to launch IntuneWinAppUtil: $_"
    exit 1
}

# Cleanup
Write-Verbose "Cleaning up temporary files..."
Remove-Item -Path $packageSourcePath -Recurse -Force -ErrorAction SilentlyContinue

Write-Host "Build complete!" -ForegroundColor Green
