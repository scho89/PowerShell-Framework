[CmdletBinding()]
param()

$destinationRoot = 'C:\ProgramData\Company\PowerShell'
$sourceRoot = Split-Path -Parent $PSScriptRoot

if (-not (Test-Path -LiteralPath $destinationRoot)) {
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
    'Modules',
    'Intune'
) | ForEach-Object {
    $sourceItemPath = Join-Path -Path $sourceRoot -ChildPath $_
    if (Test-Path -LiteralPath $sourceItemPath) {
        Copy-Item -Path $sourceItemPath -Destination $destinationRoot -Recurse -Force
    }
}

$versionSourcePath = Join-Path -Path $sourceRoot -ChildPath 'Version.txt'
$versionDestinationPath = Join-Path -Path $destinationRoot -ChildPath 'Version.txt'

if (Test-Path -LiteralPath $versionSourcePath) {
    Copy-Item -Path $versionSourcePath -Destination $versionDestinationPath -Force
}
else {
    Set-Content -Path $versionDestinationPath -Value '1.0.0' -Encoding UTF8
}

Write-Output ("Installed M365-PowerShell-Framework to {0}" -f $destinationRoot)
