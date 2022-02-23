@Echo off
ECHO.>>%LogPath%
ECHO %DATE% %TIME%[Log START]  ============ [SUB]%~dpnx0 ============ >> %LogPath%
:START
pushd "%~dp0"

ECHO [%DATE% %TIME%]  find /i "GCM=Y" C:\OEM\Preload\Command\POP*.ini>>%LogPath% 2>&1
find /i "GCM=Y" C:\OEM\Preload\Command\POP*.ini>>%LogPath% 2>&1
if %ERRORLEVEL% NEQ 0 (
	ECHO [!DATE! !TIME!]  Not GCM image, leave. >>%LogPath%
	goto :END
)
ECHO %DATE% %TIME%[Log TRACE]  C:\OEM\preload\utility\GCM\MRDCreaterX_%Processor_Architecture%.exe /TB_RS /IMWhiteListPath:c:\OEM\preload\DPOP\GCMReadiness\IM_WhiteList.txt>> %LogPath%
C:\OEM\preload\utility\GCM\MRDCreaterX_%Processor_Architecture%.exe /TB_RS /IMWhiteListPath:c:\OEM\preload\DPOP\GCMReadiness\IM_WhiteList.txt>>%LogPath% 2>&1
ECHO.>>%LogPath%

IF /I EXIST C:\OEM\preload\utility\GCM\TBMRD.xml (
	ECHO !DATE! !TIME![Log TRACE]  copy /y C:\OEM\preload\utility\GCM\TBMRD.xml C:\Users\Default\AppData\Local\Microsoft\Windows\Shell\TaskbarLayoutModification.xml >>%LogPath% 2>&1
	copy /y C:\OEM\preload\utility\GCM\TBMRD.xml C:\Users\Default\AppData\Local\Microsoft\Windows\Shell\TaskbarLayoutModification.xml >>%LogPath% 2>&1
	ECHO !DATE! !TIME![Log TRACE]  Copy /y C:\OEM\preload\utility\GCM\TBMRD.xml C:\Recovery\OEM\RestoreOEMCustomize\TaskbarLayoutModification.xml >>%LogPath% 2>&1
	Copy /y C:\OEM\preload\utility\GCM\TBMRD.xml C:\Recovery\OEM\RestoreOEMCustomize\TaskbarLayoutModification.xml >>%LogPath% 2>&1
	ECHO !DATE! !TIME![Log TRACE]  Copy /y SUB_AddTaskbarLayoutPath.cmd C:\Recovery\OEM\RestoreOEMCustomize\RestoreCMD >>%LogPath% 2>&1
	Copy /y SUB_AddTaskbarLayoutPath.cmd C:\Recovery\OEM\RestoreOEMCustomize\RestoreCMD >>%LogPath% 2>&1
	ECHO !DATE! !TIME![Log TRACE]  Copy /y TaskbarLayoutPath.reg C:\Recovery\OEM\RestoreOEMCustomize\RestoreCMD >>%LogPath% 2>&1
	Copy /y TaskbarLayoutPath.reg C:\Recovery\OEM\RestoreOEMCustomize\RestoreCMD >>%LogPath% 2>&1
)


:END
popd
ECHO %DATE% %TIME%[Log LEAVE]  ============ [SUB]%~dpnx0 ============ >> %LogPath%
ECHO.>>%LogPath%