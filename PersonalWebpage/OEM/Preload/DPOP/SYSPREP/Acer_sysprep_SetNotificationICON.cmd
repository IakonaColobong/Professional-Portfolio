@Echo off
ECHO.>>%LogPath%
ECHO %DATE% %TIME%[Log START]  ============ [SUB]%~dpnx0 ============ >> %LogPath%
pushd "%~dp0" >> %LogPath% 2>&1
setlocal

SET CPUArchitecture=x86
find /i "CPU=X64" C:\OEM\Preload\Command\POP*.ini>>%LogPath% 2>&1 && SET CPUArchitecture=amd64
ECHO %DATE% %TIME%[Log TRACE]  find /i "GCM=Y" C:\OEM\Preload\Command\POP*.ini>>%LogPath% 2>&1
find /i "GCM=Y" C:\OEM\Preload\Command\POP*.ini>>%LogPath% 2>&1
if %ERRORLEVEL% NEQ 0 (
	ECHO !DATE! !TIME![Log TRACE]  Not GCM image, leave. >>%LogPath%
	goto :END
)
SET Sysprepxml=%~1
ECHO %DATE% %TIME%[Log TRACE]  C:\OEM\preload\utility\GCM\MRDCreaterX_%CPUArchitecture%.exe /NA /IMWhiteListPath:c:\OEM\preload\DPOP\GCMReadiness\IM_WhiteList.txt >>%LogPath%
C:\OEM\preload\utility\GCM\MRDCreaterX_%CPUArchitecture%.exe /NA /IMWhiteListPath:c:\OEM\preload\DPOP\GCMReadiness\IM_WhiteList.txt >>%LogPath% 2>&1
ECHO.>>%LogPath%
IF /I EXIST C:\OEM\preload\utility\GCM\NAMRD.xml (
	ECHO !DATE! !TIME![Log TRACE]  call _MergeNewGCMMRDandSysprepXML.vbs to update Notification Area. >>%LogPath%
	ECHO !DATE! !TIME![Log TRACE]  Cscript.exe /nologo _MergeNewGCMMRDandSysprepXML.vbs specialize Microsoft-Windows-Shell-Setup NotificationArea C:\OEM\preload\utility\GCM\NAMRD.xml "%Sysprepxml%" >> %LogPath% 2>&1
	ECHO.>>%LogPath%
	ECHO !DATE! !TIME![Log TRACE]  ^|----------------------------- Start -----------------------------------^| >>%LogPath%
	Cscript.exe /nologo _MergeNewGCMMRDandSysprepXML.vbs specialize Microsoft-Windows-Shell-Setup NotificationArea C:\OEM\preload\utility\GCM\NAMRD.xml "%Sysprepxml%" >> %LogPath% 2>&1
	ECHO !DATE! !TIME![Log TRACE]  ^|----------------------------- Leave -----------------------------------^| >>%LogPath%
	ECHO.>>%LogPath%
)
ECHO %DATE% %TIME%[Log TRACE]  powershell -ExecutionPolicy ByPass -command "%~dp0_RemoveXMLUnwantNS.ps1 \"%Sysprepxml%\"" >> %LogPath% 2>&1
powershell -ExecutionPolicy ByPass -command "%~dp0_RemoveXMLUnwantNS.ps1 \"%Sysprepxml%\"" >> %LogPath% 2>&1

:END
endlocal
popd >> %LogPath% 2>&1
ECHO %DATE% %TIME%[Log START]  ============ [SUB]%~dpnx0 ============ >> %LogPath%
ECHO.>>%LogPath%