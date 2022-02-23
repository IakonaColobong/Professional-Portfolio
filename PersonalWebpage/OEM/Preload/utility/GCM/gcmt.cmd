
@Echo off
SET LogPath=C:\OEM\AcerLogs\Useralaunch.log
SET ChkPIDLogPath=C:\OEM\AcerLogs\GCMAPP_Check.log
ECHO.>>%LogPath%
ECHO %DATE% %TIME%[Log START]  ============ %~dpnx0 ============ >> %LogPath%
pushd %~dp0

ECHO %DATE% %TIME%[Log TRACE]  Enable Delayed environment variable >> %LogPath%
SETLOCAL ENABLEDELAYEDEXPANSION

ECHO [%DATE% %TIME%]  find /i "GCM=Y" C:\OEM\Preload\Command\POP*.ini>>%LogPath% 2>&1
find /i "GCM=Y" C:\OEM\Preload\Command\POP*.ini>>%LogPath% 2>&1
if %ERRORLEVEL% NEQ 0 (
	ECHO [!DATE! !TIME!]  Not GCM image, leave >>%LogPath%
	goto :END
)
ECHO %DATE% %TIME%[Log TRACE]  DEL /f /q C:\OEM\GCM\*.xml >>%LogPath%
DEL /f /q C:\OEM\GCM\*.xml >>%LogPath%
ECHO %DATE% %TIME%[Log TRACE]  DIR /b C:\OEM\Preload\InstalledAPPs\*.tag >>%LogPath%
DIR /b C:\OEM\Preload\InstalledAPPs\*.tag >>%LogPath%
For /f "tokens=1 delims=." %%T in ('DIR /b C:\OEM\Preload\InstalledAPPs\*.tag') do (
	ECHO !DATE! !TIME![Log TRACE]  call :CheckPID %%T>>%LogPath%
	call :CheckPID %%T
	ECHO !DATE! !TIME![Log TRACE]  gcmt.exe /i %%T >> %LogPath% 2>&1
	gcmt.exe /i %%T >> %LogPath% 2>&1
)


:GCMT
ECHO %DATE% %TIME%[Log TRACE]  gcmt.exe /m >> %LogPath%
gcmt.exe /m >> %LogPath% 2>&1
ECHO.>>%LogPath%
ECHO %DATE% %TIME%[Log TRACE]  gcmt.exe /s >> %LogPath%
gcmt.exe /s >> %LogPath% 2>&1
ECHO.>>%LogPath%
ECHO %DATE% %TIME%[Log TRACE]  gcmt.exe /v >> %LogPath%
gcmt.exe /v >GCMT_V.log 2>&1
ECHO %DATE% %TIME%[Log TRACE]  Type GCMT_V.log >>%LogPath%
Type GCMT_V.log >>%LogPath%
REM ECHO %DATE% %TIME%[Log TRACE]  FIND /I "Check FAIL" .\GCMT_V.log>> %LogPath% 2>&1
REM FIND /I "Check FAIL" .\GCMT_V.log>> %LogPath% 2>&1
REM IF "%ERRORLEVEL%" EQU "0" ECHO Found error when gcmt.eve /v >>%LogPath% && Notepad .\GCMT_V.log

:END
ECHO %DATE% %TIME%[Log TRACE]  Disable Delayed environment variable >> %LogPath%
SETLOCAL DISABLEDELAYEDEXPANSION
popd
ECHO %DATE% %TIME%[Log LEAVE]  ============ %~dpnx0 ============ >> %LogPath%
ECHO.>>%LogPath%
ECHO.>>%LogPath%
exit /b 0



:CheckPID
ECHO ------------------------------------------------------------ >>%ChkPIDLogPath%
SET CheckingPID=%~1
ECHO %DATE% %TIME%[Log TRACE]  Checking [%CheckingPID%]>>%LogPath%
ECHO %DATE% %TIME%[Log TRACE]  DIR /b C:\OEM\Preload\Command\Patch_*.xml>>%ChkPIDLogPath%
DIR /b C:\OEM\Preload\Command\Patch_*.xml>>%ChkPIDLogPath% 2>&1
FOR /F "TOKENS=1 DELIMS=" %%F in ('DIR /b C:\OEM\Preload\Command\Patch_*.xml') DO (
	ECHO !DATE! !TIME![Log TRACE]  Cscript /nologo .\__ChkPIDFromGCMXML.vbs "C:\OEM\Preload\Command\%%F" %CheckingPID% >>%ChkPIDLogPath%
	Cscript /nologo .\__ChkPIDFromGCMXML.vbs "C:\OEM\Preload\Command\%%F" %CheckingPID% >>%ChkPIDLogPath% 2>&1
	IF !ERRORLEVEL! NEQ 4 (
		ECHO !DATE! !TIME![Log TRACE]  Found [%CheckingPID%] GCM Rule in %%F >>%LogPath%
		exit /b 0
	)
)
ECHO %DATE% %TIME%[Log TRACE]  Cscript /nologo .\__ChkPIDFromGCMXML.vbs C:\OEM\Preload\Command\APBundlePolicy.xml %CheckingPID% >>%ChkPIDLogPath%
Cscript /nologo .\__ChkPIDFromGCMXML.vbs C:\OEM\Preload\Command\APBundlePolicy.xml %CheckingPID% >>%ChkPIDLogPath% 2>&1
IF "%CheckingPID%" EQU "tag" (
	ECHO !DATE! !TIME![Log TRACE]  AlaunchX no support PatchCD patch GCM, may created [.tag] file, skip warning first>>%LogPath%
	exit /b 0
)
IF %ERRORLEVEL% EQU 4 (
	ECHO !DATE! !TIME![Log TRACE]  Can not found [%CheckingPID%] bundle rule in APBundlePolicy.xml>>%LogPath%
	Notepad %ChkPIDLogPath%
)
exit /b 0