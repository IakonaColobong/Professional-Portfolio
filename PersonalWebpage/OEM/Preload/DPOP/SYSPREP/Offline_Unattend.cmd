
@ECHO OFF
SET LogPath=C:\OEM\AcerLogs\SCD_WinPE.log
ECHO.>>%LogPath%
ECHO %DATE% %TIME%[Log START]  ============ %~dpnx0 ============ >> %LogPath%
SETLOCAL EnableDelayedExpansion
pushd "%~dp0"

::::	PAP.ini will be copied to C:\OEM\Preload\Command\PAP after SCD_WinPE module execute finish
SET PAPINIPath=C:\TempHidden\SCD\Patch\Tools\PreloadPN\PAP
IF EXIST M:\D2D_WIN10\SCD\Patch\Tools\PreloadPN\PAP (
	ECHO !DATE! !TIME![Log TRACE]  SET PAPINIPath=M:\D2D_WIN10\SCD\Patch\Tools\PreloadPN\PAP >>%LogPath% 2>&1
	SET PAPINIPath=M:\D2D_WIN10\SCD\Patch\Tools\PreloadPN\PAP
)
SET CPUArchitecture=X86
ECHO %DATE% %TIME%[Log TRACE]  FIND /I "CPU=X64" C:\OEM\Preload\Command\POP*.INI>>%LogPath% 2>&1
FIND /I "CPU=X64" C:\OEM\Preload\Command\POP*.INI>>%LogPath% 2>&1 && SET CPUArchitecture=amd64

SET bChangeWP=FALSE
ECHO !DATE! !TIME![Log TRACE]  Checking if exist ConceptD image... >>%LogPath%
ECHO !DATE! !TIME![Log TRACE]  find /i "Model Type Name=ConceptD" %PAPINIPath%\PAP*.ini >> %LogPath% 2>&1
find /i "Model Type Name=ConceptD" %PAPINIPath%\PAP*.ini >> %LogPath% 2>&1 && SET bChangeWP=TRUE

FIND /I "Offline-RCD=Y" C:\OEM\Preload\Command\POP*.ini >>%LogPath% 2>&1
IF %ERRORLEVEL% EQU 0 (
	ECHO !DATE! !TIME![Log TRACE]  Find /I "Brand=" %PAPINIPath%\PAP*.ini >> %LogPath% 2>&1
	Find /I "Brand=" %PAPINIPath%\PAP*.ini >> %LogPath% 2>&1
	For /f "skip=2 tokens=2 delims== " %%A in ('Find /I "Brand=" %PAPINIPath%\PAP*.ini') do SET Brand=%%A
	ECHO !DATE! !TIME![Log TRACE]  Brand=[!Brand!] >>%LogPath%
	ECHO !DATE! !TIME![Log TRACE]  call Acer_sysprep_SetNotificationICON.cmd "%~d0\OEM\Preload\DPOP\Sysprep\OfflineRCD\%CPUArchitecture%\!Brand!\Unattend.xml" >>%LogPath%
	call Acer_sysprep_SetNotificationICON.cmd "%~d0\OEM\Preload\DPOP\Sysprep\OfflineRCD\%CPUArchitecture%\!Brand!\Unattend.xml"
	ECHO !DATE! !TIME![Log TRACE]  call Acer_sysprep_SetEdgeFavoriteBar.cmd "%~d0\OEM\Preload\DPOP\Sysprep\OfflineRCD\%CPUArchitecture%\!Brand!\Unattend.xml" >>%LogPath%
	call Acer_sysprep_SetEdgeFavoriteBar.cmd "%~d0\OEM\Preload\DPOP\Sysprep\OfflineRCD\%CPUArchitecture%\!Brand!\Unattend.xml"
	if /i "%bChangeWP%" equ "TRUE" (
		ECHO !DATE! !TIME![Log TRACE]  This is ConceptD image, call Acer_sysprep_ChangeWallpaper.cmd "%~d0\OEM\Preload\DPOP\Sysprep\OfflineRCD\%CPUArchitecture%\!Brand!\Unattend.xml" >> %LogPath% 2>&1
		call Acer_sysprep_ChangeWallpaper.cmd "%~d0\OEM\Preload\DPOP\Sysprep\OfflineRCD\%CPUArchitecture%\!Brand!\Unattend.xml" >> %LogPath% 2>&1
	) else ( ECHO !DATE! !TIME![Log TRACE]  This is not ConceptD image. >>%LogPath% )
	ECHO !DATE! !TIME![Log TRACE]  md C:\Windows\Panther >>%LogPath% 2>&1
	md C:\Windows\Panther >>%LogPath% 2>&1
	ECHO !DATE! !TIME![Log TRACE]  copy /y C:\OEM\Preload\DPOP\Sysprep\OfflineRCD\%CPUArchitecture%\!Brand!\Unattend.xml C:\Windows\Panther >>%LogPath%
	copy /y .\OfflineRCD\%CPUArchitecture%\!Brand!\Unattend.xml C:\Windows\Panther >>%LogPath% 2>&1
) ELSE (
	ECHO !DATE! !TIME![Log TRACE]  Not Offline-RCD, do nothing. >>%LogPath%
)

popd
SETLOCAL DisableDelayedExpansion
ECHO %DATE% %TIME%[Log LEAVE]  ============ %~dpnx0 ============ >> %LogPath%
ECHO.>>%LogPath%