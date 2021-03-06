Option Explicit
Dim objXMLDoc, Root, WshShell
Dim i, arg_c
Dim bAV


arg_c=WScript.Arguments.Length
WScript.Echo "arg_c=" & arg_c
If arg_c = 2 Then 
		
		bAV = Trim(WScript.Arguments.Item(1))
		WScript.Echo "Set DisableAntiSpyware =[" & bAV & "]"
				
		Dim Unattend_xml_path : Unattend_xml_path=Trim(WScript.Arguments.Item(0))
		WScript.Echo "unattend_xml_path="&unattend_xml_path

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


Sub WriteIntoUnattendXML()
	WScript.Echo "[SUB START] WriteIntoUnattendXML() for DisableAntiSpyware"

	Dim theSettingNode
	set theSettingNode = Nothing
	Dim ndSettings, ndSetting
	WScript.Echo "Finding settings"
	Set ndSettings = Root.selectNodes("settings")
	WScript.Echo "ndSettings.count=" & ndSettings.length
	For each ndSetting IN ndSettings
		WScript.Echo "Checking " & ndSetting.getAttribute("pass")
		if StrComp(Trim(LCase(ndSetting.getAttribute("pass"))), "specialize") = 0 Then
			WScript.Echo "Found specialize Setting"
			Set theSettingNode = ndSetting
		End If
	Next
	
	Dim theComponentNode
	set theComponentNode = Nothing
	Dim ndComponents, ndComponent
	WScript.Echo "Finding settings/component"
	Set ndComponents = theSettingNode.selectNodes("component")
	WScript.Echo "ndComponents.count="&ndComponents.length
	For each ndComponent IN ndComponents
			WScript.Echo "Checking " & ndComponent.getAttribute("name")
			if StrComp(Trim(LCase(ndComponent.getAttribute("name"))), "security-malware-windows-defender") = 0 Then
				WScript.Echo "Found security-malware-windows-defender"
				Set theComponentNode = ndComponent
			End If
	Next
	If theComponentNode is Nothing Then
		WScript.Echo "Creating COMPONMENT Security Malware Windows Defender"
		Set theComponentNode = objXMLDoc.createNode(1, "component", Root.namespaceURI)

		WScript.Echo "Creating COMPONMENT Attributes"
		Dim cmpnt_name_attr, cmpnt_processorArchitecture_attr, cmpnt_publicKeyToken_attr, cmpnt_language_attr, cmpnt_versionScope_attr, cmpnt_xmlns_wcm_attr, cmpnt_xmlns_xsi_attr
		Set cmpnt_name_attr =                  objXMLDoc.createAttribute("name")
		Set cmpnt_processorArchitecture_attr = objXMLDoc.createAttribute("processorArchitecture")
		Set cmpnt_publicKeyToken_attr =        objXMLDoc.createAttribute("publicKeyToken")
		Set cmpnt_language_attr =              objXMLDoc.createAttribute("language")
		Set cmpnt_versionScope_attr =          objXMLDoc.createAttribute("versionScope")
		Set cmpnt_xmlns_wcm_attr =             objXMLDoc.createAttribute("xmlns:wcm")
		Set cmpnt_xmlns_xsi_attr =             objXMLDoc.createAttribute("xmlns:xsi")

		WScript.Echo "Setting COMPONMENT Attributes: name"
		theComponentNode.setAttribute "name", "Security-Malware-Windows-Defender"
		
		WScript.Echo "Setting COMPONMENT Attributes: processorArchitecture"
		Set WshShell = CreateObject("WScript.Shell")
		WScript.Echo "processorArchitecture = " & LCase(WshShell.Environment("Process")("PROCESSOR_ARCHITECTURE"))
		theComponentNode.setAttribute "processorArchitecture", LCase(WshShell.Environment("Process")("PROCESSOR_ARCHITECTURE"))

		WScript.Echo "Setting COMPONMENT Attributes: publicKeyToken"
		theComponentNode.setAttribute "publicKeyToken", "31bf3856ad364e35"

		WScript.Echo "Setting COMPONMENT Attributes: language"
		theComponentNode.setAttribute "language", "neutral"

		WScript.Echo "Setting COMPONMENT Attributes: versionScope"
		theComponentNode.setAttribute "versionScope", "nonSxS"

		WScript.Echo "Setting COMPONMENT Attributes: xmlns:wcm"
		theComponentNode.setAttribute "xmlns:wcm", "http://schemas.microsoft.com/WMIConfig/2002/State"

		WScript.Echo "Setting COMPONMENT Attributes: xmlns:xsi"
		theComponentNode.setAttribute "xmlns:xsi", "http://www.w3.org/2001/XMLSchema-instance"
		
		WScript.Echo "Append COMPONMENT Security Malware Windows Defender"
		theSettingNode.appendChild(theComponentNode)
		
	End If

	
	'<settings pass="specialize">
	'<component name="Security-Malware-Windows-Defender" processorArchitecture="x86" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS" xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
	'	<DisableAntiSpyware>TRUE</DisableAntiSpyware>
	'</component>

	
	Dim ndDisableAntiSpywares, ndDisableAntiSpyware, strStatus
	WScript.Echo "Finding settings/component/DisableAntiSpyware"
	Set ndDisableAntiSpywares = theComponentNode.selectNodes("DisableAntiSpyware")
	WScript.Echo "ndDisableAntiSpywares.count="&ndDisableAntiSpywares.length
	strStatus = bAV
	WScript.Echo "Status=" & strStatus
	If ndDisableAntiSpywares.length < 1 Then
		Set ndDisableAntiSpyware = objXMLDoc.createNode(1, "DisableAntiSpyware", Root.namespaceURI)
		ndDisableAntiSpyware.text = strStatus
		theComponentNode.appendChild(ndDisableAntiSpyware)
	End If
	For Each ndDisableAntiSpyware IN ndDisableAntiSpywares
		ndDisableAntiSpyware.text = strStatus
	Next
	
	
	WScript.Echo "[SUB END] WriteIntoUnattendXML() for DisableAntiSpyware"
End Sub