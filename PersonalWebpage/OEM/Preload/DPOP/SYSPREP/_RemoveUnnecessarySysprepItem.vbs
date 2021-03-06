Option Explicit
Dim objXMLDoc, Root, WshShell
Dim i, arg_c
Dim modelName, brandName
Dim FSO

arg_c=WScript.Arguments.Length
WScript.Echo "arg_c=" & arg_c
If arg_c = 4 Then
		Set FSO = CreateObject("Scripting.FileSystemObject")		
		Dim Unattend_xml_path : Unattend_xml_path=Trim(WScript.Arguments.Item(0))
		WScript.Echo "unattend_xml_path="&unattend_xml_path		
			
		Set objXMLDoc = CreateObject("Microsoft.XMLDOM") 
		objXMLDoc.async = False 
		WScript.Echo "Loading XMLDOM"
		objXMLDoc.load(unattend_xml_path)

		Set Root = objXMLDoc.documentElement
		WScript.Echo "Root.namespaceURI="&Root.namespaceURI

		'RemoveNodeBy_SttngAttr_CmpnmntAttr "oobeSystem", "Microsoft-Windows-Deployment", "ExtendOSPartition"
		'RemoveNodeBy_SttngAttr_CmpnmntAttr "oobeSystem", "Microsoft-Windows-Shell-Setup", "VisualEffects"
		'RemoveNodeBy_SttngAttr_CmpnmntAttr "oobeSystem", "Microsoft-Windows-Shell-Setup", "DesktopOptimization"
		'RemoveNodeBy_SttngAttr_CmpnmntAttr "oobeSystem", "Microsoft-Windows-Shell-Setup", "OEMInformation"

		'RemoveNodeBy_SttngAttr_CmpnmntAttr "specialize", "Microsoft-Windows-Shell-Setup", "OEMName"
		'RemoveNodeBy_SttngAttr_CmpnmntAttr "specialize", "Microsoft-Windows-Shell-Setup", "ShowWindowsLive"

		'RemoveNodeBy_SttngAttr_CmpnmntAttr "specialize", "Microsoft-Windows-GameExplorer", "HideMicrosoftGameProvider"
		WScript.Echo "RemoveNodeBy_SttngAttr_CmpnmntAttr " & Trim(WScript.Arguments.Item(1)) & "," & Trim(WScript.Arguments.Item(2)) & "," & Trim(WScript.Arguments.Item(3))
		RemoveNodeBy_SttngAttr_CmpnmntAttr Trim(WScript.Arguments.Item(1)), Trim(WScript.Arguments.Item(2)), Trim(WScript.Arguments.Item(3))
		'RemoveNodeBy_SttngAttr_CmpnmntAttr "generalize", "Microsoft-Windows-Shell-Setup", "OEMInformation"

		objXMLDoc.save(unattend_xml_path)

Else
		WScript.Echo "Numbers of arguments incorrect."
End If
Set objXMLDoc = Nothing
Set FSO = Nothing



Sub RemoveNodeBy_SttngAttr_CmpnmntAttr(sttngAttr, CmpnmntAttr, removeNodeName)
	WScript.Echo "[SUB START]RemoveNodeBy_SttngAttr_CmpnmntAttr(" & sttngAttr & "," & CmpnmntAttr & "," & removeNodeName & ")"

	Dim theSettingNode
	set theSettingNode = Nothing
	Dim ndSettings, ndSetting
	WScript.Echo "Finding settings"
	Set ndSettings = Root.selectNodes("settings")
	WScript.Echo "ndSettings.count=" & ndSettings.length
	For each ndSetting IN ndSettings
		WScript.Echo "Checking " & ndSetting.getAttribute("pass")
		if StrComp(Trim(LCase(ndSetting.getAttribute("pass"))), Trim(LCase(sttngAttr))) = 0 Then
			WScript.Echo "Found " & sttngAttr & " Setting"
			Set theSettingNode = ndSetting
		End If
	Next
	
	If theSettingNode is Nothing Then
		WScript.Echo "ERROR: No such setting: " & sttngAttr & "!!!"
	Else 
		Dim theComponentNode
		set theComponentNode = Nothing
		Dim ndComponents, ndComponent
		WScript.Echo "Finding settings/component"
		Set ndComponents = theSettingNode.selectNodes("component")
		WScript.Echo "ndComponents.count="&ndComponents.length
		For each ndComponent IN ndComponents
				WScript.Echo "Checking " & ndComponent.getAttribute("name")
				if StrComp(Trim(LCase(ndComponent.getAttribute("name"))), Trim(LCase(CmpnmntAttr))) = 0 Then
					WScript.Echo "Found " & CmpnmntAttr
					Set theComponentNode = ndComponent
				End If
		Next
		
		If theComponentNode is Nothing Then
			WScript.Echo "ERROR: No such component: " & CmpnmntAttr & "!!!"
		Else
			WScript.Echo "Removing " & removeNodeName
			Dim ndRemoveNodeName
			Set ndRemoveNodeName = Nothing
			Set ndRemoveNodeName = theComponentNode.selectSingleNode(removeNodeName)
			If ndRemoveNodeName is Nothing Then
				WScript.Echo "ERROR: No such node: " & removeNodeName & "!!!"
			Else
				theComponentNode.RemoveChild(ndRemoveNodeName)
			End If
			If Not theComponentNode.hasChildNodes Then
				WScript.Echo "No any node in componment, remove componment"
				theSettingNode.RemoveChild(theComponentNode)
			End If
		End If
	End If
	
	WScript.Echo "[SUB END]RemoveNodeBy_SttngAttr_CmpnmntAttr()"
	WScript.Echo
End Sub