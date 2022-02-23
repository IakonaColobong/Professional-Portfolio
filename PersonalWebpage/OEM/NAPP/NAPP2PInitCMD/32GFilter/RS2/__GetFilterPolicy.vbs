Option Explicit
DIM arg_c, i
Dim GCMBundleXMLFile, xmlDoc
DIM PromNodes, objPromNode
DIM fso, pid, path, objFile

arg_c=WScript.Arguments.Length
IF (arg_c=1) Then
	Set xmlDoc = CreateObject("MSXML2.DomDocument.6.0")
	xmlDoc.Async = "False"
	GCMBundleXMLFile= Trim(WScript.Arguments.Item(0))
	xmlDoc.Load(GCMBundleXMLFile)
	Set fso = CreateObject("Scripting.FileSystemObject")

	'Finding the APP's pid
	'2014/7/16 Rhea
	'GCM may define Office 2016 as "Office 2016 (for Tablet) or Office 2016 for Tablet or else."
	'Use contains function to find the matched string
	Set PromNodes=xmlDoc.selectNodes("//SCL/Programs/Program[contains(@Product,'32G App filter_RS2')]")
	WScript.Echo "PromNodes.Length is " & PromNodes.Length
	IF PromNodes.Length > 0 Then
		For i = 0 To PromNodes.Length - 1
			pid = PromNodes(i).getAttribute("pid")
			Wscript.Echo "32G App filter_RS2 is [" & pid & "]"
			path = ".\32GAppFilterRS2_Found.tag"
			set objFile = fso.CreateTextFile(path,True)
			objFile.Write "32G App filter_RS2 is [" & pid & "]" & vbCrLf
			objFile.Close
		Next
	Else
		Wscript.Echo "Can not find [32G App filter_RS2]. leave"
	End IF
	Wscript.Echo
Else
	WScript.Echo arg_c
	WScript.Echo "Numbers of arguments incorrect."
End IF

Set fso=Nothing
Set xmlDoc=Nothing