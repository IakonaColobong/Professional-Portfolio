Option Explicit

Private WshShell
Private FSO
Set WshShell=CreateObject("WScript.Shell")
Set FSO = CreateObject("Scripting.FileSystemObject")

Dim brand_DMI, objWMIService, colItems, objItem
Dim strComputer : strComputer= "." 
Set objWMIService = GetObject("winmgmts:\\" & strComputer & "\root\CIMV2") 

REM WScript.Echo "[Win32_LogicalDisk]"
Set colItems = objWMIService.ExecQuery("SELECT * FROM Win32_LogicalDisk",,48) 
For Each objItem in colItems 
    If StrComp(objItem.MediaType, "12")=0 Then WScript.Echo objItem.DeviceID
	rem Wscript.Echo objItem.DeviceID & " -- " & objItem.MediaType & " -- " & objItem.FileSystem 
Next


REM 11 : removable media other than floppy : ODD
REM 12 : fixed hard disk media
REM empty : USB key


Set FSO = Nothing
Set WshShell=Nothing


