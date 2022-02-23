
@ECHO OFF
IF EXIST N:\Windows\System32\oobe\msoobe.exe SET @DST=N:
IF EXIST C:\Windows\System32\oobe\msoobe.exe SET @DST=C:
SET LogPath=%@DST%\OEM\AcerLogs\NAPP4P.log
Echo.>>%LogPath%
ECHO %DATE% %TIME%[Log START]  ============ [NAPP]%~dpnx0 ============ >> %LogPath%
pushd "%~dp0"

SET OSDrive=%@DST%
if exist NAPP4P_Patch.cmd (
	ECHO %DATE% %TIME%[Log TRACE]  call NAPP4P_Patch.cmd >>%LogPath% 2>&1
	call NAPP4P_Patch.cmd >>%LogPath% 2>&1
)

ECHO %DATE% %TIME%[Log TRACE]  DIR /S /B .\NAPP4P_Patch\*.cmd >>%LogPath% 2>&1
DIR /S /B .\NAPP4P_Patch\*.cmd >>%LogPath% 2>&1
FOR /F "DELIMS=" %%C in ('DIR /S /B .\NAPP4P_Patch\*.cmd') DO (
	ECHO %DATE% %TIME%[Log TRACE]  call %%C >>%LogPath% 2>&1
	call %%C >>%LogPath% 2>&1
)

popd
ECHO %DATE% %TIME%[Log LEAVE]  ============ [NAPP]%~dpnx0 ============ >> %LogPath%
Echo.>>%LogPath%


