
Option Explicit
Dim objWMIService, objItem, colItems, strComputer
Dim result

' On Error Resume Next
strComputer = "."

Set objWMIService = GetObject("winmgmts:\\" & strComputer & "\root\cimv2")
Set colItems = objWMIService.ExecQuery("Select * from Win32_LogicalDisk")

For Each objItem in colItems

	Wscript.Echo vbCRLF & _ 
	"[VBS] DeviceID: " & objItem.DeviceID & vbCRLF & _ 
	"[VBS] DriveType: " & objItem.DriveType & vbCRLF & _ 
	"[VBS] VolumeName: " & objItem.VolumeName & vbCRLF & _
	"[VBS] Size: " & objItem.Size & vbCRLF & _ 
	"[VBS] FreeSpace: " & objItem.FreeSpace & vbCRLF & _	
	"[VBS] FreeSpace in 1024: " & (objItem.FreeSpace /(1073741824)) & " GB" & vbCRLF & _ 
	"[VBS] FreeSpace in 1000: " & (objItem.FreeSpace /(1000000000)) & " GB" & vbCRLF	

	if (StrComp(LCase(objItem.DeviceID), "c:")=0 and (objItem.FreeSpace /(1073741824)) <16) then 
		WriteTag
	End If
Next
WSCript.Quit

' End of Sample DiskDrive VBScript
Sub WriteTag
	Dim FSO, writer
	set FSO = WScript.CreateObject("Scripting.FileSystemObject")
	set writer = FSO.CreateTextFile("c:\oem\preload\OSDriveFreeSpaceLSS16.tag")
	WScript.Echo "[VBS] OS Drive Free Space LSS 16G"
	writer.WriteLine("OS Drive Free Space LSS 16G")
	writer.Close
	Set FSO = Nothing
	result=Msgbox("OS Drive Free Space LSS 16G.  Please check with Acer first.",16, "OS Drive Free Space Checking")
	result=Msgbox("OS Drive Free Space LSS 16G.  Please check with Acer first.",16, "OS Drive Free Space Checking")
	result=Msgbox("OS Drive Free Space LSS 16G.  Please check with Acer first.",16, "OS Drive Free Space Checking")
End Sub