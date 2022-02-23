
Option Explicit
Dim objWMIService, objItem, colItems, strComputer

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
	"[VBS] Size in 1024: " & Int(objItem.Size /(1073741824)) & " GB" & vbCRLF & _ 
	"[VBS] Size in 1000: " & Int(objItem.Size /(1000000000)) & " GB" & vbCRLF

	if (StrComp(LCase(objItem.DeviceID), "c:")=0 and Int(objItem.Size /(1000000000)) <= 32) then 
		WriteTag
	End If
Next
WSCript.Quit

' End of Sample DiskDrive VBScript
Sub WriteTag
	Dim FSO, writer
	set FSO = WScript.CreateObject("Scripting.FileSystemObject")
	set writer = FSO.CreateTextFile(".\StorageSmallThen32G.tag")
	WScript.Echo "[VBS] SSD size less than or equal to 32G, create StorageSmallThen32G.tag"
	writer.WriteLine("SSD size less than or equal to 32G, create StorageSmallThen32G.tag")
	writer.Close
	Set FSO = Nothing
End Sub