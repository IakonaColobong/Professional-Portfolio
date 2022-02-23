
@Echo off
echo.
ECHO %DATE% %TIME%[Log START]  ============ [SUB]%~dpnx0 ============
pushd "%~dp0"

SET SCDPatchTools=C:\TempHidden\SCD\Patch\Tools
IF EXIST M:\D2D_WIN10\SCD\Patch\*.* (
	SET SCDPatchTools=M:\D2D_WIN10\SCD\Patch\Tools
)
ECHO !DATE! !TIME![Log TRACE]  SET SCDPatchTools=%SCDPatchTools%

if exist 32GAppFilterRS5_Found.tag del /f /q 32GAppFilterRS5_Found.tag
ECHO %DATE% %TIME%[Log TRACE]  Cscript /nologo __GetFilterPolicy.vbs %SCDPatchTools%\APBundlePolicy.xml
Cscript /nologo __GetFilterPolicy.vbs %SCDPatchTools%\APBundlePolicy.xml
if not exist .\32GAppFilterRS5_Found.tag (
	ECHO !DATE! !TIME![Log TRACE]  image no support 32G App filter_RS5, goto :END
	goto :END
)


::::
::::	WIN10 RS3 Pro need more disk space for 32G eMMC sku
::::
SET IsProSku=FALSE
if exist C:\TempHidden\RCD\POP01???65* SET IsProSku=TRUE
if exist C:\TempHidden\RCD\POP01???66* SET IsProSku=TRUE
ECHO !DATE! !TIME![Log TRACE]  IsProSku=[%IsProSku%]
::::
::::


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
	ECHO !DATE! !TIME![Log TRACE]  call :RemoveRestrictedModule
	call :RemoveRestrictedModule
	IF /I "%IsProSku%" EQU "TRUE" (
		ECHO !DATE! !TIME![Log TRACE]  This is Pro image with 32G eMMC skue, call :RemoveSource
		call :RemoveSource
		ECHO !DATE! !TIME![Log TRACE]  goto :END
		goto :END
	) ELSE (
		ECHO !DATE! !TIME![Log TRACE]  This is not Pro image, continue.
	)
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



:RemoveRestrictedModule
::::
::::	2018/3/16
::::	Add Remove Restricted module wim file solution for 32G eMMC
::::
SET ChkWhiteList=FALSE
ECHO !DATE! !TIME![Log TRACE]  Getting the POP.ini file Name.....
ECHO !DATE! !TIME![Log TRACE]  DIR /b C:\TempHidden\RCD\POP*.INI
DIR /b C:\TempHidden\RCD\POP*.INI
FOR /F "tokens=1 delims=." %%F in ('DIR /b C:\TempHidden\RCD\POP*.INI') do (
	SET POPFileName=%%~nF
	goto GetBaseRCD
)
:GetBaseRCD
ECHO !DATE! !TIME![Log TRACE]  Got POP File Name is [%POPFileName%]
SET RCDBase=%POPFileName:~10,2%
ECHO !DATE! !TIME![Log TRACE]  RCD Base GAIA code is [%RCDBase%]
ECHO %DATE% %TIME%[Log TRACE]  DIR /s /b %SCDPatchTools%\PreloadPN\PAP\PAP???????%RCDBase%*.ini
DIR /s /b %SCDPatchTools%\PreloadPN\PAP\PAP???????%RCDBase%*.ini
FOR /f "delims=" %%P in ('DIR /s /b %SCDPatchTools%\PreloadPN\PAP\PAP???????%RCDBase%*.ini') do (
	ECHO !DATE! !TIME![Log TRACE]  Cscript /nologo __GetRestrictedList.vbs "%%~fP"
	Cscript /nologo __GetRestrictedList.vbs "%%~fP"
)
ECHO.
ECHO %DATE% %TIME%[Log TRACE]  type RestrictedModule.txt
ECHO --------------------
type RestrictedModule.txt
ECHO --------------------
for /f "delims=" %%L in (RestrictedModule.txt) do (
	ECHO !DATE! !TIME![Log TRACE]  call :CheckingAPP [%%L]
	call :CheckingAPP %%L
	ECHO  ------------------------------------------------------------------------------------------
	ECHO.
)
exit /b 0



:RemoveSource
SET ChkWhiteList=TRUE
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
if /i "%ChkWhiteList%" neq "TRUE" goto :CheckingAPP_RD
ECHO !DATE! !TIME![Log TRACE]  find /i "%*" WhiteList_Path.txt
find /i "%*" WhiteList_Path.txt
if !errorlevel! neq 0 (
	ECHO !DATE! !TIME![Log TRACE]  "%*" Not exist in the WhiteList, goto :CheckingAPP_RD
	goto :CheckingAPP_RD
) else (
	ECHO !DATE! !TIME![Log TRACE]  "%*" exist in the WhiteList. keep it. exit /b 0
	exit /b 0
)

:CheckingAPP_RD
if exist "%SCDPatchModules%\A00\%*" (
	ECHO !DATE! !TIME![Log TRACE]  rd /s /q "%SCDPatchModules%\A00\%*"
	rd /s /q "%SCDPatchModules%\A00\%*"
)
if exist "%SCDPatchModules%\APP\%*" (
	ECHO !DATE! !TIME![Log TRACE]  rd /s /q "%SCDPatchModules%\APP\%*"
	rd /s /q "%SCDPatchModules%\APP\%*"
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
