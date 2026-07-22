function Format-Xml {
    param(
        [Parameter(ValueFromPipeline)]
        [string]$Xml
    )

    $doc = New-Object System.Xml.XmlDocument
    $doc.LoadXml($Xml)

    $settings = [System.Xml.XmlWriterSettings]::new()
    $settings.Indent = $true
    $settings.IndentChars = "  "
    $settings.OmitXmlDeclaration = $true

    $sw = [System.IO.StringWriter]::new()
    $writer = [System.Xml.XmlWriter]::Create($sw, $settings)

    $doc.Save($writer)
    $writer.Close()

    $sw.ToString()
}
