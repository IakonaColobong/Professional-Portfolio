@Echo off
SET LogPath=C:\OEM\AcerLogs\AuditAlaunch.log
ECHO.>>%LogPath%
ECHO %DATE% %TIME%[Log START]  ============ %~dpnx0 ============ >> %LogPath%


ECHO %DATE% %TIME%[Log TRACE]  Check out if there's any POP with one more digit ^(Over RV36^) >> %LogPath%
ECHO %DATE% %TIME%[Log TRACE]  [Before] dir C:\OEM\Preload\COMMAND\POP*.ini >>%LogPath%
dir C:\OEM\Preload\COMMAND\POP*.ini >>%LogPath% 2>&1
ECHO %DATE% %TIME%[Log TRACE]  CScript.exe MakePOPCopy_GTRV36.vbs "C:\OEM\Preload\COMMAND" >>%LogPath%
CScript.exe MakePOPCopy_GTRV36.vbs "C:\OEM\Preload\COMMAND" >>%LogPath% 2>&1
ECHO %DATE% %TIME%[Log TRACE]  [After] dir C:\OEM\Preload\COMMAND\POP*.ini >>%LogPath%
dir C:\OEM\Preload\COMMAND\POP*.ini >>%LogPath% 2>&1

ECHO %DATE% %TIME%[Log LEAVE]  ============ %~dpnx0 ============ >> %LogPath%
ECHO.>>%LogPath%