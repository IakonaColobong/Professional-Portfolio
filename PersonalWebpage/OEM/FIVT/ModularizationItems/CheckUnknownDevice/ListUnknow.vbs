' Get object
Set objFSO = CreateObject("Scripting.FileSystemObject")
Set objShell = CreateObject("Wscript.Shell")
Set objNet = CreateObject("WScript.Network")

' Define Objects
strComputer = objNet.ComputerName
StrDomain = objnet.UserDomain
StrUser = objNet.UserName

' ------ Set Constants ---------
Const ForWriting = 2
Const HKEY_LOCAL_MACHINE = &H80000002
Const SEARCH_KEY = "DigitalProductID"


Message = "Computer Details:" & vbCrLf & vbCrLf
On Error Resume Next
Set objWMIService = GetObject("winmgmts:\\" & strComputer & "\root\CIMV2")
Set colItems = objWMIService.ExecQuery("SELECT * FROM Win32_ComputerSystem")
For Each objItem In colItems
	Message = Message & "Manufacturer: " & objItem.Manufacturer & vbCrLf
	Message = Message & "Model: " & objItem.Model & vbCrLf & vbCrLf
Next

	Message = Message & "Hardware that's not working list" & vbCrLf & vbCrLf
Set colItems = objWMIService.ExecQuery("Select * FROM Win32_ComputerSystemProduct",,48) 
For Each objItem In colItems 
 Message = Message & "Service Tag: " & objItem.IdentifyingNumber & vbCrLf & vbCrLf
Next

Set colItems = objWMIService.ExecQuery("Select * from Win32_PnPEntity " & "WHERE ConfigManagerErrorCode <> 0")
Count=0
For Each objItem in colItems
	dev_descritipon = LCase(Trim(objItem.Description))
	If InStr(dev_descritipon, "keyboard") >0 AND InStr(dev_descritipon, "ps/2") >0 Then 
		WScript.Echo "Ignored: PS/2 Keyboard : "&objItem.Description
	ElseIf InStr(dev_descritipon, "mouse") >0 AND InStr(dev_descritipon, "ps/2") >0 Then
		WScript.Echo "Ignored: PS/2 Mouse : "&objItem.Description
	ElseIf InStr(dev_descritipon, "ps/2") >0 Then
		WScript.Echo "Ignored: PS/2 device : "&objItem.Description
	Else
		WScript.Echo "Unknown: " & objItem.Description
		Message = Message & "[" & Count & "] Unknown Device" & vbCrLf
		Message = Message & "Description: " & objItem.Description & vbCrLf
		Message = Message & "Device ID: " & objItem.DeviceID & vbCrLf

        Message = Message & "Availability: " & objItem.Availability & vbCrLf
        Message = Message & "ConfigManagerErrorCode: " & objItem.ConfigManagerErrorCode & vbCrLf
        Message = Message & "ErrorDescription: " & objItem.ErrorDescription & vbCrLf
        Message = Message & "Status: " & objItem.Status & vbCrLf
        Message = Message & "Name: " & objItem.Name & vbCrLf
        Message = Message & "Manufacturer: " & objItem.Manufacturer & vbCrLf
        Message = Message & "Service: " & objItem.Service & vbCrLf
        Message = Message & "ClassGuid: " & objItem.ClassGuid & vbCrLf
        Message = Message & "-" & vbCrLf

        Count=Count+1
	End If
Next

If Count > 0 then
	Set objLogFile = objFSO.CreateTextFile(".\" & "Unknown.txt", ForWriting, True)
	objLogFile.Write Message
	objLogFile.WriteLine
	objLogFile.Close
end if

