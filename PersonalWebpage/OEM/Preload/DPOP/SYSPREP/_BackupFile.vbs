'_BackupSysprepXML.vbs C:\Windows\System32\OEM\factory\SysprepXml\%Br%\Sysprep.xml

Option Explicit
Dim FSO
Dim arg_c
arg_c=WScript.Arguments.Length
WScript.Echo "arg_c=" & arg_c
If arg_c = 1 Then
	Set FSO = CreateObject("Scripting.FileSystemObject")

	Dim Backup_File_Path : Backup_File_Path=Trim(WScript.Arguments.Item(0))
	WScript.Echo "Backup_File_Path="&Backup_File_Path
	BackupFile()
	
Else
		WScript.Echo "Numbers of arguments incorrect."
End If
Set FSO = Nothing


Sub BackupFile()
	WScript.Echo
	WScript.Echo "[SUB START] BackupFile()"
	'[Randomize function]
	'Initializes the random-number generator.
	'Randomize uses number to initialize the Rnd function's random-number generator, giving it a new seed value. 
	'If you omit number, the value returned by the system timer is used as the new seed value.
	Randomize
	dim tmpFile : tmpFile = Year(Now()) & "Y" & Month(Now()) & "M" & Day(Now()) & "D" & Hour(Now()) & "H" & Minute(Now()) & "M" & Second(Now()) & "S" & (Int((1000*Rnd)+1)) & "R"
	WScript.Echo "Backup " & Backup_File_Path & " as " & Backup_File_Path & "." & tmpFile
	FSO.CopyFile Backup_File_Path, Backup_File_Path & "." & tmpFile
	WScript.Echo "[SUB END] BackupFile()"
	WScript.Echo
End Sub