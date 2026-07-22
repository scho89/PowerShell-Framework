if (Get-Module -ListAvailable -Name PSReadLine) {
    if ($PSVersionTable.PSVersion.Major -ge 7) {
        Set-PSReadLineOption -PredictionSource History
    }
    Set-PSReadLineOption -EditMode Windows
}
