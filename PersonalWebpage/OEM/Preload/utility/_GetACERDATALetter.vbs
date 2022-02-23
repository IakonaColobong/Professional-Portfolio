
Option Explicit
Dim objWMIService, objItem, colItems, strComputer
Dim exitcode : exitcode = 4

' On Error Resume Next
strComputer = "."

Set objWMIService = GetObject("winmgmts:\\" & strComputer & "\root\cimv2")
Set colItems = objWMIService.ExecQuery("Select * FROM Win32_Volume")


For Each objItem in colItems    
	IF Instr(UCase(objItem.Label),"ACERDATA") then
		WScript.Echo objItem.DriveLetter
	End IF	
Next
