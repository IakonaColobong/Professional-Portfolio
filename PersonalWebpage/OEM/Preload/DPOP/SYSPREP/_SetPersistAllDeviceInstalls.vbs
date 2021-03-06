'_SetPersistAllDeviceInstalls.vbs .\SysprepXml\%Br%\Sysprep.xml false

Option Explicit
Dim objXMLDoc, Root
Dim FSO
Dim arg_c


arg_c=WScript.Arguments.Length
WScript.Echo "arg_c=" & arg_c
If arg_c = 2 Then
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
	Dim ndTempE, ndShowPBtnOnSS
	Dim strUpdateValue : strUpdateValue = WScript.Arguments.Item(1)
	WScript.Echo "SET the PersistAllDeviceInstalls status is [" & strUpdateValue & "]"
	WScript.Echo "Finding [generalize] settings..."
	Set ndSettings = Root.selectNodes("settings")
	WScript.Echo "ndSettings.count=" & ndSettings.length
	For Each ndSetting in ndSettings
		REM ndavSetting = ndSetting.Attributes(0).NodeValue
		ndavSetting = ndSetting.getAttribute("pass")
		WScript.Echo "-------------------------------------------------------------------------"
		WScript.Echo "ndavSetting=" & ndavSetting
		If StrComp(LCase(ndavSetting), "generalize", vbTextCompare)=0 Then
			WScript.Echo "Finding [Microsoft-Windows-PnpSysprep]"
			Set ndComponts = ndSetting.selectNodes("component")
			For Each ndCompont in ndComponts
				REM ndavCompont = ndCompont.Attributes(0).NodeValue
				ndavCompont = ndCompont.getAttribute("name")
				WScript.Echo "-------------------------------------------------------------------------"
				WScript.Echo "ndavCompont=" & ndavCompont
				If StrComp(LCase(ndavCompont), "Microsoft-Windows-PnpSysprep", vbTextCompare)=0 Then
					WScript.Echo "Checking Microsoft-Windows-PnpSysprep"
					Set ndShowPBtnOnSS = ndCompont.SelectSingleNode("PersistAllDeviceInstalls")
					If (ndShowPBtnOnSS) Is Nothing Then
						WScript.Echo "ndCompont.PersistAllDeviceInstalls is Nothing, Add Element."
						Set ndTempE = objXMLDoc.createElement("PersistAllDeviceInstalls")
						ndTempE.text = strUpdateValue
						ndCompont.appendChild(ndTempE)						
					Else
						WScript.Echo "ndCompont.PersistAllDeviceInstalls is not Nothing"
						ndShowPBtnOnSS.text = strUpdateValue
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
	'[Randomize function]
	'Initializes the random-number generator.
	'Randomize uses number to initialize the Rnd function's random-number generator, giving it a new seed value. 
	'If you omit number, the value returned by the system timer is used as the new seed value.
	Randomize
	dim tmpFile : tmpFile = Year(Now()) & "Y" & Month(Now()) & "M" & Day(Now()) & "D" & Hour(Now()) & "H" & Minute(Now()) & "M" & Second(Now()) & "S" & (Int((1000*Rnd)+1)) & "R"
	WScript.Echo "Backup " & Unattend_xml_path & " as " & Unattend_xml_path & "." & tmpFile
	FSO.CopyFile Unattend_xml_path, Unattend_xml_path & "." & tmpFile
	WScript.Echo "[SUB END] BackupXML()"
	WScript.Echo
End Sub