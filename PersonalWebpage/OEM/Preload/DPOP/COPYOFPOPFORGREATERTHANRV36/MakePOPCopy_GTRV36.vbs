Option Explicit
Private FSO, popini
Set FSO = CreateObject("Scripting.FileSystemObject")
Private GAIA_lang : GAIA_lang="XX"
Private PopFolder : PopFolder=WScript.Arguments.Item(0)
If IsOneMoreDigit(FSO, PopFolder, popini) Then
	CreateFakePOPINI FSO, popini, PopFolder
End If
Set FSO = Nothing
'===========================================================================================================
Sub CreateFakePOPINI(FSO, popini, PopFolder)
	'Create Fake POPZZ.INI
	WScript.Echo "[VBS] Create fake POP with GAIA language code in file name"
	'Sample: POP01 04UP5 TC 4C31
	Dim POPINI_AFolder : POPINI_AFolder=Left(popini, (16-2))&"ZZ.INI"
	WScript.Echo "[VBS] Creating folder: "&PopFolder&"\"&POPINI_AFolder
	FSO.CreateFolder PopFolder&"\"&POPINI_AFolder
End Sub
'===========================================================================================================
Function IsOneMoreDigit (FSO, PopFolder, popini)
	IsOneMoreDigit=False
	WScript.Echo "[VBS] PopFolder="&PopFolder
	Dim f, f_len
	For Each f In FSO.GetFolder(PopFolder).Files
		WScript.Echo "[VBS] Checking: "&f.Path&"    f.Name="&f.Name&"    File Extension Name: "&FSO.GetExtensionName(f)
		If InStr(f.Name, "POP")=1 AND StrComp(UCase(FSO.GetExtensionName(f)), "INI")=0 Then
			popini=FSO.GetBaseName(f)
			WScript.Echo "[VBS] Find POP: "&f.Name
			f_len=Len(FSO.GetBaseName(f))
			WScript.Echo "[VBS] Length of File Base Name: "&f_len
			If f_len=(16+1) Then
				WScript.Echo "[VBS] One More Digit of POP, need to create a fake FOLDER POP.INI"
				IsOneMoreDigit=True
			End If
		End If
	Next
End Function