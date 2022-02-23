
@ECHO OFF
MD C:\OEM\AcerLogs
SET LogPath=C:\OEM\AcerLogs\Useralaunch.log
Echo.>>%LogPath%
ECHO %DATE% %TIME%[Log START]  ============ [NAPP]%~dpnx0 ============ >> %LogPath%

ECHO %DATE% %TIME%[Log TRACE]  SET Default Power Plan as High performance, POWERCFG -SETACTIVE 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c >>%LogPath%
POWERCFG -SETACTIVE 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c
ECHO %DATE% %TIME%[Log TRACE]  POWERCFG /L >>%LogPath% 2>&1
POWERCFG /L >>%LogPath% 2>&1

ECHO %DATE% %TIME%[Log LEAVE]  ============ [NAPP]%~dpnx0 ============ >> %LogPath%
Echo.>>%LogPath%