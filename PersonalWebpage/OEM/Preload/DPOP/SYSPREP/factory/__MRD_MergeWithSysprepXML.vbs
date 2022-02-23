option explicit
'CScript.exe /nologo UpdateStartScreenXML.vbs Layout_AIO_AAP.xml Sysprep.xml

DIM arg_c
DIM ndComponts, ndCompont
DIM ndTempE, eleTxtNewLine, ndStartTiles, ndStartTile, ndItem
DIM Root


WScript.Echo VbCr
WScript.Echo VbCr
arg_c=WScript.Arguments.Length
WScript.Echo "arg_c=" & arg_c
IF (arg_c=2) Then
	DIM xmlSourcePath: xmlSourcePath = Trim(WScript.Arguments.Item(0))
	Wscript.Echo "Source XML is " & xmlSourcePath
	DIM objXMLDoc1: Set objXMLDoc1 = CreateObject("Msxml2.DOMDocument")
	objXMLDoc1.setProperty "SelectionLanguage", "XPath"
	objXMLDoc1.async = false
	objXMLDoc1.load(xmlSourcePath)

	WScript.Echo VbCr

	DIM xmlDESTPath: xmlDESTPath = Trim(WScript.Arguments.Item(1))
	Wscript.Echo "Target XML is " & xmlDESTPath
	DIM objXMLDoc2: Set objXMLDoc2 = CreateObject("Msxml2.DOMDocument")
	Dim sNS : sNS = "xmlns:uuu='urn:schemas-microsoft-com:unattend'"
	objXMLDoc2.setProperty "SelectionLanguage", "XPath"
	objXMLDoc2.setProperty "SelectionNamespaces", sNS
	objXMLDoc2.async = false
	objXMLDoc2.load(xmlDESTPath)
	'Just get the XML Doc2 Info
	Set Root = objXMLDoc2.documentElement
	WScript.Echo "Root.namespaceURI = "&Root.namespaceURI
	'move the Navigator to StartTiles
	Wscript.Echo "selectNodes at settings[@pass='oobeSystem']/component[@name='Microsoft-Windows-Shell-Setup']"
	Set ndComponts = objXMLDoc2.selectNodes("//uuu:settings[@pass='oobeSystem']/uuu:component[@name='Microsoft-Windows-Shell-Setup']")
	Wscript.Echo "Found suitable " & ndComponts.length & " component."
	For each ndCompont in ndComponts
		Wscript.Echo "Compont.text: " & ndCompont.text
		Wscript.Echo VbCr
		'checking StartTiles node if exist. if yes, remove it
		IF ndCompont.selectSingleNode("//StartTiles") is Nothing Then
			Wscript.Echo "//StartTiles Not found, Check //uuu:StartTiles......."			
		ELSE
			WScript.Echo "//StartTiles is exist, remove it!"
			Set ndTempE = ndCompont.selectSingleNode("//StartTiles")
			ndCompont.removeChild ndTempE			
		End IF
		
		IF ndCompont.selectSingleNode("//uuu:StartTiles") is Nothing Then
			Wscript.Echo "//uuu:StartTiles Not found, start to merge XML..."				
		ELSE
			WScript.Echo "//uuu:StartTiles is exist, remove it."
			Set ndTempE = ndCompont.selectSingleNode("//uuu:StartTiles")
			ndCompont.removeChild ndTempE
		End IF
		
		Set ndStartTiles = objXMLDoc1.selectNodes("//StartTiles")
		For each ndStartTile in ndStartTiles
			ndCompont.appendChild ndStartTile
		Next
	Next
	objXMLDoc2.save(xmlDESTPath)
Else
		WScript.Echo "Numbers of arguments incorrect."
End IF