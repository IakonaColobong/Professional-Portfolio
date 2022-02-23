
@Echo OFF
SET LogPath=C:\OEM\AcerLogs\Useralaunch.log
ECHO.>>%LogPath%
ECHO %DATE% %TIME%[Log START]  ============ %~dpnx0 ============ >> %LogPath%
pushd "%~dp0"

ECHO %DATE% %TIME%[Log TRACE]  reg delete HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce /v DesktopCover /f /reg:32 >> %LogPath% 2>&1
reg delete HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce /v DesktopCover /f /reg:32 >> %LogPath% 2>&1

ECHO %DATE% %TIME%[Log TRACE]  reg delete HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce /v DesktopCover /f >> %LogPath% 2>&1
reg delete HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce /v DesktopCover /f >> %LogPath% 2>&1

ECHO %DATE% %TIME%[Log TRACE]  reg delete HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\RunOnce /v DesktopCover /f >> %LogPath% 2>&1
reg delete HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\RunOnce /v DesktopCover /f >> %LogPath% 2>&1

ECHO %DATE% %TIME%[Log TRACE]  del /f /q DesktopCover_launch.bat >>%LogPath% 2>&1
del /f /q DesktopCover_launch.bat >>%LogPath% 2>&1

ECHO %DATE% %TIME%[Log TRACE]  del /f /q DesktopCover.exe >> %LogPath% 2>&1
del /f /q DesktopCover.exe >> %LogPath% 2>&1

ECHO %DATE% %TIME%[Log TRACE]  del /f /q DesktopCover_import.reg >>%LogPath% 2>&1
del /f /q DesktopCover_import.reg >>%LogPath% 2>&1

ECHO %DATE% %TIME%[Log TRACE]  del /f /q DesktopCover_import.bat >>%LogPath% 2>&1
del /f /q DesktopCover_import.bat >>%LogPath% 2>&1

popd
ECHO %DATE% %TIME%[Log LEAVE]  ============ %~dpnx0 ============ >> %LogPath%
ECHO. >>%LogPath%