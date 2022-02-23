	Option Explicit
DIM arg_c, i
Dim GCMBundleXMLFile, xmlDoc
Dim strFindingRegion
DIM PromNodes, objPromNode
DIM fso, pid, path
Dim exitcode : exitcode = 0


arg_c=WScript.Arguments.Length
IF (arg_c=2) Then
	Set xmlDoc = CreateObject("MSXML2.DomDocument.6.0")
	xmlDoc.Async = "False"
	GCMBundleXMLFile= Trim(WScript.Arguments.Item(0))
	strFindingRegion= Trim(WScript.Arguments.Item(1))
	xmlDoc.Load(GCMBundleXMLFile)
	Set fso = CreateObject("Scripting.FileSystemObject")
	Set PromNodes=xmlDoc.selectNodes("//SCL/Regions/Region[@name='" & strFindingRegion & "']")
	WScript.Echo "[VBS] PromNodes.Length is " & PromNodes.Length
	IF PromNodes.Length > 0 Then
		WScript.Echo "[VBS] Found GCM name=" & strFindingRegion & ", exitcode = 9"		
		exitcode = 9
	Else
		WScript.Echo "[VBS] GCM name=" & strFindingRegion & " not found. exitcode = 4"		
		exitcode = 4
	End IF
	Wscript.Echo
Else
	WScript.Echo arg_c
	WScript.Echo "Numbers of arguments incorrect."
End IF

Set fso=Nothing
Set xmlDoc=Nothing
Wscript.Quit(exitcode)