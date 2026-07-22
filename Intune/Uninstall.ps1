[CmdletBinding()]
param()

$destinationRoot = 'C:\ProgramData\Company\PowerShell'

if (Test-Path -LiteralPath $destinationRoot) {
    Remove-Item -Path $destinationRoot -Recurse -Force
    Write-Output ("Removed {0}" -f $destinationRoot)
}
else {
    Write-Output ("Path does not exist: {0}" -f $destinationRoot)
}
