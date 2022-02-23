
@ECHO OFF
IF EXIST N:\Windows\System32\oobe\msoobe.exe SET @DST=N:
IF EXIST C:\Windows\System32\oobe\msoobe.exe SET @DST=C:
SET LogPath=%@DST%\OEM\AcerLogs\NAPP3P.log
Echo.>>%LogPath%
ECHO %DATE% %TIME%[Log START]  ============ [NAPP]%~dpnx0 ============ >> %LogPath%
SETLOCAL ENABLEDELAYEDEXPANSION

if exist C:\OEM\Factory\Factory_3P.cmd (
	ECHO !DATE! !TIME![Log TRACE]  [Start] call C:\OEM\Factory\Factory_3P.cmd >>%LogPath%
	call C:\OEM\Factory\Factory_3P.cmd
	ECHO !DATE! !TIME![Log TRACE]  [Leave] call C:\OEM\Factory\Factory_3P.cmd >>%LogPath%
)

SETLOCAL DISABLEDELAYEDEXPANSION
ECHO %DATE% %TIME%[Log LEAVE]  ============ [NAPP]%~dpnx0 ============ >> %LogPath%
Echo.>>%LogPath%