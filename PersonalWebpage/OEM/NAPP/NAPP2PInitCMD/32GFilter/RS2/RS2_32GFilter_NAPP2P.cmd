
@Echo off
echo.
ECHO %DATE% %TIME%[Log START]  ============ [SUB]%~dpnx0 ============
pushd "%~dp0"

SET SCDPatchTools=C:\TempHidden\SCD\Patch\Tools
IF EXIST M:\D2D_WIN10\SCD\Patch\*.* (	
	SET SCDPatchTools=M:\D2D_WIN10\SCD\Patch\Tools
)
ECHO !DATE! !TIME![Log TRACE]  SET SCDPatchTools=%SCDPatchTools%

if exist 32GAppFilterRS2_Found.tag del /f /q 32GAppFilterRS2_Found.tag
ECHO %DATE% %TIME%[Log TRACE]  Cscript /nologo __GetFilterPolicy.vbs %SCDPatchTools%\APBundlePolicy.xml
Cscript /nologo __GetFilterPolicy.vbs %SCDPatchTools%\APBundlePolicy.xml
if not exist .\32GAppFilterRS2_Found.tag (
	ECHO !DATE! !TIME![Log TRACE]  image no support 32G App filter_RS2, goto :END
	goto :END
)

:SetModulesPath
SET SCDPatchModules=C:\TempHidden\SCD\Patch\Modules\Acer-HQ1
IF EXIST M:\D2D_WIN10\SCD\Patch\*.* (
	SET SCDPatchModules=M:\D2D_WIN10\SCD\Patch\Modules\Acer-HQ1
)
ECHO !DATE! !TIME![Log TRACE]  SET SCDPatchModules=%SCDPatchModules%

:CountPXP
SET LPCDPath=%~d0\TempHidden\LPCD
IF EXIST M:\D2D_WIN10\LPCD\*.* (
	SET LPCDPath=M:\D2D_WIN10\LPCD
)
ECHO !DATE! !TIME![Log TRACE]  SET LPCDPath=%LPCDPath%
ECHO %DATE% %TIME%[Log TRACE]  Counting LPCD .....
ECHO %DATE% %TIME%[Log TRACE]  dir /ad /b %LPCDPath%
dir /ad /b %LPCDPath%
for /f "tokens=1" %%i in ('dir /ad /b %LPCDPath% ^| find /c /v ""') do set Count_PXP=%%i
ECHO %DATE% %TIME%[Log TRACE]  Got LPCD amount is [%Count_PXP%]


if exist StorageSmallThen32G.tag del /f /q StorageSmallThen32G.tag
ECHO %DATE% %TIME%[Log TRACE]  cscript /nologo _CreateSmallStorageTag.vbs
cscript /nologo _CreateSmallStorageTag.vbs
for /f %%I in ('powershell.exe -noprofile -executionpolicy unrestricted -file __GetPhysicalMemory.ps1') do @set AcerRamSize=%%I
ECHO %DATE% %TIME%[Log TRACE]  machine ram size = %AcerRamSize% MB

if exist .\StorageSmallThen32G.tag (
	IF %Count_PXP% EQU 1 (
		ECHO !DATE! !TIME![Log TRACE]  SLP case.
		IF "%AcerRamSize%" EQU "8192" (
			ECHO !DATE! !TIME![Log TRACE]  SET BlackPath=BlackListFor8GRAM_Path.txt
			SET BlackPath=BlackListFor8GRAM_Path.txt
		) ELSE (
			ECHO !DATE! !TIME![Log TRACE]  SET BlackPath=BlackListFor4GRAM_Path.txt
			SET BlackPath=BlackListFor4GRAM_Path.txt
		)
		ECHO !DATE! !TIME![Log TRACE]  call :RemoveByBlack
		call :RemoveByBlack
	) ELSE (
		ECHO !DATE! !TIME![Log TRACE]  MLP case, remove unnecessary APP source...
		ECHO !DATE! !TIME![Log TRACE]  call :RemoveSource
		call :RemoveSource
	)
) else (
	ECHO !DATE! !TIME![Log TRACE]  Not Small storage case. leave.
)

:END
popd
ECHO %DATE% %TIME%[Log LEAVE]  ============ [SUB]%~dpnx0 ============
echo.
exit /b 0


:RemoveSource
ECHO %DATE% %TIME%[Log TRACE]  DIR /AD /B %SCDPatchModules%\APP
DIR /AD /B %SCDPatchModules%\APP
for /f "delims=" %%L in ('DIR /AD /B %SCDPatchModules%\APP') do (
	ECHO !DATE! !TIME![Log TRACE]  call :CheckingAPP [%%L]
	call :CheckingAPP %%L
	ECHO  ------------------------------------------------------------------------------------------
	ECHO.
)
ECHO.
ECHO %DATE% %TIME%[Log TRACE]  DIR /AD /B %SCDPatchModules%\A00
DIR /AD /B %SCDPatchModules%\A00
for /f "delims=" %%L in ('DIR /AD /B %SCDPatchModules%\A00') do (
	ECHO !DATE! !TIME![Log TRACE]  call :CheckingAPP [%%L]
	call :CheckingAPP %%L
	ECHO  ------------------------------------------------------------------------------------------
	ECHO.
)
exit /b 0


:CheckingAPP
ECHO !DATE! !TIME![Log TRACE]  Now checking [%*]
ECHO !DATE! !TIME![Log TRACE]  find /i "%*" WhiteList_Path.txt
find /i "%*" WhiteList_Path.txt
if !errorlevel! neq 0 (
	if exist "%SCDPatchModules%\A00\%*" (
		ECHO !DATE! !TIME![Log TRACE]  Not exist in the WhiteList, rd /s /q "%SCDPatchModules%\A00\%*"
		rd /s /q "%SCDPatchModules%\A00\%*"
	)
	if exist "%SCDPatchModules%\APP\%*" (
		ECHO !DATE! !TIME![Log TRACE]  Not exist in the WhiteList, rd /s /q "%SCDPatchModules%\APP\%*"
		rd /s /q "%SCDPatchModules%\APP\%*"
	)
) else (
	ECHO !DATE! !TIME![Log TRACE]  "%*" exist in the WhiteList. keep it.
)
exit /b 0



:RemoveByBlack
ECHO !DATE! !TIME![Log TRACE]  Got BlackPath=[%BlackPath%]
IF "%BlackPath%" equ "" exit /b 0
for /f "delims=" %%F in (%BlackPath%) do (
	ECHO !DATE! !TIME![Log TRACE]  checking [%%F] .....
	if exist "%SCDPatchModules%\A00\%%F" (
		ECHO !DATE! !TIME![Log TRACE]  [%%F] found. rd /s /q "%SCDPatchModules%\A00\%%F"
		rd /s /q "%SCDPatchModules%\A00\%%F"
	) else if exist "%SCDPatchModules%\APP\%%F" (
		ECHO !DATE! !TIME![Log TRACE]  [%%F] found. rd /s /q "%SCDPatchModules%\APP\%%F"
		rd /s /q "%SCDPatchModules%\APP\%%F"
	) else (
		ECHO !DATE! !TIME![Log TRACE]  [%SCDPatchModules%\A00\%%F or %SCDPatchModules%\APP\%%F] not found.
	)
	ECHO.
)
exit /b 0
