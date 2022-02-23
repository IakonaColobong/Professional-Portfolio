Option Explicit

Private WshShell
Dim arg_c, strRegPath
Dim brand_DMI, objWMIService, colItems, objItem
Dim strComputer : strComputer= "." 
Set WshShell=CreateObject("WScript.Shell")
Set objWMIService = GetObject("winmgmts:\\" & strComputer & "\root\CIMV2") 
Set colItems = objWMIService.ExecQuery("SELECT * FROM Win32_ComputerSystem",,48)
arg_c=WScript.Arguments.Length
IF (arg_c=1) Then
	strRegPath = Trim(WScript.Arguments.Item(0))
	Wscript.Echo strRegPath
	'Rhea Wei: VBSCRIPT used "" to escape "
	For Each objItem in colItems
		Wscript.Echo "WshShell.RegWrite " & strRegPath & "\OEM\Metadata\GCM\Model, " & objItem.Model & ", REG_SZ"
		WshShell.RegWrite strRegPath & "\OEM\Metadata\GCM\Model", objItem.Model, "REG_SZ"
		Wscript.Echo "WshShell.RegWrite " & strRegPath & "\Wow6432Node\OEM\Metadata\GCM\Model, " & objItem.Model & ", REG_SZ"
		WshShell.RegWrite strRegPath & "\Wow6432Node\OEM\Metadata\GCM\Model", objItem.Model, "REG_SZ"
	Next
ELSE
	WScript.Echo arg_c
	WScript.Echo "Numbers of arguments incorrect."
End IF