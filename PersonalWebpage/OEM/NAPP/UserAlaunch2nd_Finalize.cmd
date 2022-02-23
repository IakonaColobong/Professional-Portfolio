
@ECHO OFF
SETLOCAL ENABLEDELAYEDEXPANSION
SET LogPath=C:\OEM\AcerLogs\Useralaunch.log
Echo.>>%LogPath%

pushd %~dp0
ECHO %DATE% %TIME%[Log START]  ============ [NAPP]%~dpnx0 ============ >> %LogPath%

REM 2015/5/12 Rhea for support GAIA Autobuild, add PreTest.cmd detection
IF /i exist C:\OEM\Preload\AutoBuildPreTest\PreTest.cmd (
	ECHO !DATE! !TIME![Log TRACE]  Call C:\OEM\Preload\AutoBuildPreTest\PreTest.cmd >>%LogPath%
	Call C:\OEM\Preload\AutoBuildPreTest\PreTest.cmd
)

ECHO !DATE! !TIME![Log TRACE]  Call C:\OEM\NAPP\GoToNAPP.cmd to go to NAPP4P >>%LogPath%
Call C:\OEM\NAPP\GoToNAPP.cmd

SETLOCAL DISABLEDELAYEDEXPANSION
ECHO %DATE% %TIME%[Log LEAVE]  ============ [NAPP]%~dpnx0 ============ >> %LogPath%
Echo.>>%LogPath%

popd