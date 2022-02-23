	Option Explicit
DIM arg_c, i
Dim GCMBundleXMLFile, xmlDoc
DIM PromNodes, objPromNode
DIM fso, ProductName, path, checkpid

arg_c=WScript.Arguments.Length
IF (arg_c=2) Then
	Set xmlDoc = CreateObject("MSXML2.DomDocument.6.0")
	xmlDoc.Async = "False"
	GCMBundleXMLFile = Trim(WScript.Arguments.Item(0))
	checkpid = Trim(WScript.Arguments.Item(1))
	xmlDoc.Load(GCMBundleXMLFile)
	Set fso = CreateObject("Scripting.FileSystemObject")

	'Finding the Office 2013 pid
	'2014/7/16 Rhea
	'GCM may define Office 2013 as "Office 2013 (for Tablet) or Office 2014 for Tablet or else."
	'Use contains function to find the matched string
	WScript.Echo "[VBS] Checking [" & checkpid & "]....."
	Set PromNodes=xmlDoc.selectNodes("//SCL/Programs/Program[contains(@pid,'" & checkpid & "')]")
	WScript.Echo "[VBS] PromNodes.Length is " & PromNodes.Length
	IF PromNodes.Length > 0 Then
		For i = 0 To PromNodes.Length - 1
			ProductName = PromNodes(i).getAttribute("Product")
			Wscript.Echo "[VBS] Get Product is [" & ProductName & "]"
			Wscript.Quit(9)
		Next
	ELSE
		Wscript.Echo "[VBS][" & checkpid & "] not found!"
		Wscript.Quit(4)
	End IF
	Wscript.Echo
Else
	WScript.Echo arg_c
	WScript.Echo "Numbers of arguments incorrect."
End IF

Set fso=Nothing
Set xmlDoc=Nothing