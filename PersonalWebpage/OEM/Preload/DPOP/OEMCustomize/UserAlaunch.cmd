@echo off
Set LogPath=C:\OEM\AcerLogs\Useralaunch.log
ECHO. >>%LogPath%
ECHO. >>%LogPath%
ECHO %DATE% %TIME%[Log START]  ============ %~dpnx0 ============ >> %LogPath%
pushd %~dp0
SETLOCAL ENABLEDELAYEDEXPANSION

REM 2015/6/2 Rhea
REM		Remove Audit mode SWOD for spec changed.
REM 2015/5/12 Rhea
REM 	Launch AlaunchX via "RUN"
ECHO !DATE! !TIME![Log TRACE]  regedit /s .\LaunchFactory.reg>>%LogPath%
regedit /s .\LaunchFactory.reg>>%LogPath% 2>&1

REM 2015/2/24 Rhea
REM 		Revise call UserAlaunch1st_Initialize.cmd path to C:\OEM\NAPP
ECHO !DATE! !TIME![Log TRACE]  call C:\OEM\NAPP\UserAlaunch1st_Initialize.cmd>>%LogPath%
call C:\OEM\NAPP\UserAlaunch1st_Initialize.cmd
SETLOCAL DISABLEDELAYEDEXPANSION
popd
ECHO %DATE% %TIME%[Log LEAVE]  ============ %~dpnx0 ============ >> %LogPath%
ECHO. >>%LogPath%
ECHO. >>%LogPath%
REM 2015/6/9 Rhea
REM Remove shutdown, due to the "RUN" too early execute before shutdown in Win10
REM shutdown /r /t 5