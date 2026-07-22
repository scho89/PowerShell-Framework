function Decode-Base64String {
    [CmdletBinding()]
    param(
        [Parameter(
            Mandatory,
            ValueFromPipeline,
            ValueFromPipelineByPropertyName
        )]
        [Alias("InputObject")]
        [string]$Base64String
    )

    process {
        try {
            [Text.Encoding]::UTF8.GetString(
                [Convert]::FromBase64String($Base64String)
            )
        }
        catch {
            Write-Error "Invalid Base64: $Base64String"
        }
    }
}
