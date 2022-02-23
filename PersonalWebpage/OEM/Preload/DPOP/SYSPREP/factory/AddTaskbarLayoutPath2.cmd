@ECHO OFF
SET LogPath=C:\OEM\AcerLogs\BeforeOOBE.log
Echo.>>%LogPath%
ECHO %DATE% %TIME%[Log START]  ============ %~dpnx0 ============ >> %LogPath%
pushd %~dp0


ECHO %DATE% %TIME%[Log TRACE]  reg import TaskbarLayoutPath_Online.reg>>%LogPath% 2>&1
reg import TaskbarLayoutPath_Online.reg>>%LogPath% 2>&1

popd
ECHO %DATE% %TIME%[Log Leave]  ============ %~dpnx0 ============ >> %LogPath%
Echo.>>%LogPath%