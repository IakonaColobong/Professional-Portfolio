$TemplateMRD = "LayoutModification_T.xml"
$SMMRD = "C:\OEM\PRELOAD\Utility\GCM\SMMRD.xml"
$MFMRD = "C:\OEM\PRELOAD\Utility\GCM\MFMRD.xml"
[xml] $xdoc_T =  get-content $TemplateMRD -Encoding UTF8


Function AddSM {
    ForEach ($XmlNode in $xdoc_SM.DocumentElement.ChildNodes) {    
        $xdoc_T.DocumentElement.AppendChild($xdoc_T.ImportNode($XmlNode, $true))
    }
}

Function AddMF {
    ForEach ($XmlNode in $xdoc_MF.DocumentElement.ChildNodes) {    
        $xdoc_T.DocumentElement.AppendChild($xdoc_T.ImportNode($XmlNode, $true))
    }
}


If (Test-Path $SMMRD) {
	[xml] $xdoc_SM =  get-content $SMMRD -Encoding UTF8
    Write-Output "[PS] $SMMRD exist, call function AddSM`n"
    AddSM
}

If (Test-Path $MFMRD) {
	[xml] $xdoc_MF =  get-content $MFMRD -Encoding UTF8
    Write-Output "[PS] $MFMRD exist, call function AddMF`n"
    AddMF
}


$xdoc_T.Save("LayoutModification.xml")