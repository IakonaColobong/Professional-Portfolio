'_GDRAppendChildtoSysprep.xml.vbs sysprep.xml oobeSystem  Microsoft-Windows-Shell-Setup StartTiles/PromoteOEMTiles true

Option Explicit
Dim objXMLDoc, Root, WshShell
Dim FSO
Dim arg_c
Dim strUpdateValue, brandName



arg_c=WScript.Arguments.Length
WScript.Echo "arg_c=" & arg_c
If arg_c = 1 Then
	Set FSO = CreateObject("Scripting.FileSystemObject")

	Dim Unattend_xml_path : Unattend_xml_path=Trim(WScript.Arguments.Item(0))
	WScript.Echo "unattend_xml_path="&unattend_xml_path
	BackupXML()

	Set objXMLDoc = CreateObject("Microsoft.XMLDOM")
	objXMLDoc.async = False
	WScript.Echo "Loading XMLDOM"
	objXMLDoc.load(unattend_xml_path)

	Set Root = objXMLDoc.documentElement
	WScript.Echo "Root.namespaceURI="&Root.namespaceURI

	REM On Error Resume Next
	WriteIntoUnattendXML()

	objXMLDoc.save(unattend_xml_path)
Else
		WScript.Echo "Numbers of arguments incorrect."
End If
Set objXMLDoc = Nothing
Set FSO = Nothing

Sub WriteIntoUnattendXML()
	WScript.Echo
	WScript.Echo "[SUB START]WriteIntoUnattendXML()"	
	Dim ndSettings, ndSetting, ndavSetting, ndCompont, ndComponts, ndavCompont
	Dim ndTempE, eleTxtNewLine
	Dim ndStartTiles, ndComponentElem
	WScript.Echo "Finding settings..."	
	Set ndSettings = Root.selectNodes("settings")
	WScript.Echo "ndSettings.count=" & ndSettings.length
	For Each ndSetting in ndSettings
		REM ndavSetting = ndSetting.Attributes(0).NodeValue		
		ndavSetting = ndSetting.getAttribute("pass")
		WScript.Echo "-------------------------------------------------------------------------"
		WScript.Echo "ndavSetting=" & ndavSetting
		If StrComp(LCase(ndavSetting), "oobesystem", vbTextCompare)=0 Then
			WScript.Echo "Checking oobesystem"
			Set ndComponts = ndSetting.selectNodes("component")
			For Each ndCompont in ndComponts
				REM ndavCompont = ndCompont.Attributes(0).NodeValue
				ndavCompont = ndCompont.getAttribute("name")
				WScript.Echo "-------------------------------------------------------------------------"
				WScript.Echo "ndavCompont=" & ndavCompont
				If StrComp(LCase(ndavCompont), "microsoft-windows-shell-setup", vbTextCompare)=0 Then
					WScript.Echo "Checking microsoft-windows-shell-setup"
					If (ndCompont.SelectSingleNode("StartTiles")) Is Nothing Then
						WScript.Echo "ndCompont.StartTiles is Nothing"
						Set ndTempE = objXMLDoc.createElement("StartTiles")
						ndCompont.appendChild(ndTempE)
						Set eleTxtNewLine = objXMLDoc.createTextNode(vbCRLF)
						ndCompont.appendChild(eleTxtNewLine)
					Else
						WScript.Echo "ndCompont.StartTiles is not Nothing"
					End If

					Set ndStartTiles = ndCompont.SelectSingleNode("StartTiles")
					Set ndComponentElem = ndStartTiles.SelectSingleNode("PromoteOEMTiles")
					If (ndComponentElem) Is Nothing Then
							WScript.Echo "ndStartTiles.PromoteOEMTiles is Nothing"
							Set ndComponentElem = objXMLDoc.createElement("PromoteOEMTiles")
							ndComponentElem.text = "true"
							ndStartTiles.appendChild(ndComponentElem)
					Else
						ndComponentElem.text = "true"						
					End If
				End If
			Next
		End If
	Next
	WScript.Echo "[SUB END]WriteIntoUnattendXML()"
	WScript.Echo
End Sub


Sub BackupXML()
	WScript.Echo
	WScript.Echo "[SUB START] BackupXML()"
	dim tmpFile : tmpFile = Year(Now()) & "Y" & Month(Now()) & "M" & Day(Now()) & "D" & Hour(Now()) & "H" & Minute(Now()) & "M" & Second(Now()) & "S"
	WScript.Echo "Backup " & Unattend_xml_path & " as " & Unattend_xml_path & "." & tmpFile
	FSO.CopyFile Unattend_xml_path, Unattend_xml_path & "." & tmpFile
	WScript.Echo "[SUB END] BackupXML()"
	WScript.Echo
End Sub