Option Explicit


dim arg_c, linkTxtPath, linkPath, GUID
arg_c=WScript.Arguments.Length
WScript.Echo "arg_c=" & arg_c
		
If (arg_c=1) Then 
		
		dim objShell, FSO, WshShell, rdr
		Set WshShell=CreateObject("WScript.Shell")
		set objShell = CreateObject("Shell.Application")
		Set FSO = CreateObject("Scripting.FileSystemObject")

		linkTxtPath=Trim(LCase(WScript.Arguments.Item(0)))
		set rdr=FSO.OpenTextFile(linkTxtPath)
		GUID=Trim(rdr.ReadLine())
		WScript.Echo "GUID=" & GUID
		linkPath=Trim(rdr.ReadLine())
		WScript.Echo "linkPath=" & linkPath
		
		If Not FSO.FileExists(Replace(linkPath, "%ALLUSERSPROFILE%", "c:\programdata")) Then
			WScript.Echo "WARNING: " & linkPath & " not exists. It may exists while Sysprep - Factory Mode."
		End If

		linkPath=Replace(linkPath, "c:\programdata", "%ALLUSERSPROFILE%")
		linkPath=Replace(linkPath, "c:\documents and settings\all users", "%ALLUSERSPROFILE%")
		WScript.Echo "lnk to put into sysprep.xml="&linkPath
		
		Dim sysprep_old_path : sysprep_old_path="sysprep.xml"
		Dim sysprep_new_path : sysprep_new_path="sysprep_new.xml"
		WScript.Echo "sysprep_old_path="&sysprep_old_path
		WScript.Echo "sysprep_new_path="&sysprep_new_path
		If FSO.FileExists(sysprep_new_path) Then FSO.DeleteFile sysprep_new_path, True
  	
		On Error Resume Next
		WriteIntoSysprepXML linkPath, GUID, sysprep_old_path, sysprep_new_path
		FSO.CopyFile sysprep_new_path, sysprep_old_path, True
		FSO.DeleteFile sysprep_new_path, True

		set objShell = nothing
		set FSO = nothing
		set WshShell = nothing
Else
		WScript.Echo "Numbers of arguments incorrect."
End If



Sub PostError(err_num, err_msg)
	WScript.Echo err_msg
	MsgBox err_msg
	Err.Raise err_num, , err_msg
End Sub


		'<component name="Microsoft-Windows-Shell-Setup" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS" xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
		'  <ShowWindowsLive>false</ShowWindowsLive>
		'  <NotificationArea>
		'	<PromotedIcon1>
		'	  <GUID>{9B574AF2-5F5A-4874-9209-6F9639EC0D2D}</GUID>
		'	  <Path>%ProgramFiles(x86)%\mcafee.com\agent\mcagent.exe</Path>
		'	</PromotedIcon1>
		'	<PromotedIcon2>
		'	  <GUID>{F029758D-4182-4116-8790-05839FDE0E24}</GUID>
		'	  <Path>%PROGRAMFILES% (x86)\Acer\Hotkey Utility\HotkeyUtility.exe</Path>
		'	</PromotedIcon2>
		'   </NotificationArea>
		'</component>


Sub WriteIntoSysprepXML(linkPath, GUID, sysprep_old_path, sysprep_new_path)
	Dim objXMLDoc, Root
	Dim ndSettings, ndSetting, ndavSetting
	Dim ndComponts, ndCompont, ndavCompont
	Dim ndNotification, ndPromotedIcon1, ndPromotedIcon2
	Dim ndGUID1, ndGUID2, ndPATH1, ndPATH2 

	Set objXMLDoc = CreateObject("Microsoft.XMLDOM") 
	objXMLDoc.async = False 
	objXMLDoc.load(sysprep_old_path) 

	Set Root = objXMLDoc.documentElement 
	Set ndSettings = Root.selectNodes("settings")
	For Each ndSetting in ndSettings
		ndavSetting = ndSetting.Attributes(0).NodeValue
		WScript.Echo "ndavSetting=" & ndavSetting
		If StrComp(LCase(ndavSetting), "specialize", vbTextCompare)=0 Then 
			Set ndComponts = ndSetting.selectNodes("component")
			For Each ndCompont in ndComponts
				ndavCompont = ndCompont.Attributes(0).NodeValue
				WScript.Echo "ndavCompont=" & ndavCompont
				If StrComp(LCase(ndavCompont), "microsoft-windows-shell-setup", vbTextCompare)=0 Then
					Set ndNotification = ndCompont.SelectSingleNode("NotificationArea")

					Set ndPromotedIcon1 = ndNotification.SelectSingleNode("PromotedIcon1")
					Set ndPromotedIcon2 = ndNotification.SelectSingleNode("PromotedIcon2")

					set ndGUID1 = ndPromotedIcon1.SelectSingleNode("GUID")
					set ndGUID2 = ndPromotedIcon2.SelectSingleNode("GUID")
					set ndPATH1 = ndPromotedIcon1.SelectSingleNode("Path")
					set ndPATH2 = ndPromotedIcon2.SelectSingleNode("Path")
					
					WScript.Echo "PromotedIcon1=" & ndGUID1.text & " - " & ndPATH1.text
					WScript.Echo "PromotedIcon1=" & ndGUID2.text & " - " & ndPATH2.text

					If StrComp(ndGUID1.text, "AcerNotificationAreaIconGUID") = 0 Then
						WScript.Echo "Modify Link0 to "&linkPath
						ndGUID1.text=GUID
						ndPATH1.text=linkPath
						Exit For
					ElseIf StrComp(ndGUID2.text, "AcerNotificationAreaIconGUID") = 0 Then
						WScript.Echo "Modify Link1 to "&linkPath
						ndGUID2.text=GUID
						ndPATH2.text=linkPath
						Exit For
					Else
						WScript.Echo "[ERROR] No available AcerNotificationAreaIconGUID container for "&linkPath
						Exit For
					End If
					
				End If
			Next
		End If
	Next
	objXMLDoc.save(sysprep_new_path)
End Sub
