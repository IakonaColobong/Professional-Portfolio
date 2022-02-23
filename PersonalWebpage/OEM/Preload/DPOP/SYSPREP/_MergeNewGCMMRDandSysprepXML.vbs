option explicit
'CScript.exe /nologo _MergeNewGCMMRDandSysprepXML.vbs specialize Microsoft-Windows-Shell-Setup NotificationArea NAMRD.xml Sysprep.xml
'CScript.exe /nologo _MergeNewGCMMRDandSysprepXML.vbs specialize Microsoft-Windows-MicrosoftEdgeBrowser FavoriteBarItems FVMRD.xml Sysprep.xml
'CScript.exe /nologo _MergeNewGCMMRDandSysprepXML.vbs oobeSystem Microsoft-Windows-Shell-Setup TaskbarLinks TBMRD.xml Sysprep.xml

DIM arg_c
DIM strSettingPass, strTargetNode, strComponent
DIM ndComponts, ndCompont
DIM ndTempE, eleTxtNewLine, ndNAs, ndNA, ndItem
DIM Root
Dim FSO : SET FSO = CreateObject("Scripting.FileSystemObject")

arg_c=WScript.Arguments.Length
WScript.Echo "arg_c=" & arg_c
IF (arg_c=5) Then
	strSettingPass = Trim(WScript.Arguments.Item(0))
	Wscript.Echo "Processing the Setting Pass is [" & strSettingPass & "]"
	strComponent = Trim(WScript.Arguments.Item(1))
	Wscript.Echo "Processing the Component is [" & strComponent & "]......"
	strTargetNode = Trim(WScript.Arguments.Item(2))
	Wscript.Echo "Processing the node is [" & strTargetNode & "]......"
	

	DIM xmlSourcePath: xmlSourcePath = Trim(WScript.Arguments.Item(3))
	Wscript.Echo "The Source XML is " & xmlSourcePath
	DIM objXMLDoc1: Set objXMLDoc1 = CreateObject("Msxml2.DOMDocument")
	objXMLDoc1.setProperty "SelectionLanguage", "XPath"
	objXMLDoc1.async = false
	objXMLDoc1.load(xmlSourcePath)
	
	DIM xmlDESTPath: xmlDESTPath = Trim(WScript.Arguments.Item(4))
	Wscript.Echo "The Target XML is " & xmlDESTPath
	WScript.Echo
	
	BackupXML()
	
	DIM objXMLDoc2: Set objXMLDoc2 = CreateObject("Msxml2.DOMDocument")
	Dim sNS : sNS = "xmlns:uuu='urn:schemas-microsoft-com:unattend'"
	objXMLDoc2.setProperty "SelectionLanguage", "XPath"
	objXMLDoc2.setProperty "SelectionNamespaces", sNS
	objXMLDoc2.async = false
	objXMLDoc2.load(xmlDESTPath)
	'Just get the XML Doc2 Info
	Set Root = objXMLDoc2.documentElement
	WScript.Echo "Root.namespaceURI = "&Root.namespaceURI
	'move the Navigator to strTargetNode
	Wscript.Echo "selectNodes at settings[@pass='" & strSettingPass & "']/component[@name='" & strComponent & "']"
	Set ndComponts = objXMLDoc2.selectNodes("//uuu:settings[@pass='" & strSettingPass & "']/uuu:component[@name='" & strComponent & "']")
	Wscript.Echo "Found suitable " & ndComponts.length & " component."
	For each ndCompont in ndComponts
		Wscript.Echo "Compont.text: " & ndCompont.text
		Wscript.Echo
		'checking strTargetNode node if exist. if yes, remove it
		IF ndCompont.selectSingleNode("//" & strTargetNode) is Nothing Then
			Wscript.Echo "//" & strTargetNode & " Not found, Check //uuu:" & strTargetNode & "......."
		ELSE
			WScript.Echo "//" & strTargetNode & " is exist, remove it!"
			Set ndTempE = ndCompont.selectSingleNode("//" & strTargetNode)
			ndCompont.removeChild ndTempE
		End IF

		IF ndCompont.selectSingleNode("//uuu:" & strTargetNode) is Nothing Then
			Wscript.Echo "//uuu:" & strTargetNode & " Not found, start to merge XML..."
		ELSE
			WScript.Echo "//uuu:" & strTargetNode & " is exist, remove it."
			Set ndTempE = ndCompont.selectSingleNode("//uuu:" & strTargetNode)
			ndCompont.removeChild ndTempE
		End IF
		WScript.Echo "appendChild [" & strTargetNode & "] to sysprep.xml"
		Set ndNAs = objXMLDoc1.selectNodes("//" & strTargetNode)
		For each ndNA in ndNAs
			ndCompont.appendChild ndNA
		Next
	Next
	objXMLDoc2.save(xmlDESTPath)
Else
		WScript.Echo "Numbers of arguments incorrect."
End IF
SET FSO = nothing
SET objXMLDoc1 = nothing
SET objXMLDoc2 = nothing


Sub BackupXML()
	WScript.Echo
	WScript.Echo "[SUB START] BackupXML()"
	dim tmpFile : tmpFile = Year(Now()) & "Y" & Month(Now()) & "M" & Day(Now()) & "D" & Hour(Now()) & "H" & Minute(Now()) & "M" & Second(Now()) & "S"
	WScript.Echo "Backup " & xmlDESTPath & " as " & xmlDESTPath & "." & tmpFile
	FSO.CopyFile xmlDESTPath, xmlDESTPath & "." & tmpFile
	WScript.Echo "[SUB END] BackupXML()"
	WScript.Echo
End Sub
