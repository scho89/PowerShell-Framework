[CmdletBinding()]
param()

$destinationRoot = 'C:\ProgramData\Company\PowerShell'
$sourceRoot = Split-Path -Parent $PSScriptRoot

if (-not (Test-Path -LiteralPath $destinationRoot)) {
    New-Item -Path $destinationRoot -ItemType Directory -Force | Out-Null
}

Get-ChildItem -Path $sourceRoot -Force | Where-Object { $_.Name -ne '.git' } | ForEach-Object {
    Copy-Item -Path $_.FullName -Destination $destinationRoot -Recurse -Force
}

$versionSourcePath = Join-Path -Path $sourceRoot -ChildPath 'Version.txt'
$versionDestinationPath = Join-Path -Path $destinationRoot -ChildPath 'Version.txt'

if (-not (Test-Path -LiteralPath $versionDestinationPath)) {
    Set-Content -Path $versionDestinationPath -Value '1.0.0' -Encoding UTF8
}

Write-Output ("Installed M365-PowerShell-Framework to {0}" -f $destinationRoot)
