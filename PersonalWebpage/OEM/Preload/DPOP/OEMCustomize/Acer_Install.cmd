@echo off
Set LogPath=C:\OEM\AcerLogs\AuditAlaunch.log
pushd "%~dp0"
ECHO.>>%LogPath%
ECHO.>>%LogPath%
ECHO %DATE% %TIME%[Log START]  ============ %~dpnx0 ============ >> %LogPath%

ECHO %DATE% %TIME%[Log TRACE]  CScript /nologo C:\OEM\Preload\utility\_GetACERDATALetter.vbs to vols.log >>%LogPath%
CScript /nologo C:\OEM\Preload\utility\_GetACERDATALetter.vbs>vols.log
type vols.log >>%LogPath%
FOR /F "delims=" %%D in (vols.log) do SET AcerDataDrive=%%D


ECHO %DATE% %TIME%[Log TRACE]  call c:\oem\preload\command\alaunchx\PrepareAlaunchX.cmd AuditAlaunchX
call c:\oem\preload\command\alaunchx\PrepareAlaunchX.cmd AuditAlaunch
ECHO %DATE% %TIME%[Log TRACE]  Install Alaunch For auditmode, regedit /s .\Launch.reg >> %LogPath%
regedit /s .\Launch.reg >> %LogPath% 2>&1

popd
ECHO %DATE% %TIME%[Log LEAVE]  ============ %~dpnx0 ============ >> %LogPath%
ECHO.>>%LogPath%
ECHO.>>%LogPath%