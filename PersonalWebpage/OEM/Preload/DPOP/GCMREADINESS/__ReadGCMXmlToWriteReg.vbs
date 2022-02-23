Option Explicit
DIM arg_c
DIM strRegPath
Dim GCMBundleXMLFile, xmlDoc, colNodes, objNode, FFNodes, objFFNode
DIM IMNodes, objIMNode
DIM strMRDPageID, strMRDVersion
DIM WshShell
arg_c=WScript.Arguments.Length
IF (arg_c=2) Then
	strRegPath = Trim(WScript.Arguments.Item(0))
	Set xmlDoc = CreateObject("Microsoft.XMLDOM")
	xmlDoc.Async = "False"
	GCMBundleXMLFile = Trim(WScript.Arguments.Item(1))
	xmlDoc.Load(GCMBundleXMLFile)
	Set colNodes = xmlDoc.selectNodes ("//SCL")
	Set WshShell= CreateObject("WScript.Shell")
	'Set MRDPAGE-id and MRDVersion
	For Each objNode in colNodes
		strMRDPageID = objNode.Attributes.getNamedItem("MRDPAGE-id").Text
		Wscript.Echo "Get MRD Page-id is " & strMRDPageID
		WScript.Echo "WshShell.RegWrite " & strRegPath & "\OEM\GCMReadiness\MRDPAGE-id, " & strMRDPageID & ", REG_SZ"
		WshShell.RegWrite strRegPath & "\OEM\GCMReadiness\MRDPAGE-id", strMRDPageID, "REG_SZ"

		strMRDVersion = objNode.Attributes.getNamedItem("MRDVersion").Text
		Wscript.Echo "Get MRD Version is " & strMRDVersion
		Wscript.Echo "WshShell.RegWrite " & strRegPath & "\OEM\GCMReadiness\MRDVersion, " & strMRDVersion & ", REG_SZ"
		WshShell.RegWrite strRegPath & "\OEM\GCMReadiness\MRDVersion", strMRDVersion, "REG_SZ"
		Wscript.Echo "WshShell.RegWrite " & strRegPath & "\OEM\Metadata\GCM\MRD, " & strMRDVersion & ", REG_SZ"
		WshShell.RegWrite strRegPath & "\OEM\Metadata\GCM\MRD", strMRDVersion, "REG_SZ"
	Next
	
	'Set FormFactor
	Set FFNodes=xmlDoc.selectNodes ("//SCL/MRD_FormFactor")
	For Each objFFNode in FFNodes
		Wscript.Echo "Get FormFactor is " & objFFNode.Text
		Wscript.Echo "WshShell.RegWrite " & strRegPath & "\OEM\GCMReadiness\FormFactor, " & objFFNode.Text & ", REG_SZ"
		WshShell.RegWrite strRegPath & "\OEM\GCMReadiness\FormFactor", objFFNode.Text, "REG_SZ"
		Wscript.Echo "WshShell.RegWrite " & strRegPath & "\OEM\Metadata\GCM\FF, " & objFFNode.Text & ", REG_SZ"
		WshShell.RegWrite strRegPath & "\OEM\Metadata\GCM\FF", objFFNode.Text, "REG_SZ"
	Next
	
	'Set IMNodes=xmlDoc.selectNodes ("//SCL/MRD_IMAGE_MODIFIERS_SHIPPED")
	'For Each objIMNode in IMNodes
	'	Wscript.Echo "Get MRD_IMAGE_MODIFIERS_SHIPPED is [" & objIMNode.Text & "]"
	'	If Len(objIMNode.Text) > 0 Then
	'		Wscript.Echo "SET the " & objIMNode.Text & " data is TRUE"
	'		WshShell.RegWrite "HKLM\Software\OEM\GCMReadiness\IM\" & objIMNode.Text, "TRUE", "REG_SZ"		
	'	End If
	'Next	
	Wscript.Echo
Else
	WScript.Echo arg_c
	WScript.Echo "Numbers of arguments incorrect."
End IF

Set WshShell=Nothing
Set xmlDoc=Nothing