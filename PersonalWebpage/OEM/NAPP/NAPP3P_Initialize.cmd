@ECHO OFF
IF EXIST N:\Windows\System32\oobe\msoobe.exe SET @DST=N:
IF EXIST C:\Windows\System32\oobe\msoobe.exe SET @DST=C:
SET LogPath=%@DST%\OEM\AcerLogs\NAPP3P.log
Echo.>>%LogPath%
Echo.>>%LogPath%

pushd %~dp0
ECHO %DATE% %TIME%[Log START]  ============ [NAPP]%~dpnx0 ============ >> %LogPath%
ECHO %DATE% %TIME%[Log LEAVE]  ============ [NAPP]%~dpnx0 ============ >> %LogPath%
Echo. >>%LogPath%
popd