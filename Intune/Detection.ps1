[CmdletBinding()]
param()

$userProfilePath = $env:USERPROFILE
$versionPath = Join-Path -Path $userProfilePath -ChildPath 'Documents\PowerShell\Framework\Version.txt'
$installLogPath = Join-Path -Path $userProfilePath -ChildPath 'Documents\PowerShell\Framework-Install.log'
$frameworkPath = Join-Path -Path $userProfilePath -ChildPath 'Documents\PowerShell\Framework'

# Detection logic
if (Test-Path -LiteralPath $versionPath) {
    $version = Get-Content -Path $versionPath -Raw -ErrorAction SilentlyContinue
    Write-Output "M365-PowerShell-Framework detected. Version: $($version.Trim())"
    Write-Output "Installed at: $frameworkPath"
    exit 0
}
elseif (Test-Path -LiteralPath $frameworkPath) {
    Write-Output "M365-PowerShell-Framework installation directory found but incomplete."
    Write-Output "Expected path: $versionPath"
    if (Test-Path -LiteralPath $installLogPath) {
        Write-Output "Check log: $installLogPath"
    }
    exit 1
}
else {
    Write-Output "M365-PowerShell-Framework not detected."
    Write-Output "Expected path: $frameworkPath"
    exit 1
}
