
@ECHO OFF
MD C:\OEM\AcerLogs
SET LogPath=C:\OEM\AcerLogs\Useralaunch.log
Echo.>>%LogPath%
Echo.>>%LogPath%
ECHO %DATE% %TIME%[Log START]  ============ [NAPP]%~dpnx0 ============ >> %LogPath%

ECHO %DATE% %TIME%[Log TRACE]  call C:\OEM\NAPP\GoToNAPP.cmd>>%LogPath%
call C:\OEM\NAPP\GoToNAPP.cmd

ECHO %DATE% %TIME%[Log LEAVE]  ============ [NAPP]%~dpnx0 ============ >> %LogPath%
Echo.>>%LogPath%
Echo.>>%LogPath%