
@ECHO OFF
MD C:\OEM\AcerLogs
SET LogPath=C:\OEM\AcerLogs\NAPP2P.log
Echo.>>%LogPath%
ECHO %DATE% %TIME%[Log START]  ============ %~dpnx0 ============ >> %LogPath%
pushd "%~dp0"
SETLOCAL ENABLEDELAYEDEXPANSION

if /i "%processor_architecture%" equ "amd64" (
	ECHO %DATE% %TIME%[Log TRACE]  wpeutil CreatePageFile /path=C:\PageFile.sys /Size=1024 >> %LogPath%
	wpeutil CreatePageFile /path=C:\PageFile.sys /Size=1024 >> %LogPath% 2>&1
) else (
	ECHO %DATE% %TIME%[Log TRACE]  wpeutil CreatePageFile /path=C:\PageFile.sys /Size=512 >> %LogPath%
	wpeutil CreatePageFile /path=C:\PageFile.sys /Size=512 >> %LogPath% 2>&1
)

ECHO %DATE% %TIME%[Log TRACE]  DIR /S /B .\NAPP2PInitCMD\*.cmd >> %LogPath%
(FOR /F "DELIMS=" %%C in ('DIR /S /B .\NAPP2PInitCMD\*.cmd') DO (
	ECHO !DATE! !TIME![Log TRACE]  call %%C
	call %%C
))>>%LogPath% 2>&1

SETLOCAL DISABLEDELAYEDEXPANSION
popd
ECHO %DATE% %TIME%[Log LEAVE]  ============ %~dpnx0 ============ >> %LogPath%
Echo.>>%LogPath%