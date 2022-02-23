@ECHO OFF
SET LogPath=C:\OEM\AcerLogs\SCD_WinPE.log
Echo.>>%LogPath%
ECHO %DATE% %TIME%[Log START]  ============ %~dpnx0 ============ >> %LogPath%
pushd %~dp0


SET OSDrive=%~d0
ECHO %DATE% %TIME%[Log TRACE]  OSDrive=[%OSDrive%] >>%LogPath%
ECHO %DATE% %TIME%[Log TRACE]  call SUB_AddTaskbarLayoutPath.cmd >>%LogPath% 2>&1
call SUB_AddTaskbarLayoutPath.cmd >>%LogPath% 2>&1


popd
ECHO %DATE% %TIME%[Log Leave]  ============ %~dpnx0 ============ >> %LogPath%
Echo.>>%LogPath%