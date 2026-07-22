[CmdletBinding()]
param()

$versionPath = 'C:\ProgramData\Company\PowerShell\Version.txt'

if (Test-Path -LiteralPath $versionPath) {
    Write-Output 'M365-PowerShell-Framework detected.'
    exit 0
}

Write-Output 'M365-PowerShell-Framework not detected.'
exit 1
