
@ECHO OFF
MD C:\OEM\AcerLogs
SET LogPath=C:\OEM\AcerLogs\Useralaunch.log
Echo.>>%LogPath%
ECHO %DATE% %TIME%[Log START]  ============ [NAPP]%~dpnx0 ============ >> %LogPath%

ECHO %DATE% %TIME%[Log TRACE]  regedit /s C:\OEM\Preload\DPOP\OEMCustomize\LaunchFactory.reg >>%LogPath%
regedit /s C:\OEM\Preload\DPOP\OEMCustomize\LaunchFactory.reg >>%LogPath% 2>&1

ECHO %DATE% %TIME%[Log LEAVE]  ============ [NAPP]%~dpnx0 ============ >> %LogPath%
Echo.>>%LogPath%