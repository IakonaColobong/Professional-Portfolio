
@echo off
title Configuring System... Please wait...
Set LogPath=C:\OEM\AcerLogs\BeforeOOBE.log
ECHO.>>%LogPath%
ECHO.>>%LogPath%
ECHO %DATE% %TIME%[Log START]  ============ %~dpnx0 ============ >> %LogPath%
pushd %~dp0
ECHO %DATE% %TIME%[Log TRACE]  Cscript /nologo C:\OEM\Preload\utility\_Timeout.vbs 10>> %LogPath% 2>&1
Cscript /nologo C:\OEM\Preload\utility\_Timeout.vbs 10>> %LogPath% 2>&1

ECHO %DATE% %TIME%[Log TRACE]  c:\OEM\preload\command\alaunchx\alaunchx.exe /BeforeOOBE >> %LogPath%
c:\OEM\preload\command\alaunchx\alaunchx.exe /BeforeOOBE

REM 2014/12/16 Rhea
REM Add AlaunchX WatchDog Service
REM To Prevent explorer crashed but AlaunchX didn't back after explorer
ECHO %DATE% %TIME%[Log TRACE]  create AlaunchX WatchDog Service >>%LogPath% 2>&1
sc create AlaunchXWatchDog binPath="C:\OEM\preload\utility\AlaunchXWatchDog\WatchDog.exe" displayName="AlaunchX WatchDog Service" start=auto >>%LogPath% 2>&1
ECHO %DATE% %TIME%[Log TRACE]  sc start AlaunchXWatchDog>>%LogPath% 2>&1
sc start AlaunchXWatchDog>>%LogPath% 2>&1


REM 2017/5/18 Rhea
REM 	Add AlaunchX Reboot WatchDog Service
REM 	To Prevent AlaunchX call shutdown but fail by Event ID 1073
REM		"The attempt to reboot XXX-XXX failed"
ECHO %DATE% %TIME%[Log TRACE]  create AlaunchX WatchDog Service >>%LogPath% 2>&1
sc create RebootWatchDog binPath="C:\OEM\preload\utility\RebootWatchDog\WatchDog.exe" displayName="AlaunchX Reboot WatchDog Service" start=auto >>%LogPath% 2>&1
ECHO %DATE% %TIME%[Log TRACE]  sc start RebootWatchDog>>%LogPath% 2>&1
sc start RebootWatchDog>>%LogPath% 2>&1

ECHO %DATE% %TIME%[Log LEAVE]  ============ %~dpnx0 ============ >> %LogPath%
ECHO.>>%LogPath%
ECHO.>>%LogPath%
popd