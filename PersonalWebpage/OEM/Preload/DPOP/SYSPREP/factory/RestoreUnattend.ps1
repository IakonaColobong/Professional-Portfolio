$AuditalaunchPath=$args[0]
[xml] $xdoc_Auditalaunch =  get-content  "$AuditalaunchPath" -Encoding UTF8
[xml] $xdoc_Useralaunch =  get-content  "C:\OEM\Preload\DPOP\Sysprep\factory\sysprep.xml" -Encoding UTF8


$ns = New-Object System.Xml.XmlNamespaceManager($xdoc_Auditalaunch.NameTable)
$ns.AddNamespace("ns", $xdoc_Auditalaunch.DocumentElement.NamespaceURI)
$node = $xdoc_Auditalaunch.SelectSingleNode("//ns:RunSynchronous", $ns)
$node.ParentNode.RemoveChild($node)


$UNCount = $xdoc_Auditalaunch.unattend.ChildNodes.Count
Write-Output "[PS] [Offline Unattend or Auditalaunch] ChildNodes.Count is $UNCount"
for($i=0; $i -le $UNCount; $i++){
    if ($xdoc_Auditalaunch.unattend.ChildNodes.Item($i).pass -eq "specialize") {
        $xdoc_Useralaunch.DocumentElement.InsertBefore($xdoc_Useralaunch.ImportNode($xdoc_Auditalaunch.unattend.ChildNodes.Item($i), $true),$xdoc_Useralaunch.DocumentElement.FirstChild)
        #$xdoc_Useralaunch.DocumentElement.AppendChild($xdoc_Useralaunch.ImportNode($xdoc_Auditalaunch.unattend.ChildNodes.Item($i), $true))
    }
}


$SModeXML = "C:\OEM\Preload\DPOP\SYSPREP\factory\AutoUnattendForSMode.xml"
if (Test-Path $SModeXML) {
	Write-Output "[PS] $SModeXML exist, Insert <Microsoft-Windows-CodeIntegrity><SkuPolicyRequired> to factory sysprep.xml"
	[xml] $xdoc_SMode =  get-content  "C:\OEM\Preload\DPOP\SYSPREP\factory\AutoUnattendForSMode.xml" -Encoding UTF8
	$UNCount = $xdoc_SMode.unattend.ChildNodes.Count
	Write-Output "[PS] [S Mode] ChildNodes.Count is $UNCount"
	for($i=0; $i -le $UNCount; $i++){
		if ($xdoc_SMode.unattend.ChildNodes.Item($i).pass -eq "offlineServicing") {
			$xdoc_Useralaunch.DocumentElement.InsertBefore($xdoc_Useralaunch.ImportNode($xdoc_SMode.unattend.ChildNodes.Item($i), $true),$xdoc_Useralaunch.DocumentElement.FirstChild)
			#$xdoc_Useralaunch.DocumentElement.AppendChild($xdoc_Useralaunch.ImportNode($xdoc_Auditalaunch.unattend.ChildNodes.Item($i), $true))
		}
	}
} else {
	Write-Output "[PS] $SModeXML NOT be found, skip to insert <SkuPolicyRequired>."
}


$xdoc_Useralaunch.Save("RestoreUnattend.xml")