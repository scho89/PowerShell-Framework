function Send-Text {
    param(
        [Parameter(Mandatory)]
        [string]$Text,

        [int]$DelaySeconds = 3
    )

    Add-Type -AssemblyName System.Windows.Forms

    Start-Sleep -Seconds $DelaySeconds
    [System.Windows.Forms.SendKeys]::SendWait($Text)
}
