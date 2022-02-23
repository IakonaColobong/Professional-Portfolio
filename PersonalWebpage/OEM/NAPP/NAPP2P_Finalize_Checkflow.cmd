@echo on
ECHO.>>%LogPath%
ECHO %DATE% %TIME%[Log START]  ============ [SUB]%~dpnx0 ============ >> %LogPath%
pushd "%~dp0"

ECHO %DATE% %TIME%[Log TRACE]  Distinquish the process is D2D, NAPP or NAPP_MLP >> %LogPath%
ECHO %DATE% %TIME%[Log TRACE]  del D2D.tag, NAPP.tag, NAPP_MLP.tag, NAPP_SLP.tag first >>%LogPath%
del /q C:\OEM\NAPP\D2D.tag
del /q C:\OEM\NAPP\NAPP.tag
del /q C:\OEM\NAPP\NAPP_MLP.tag
del /q C:\OEM\NAPP\NAPP_SLP.tag
del /q C:\OEM\NAPP\NAPP_WithHidden.tag

:ChkPXP
IF /I NOT EXIST c:\OEM\Preload\Command\PAP\PXP*.ini (
	ECHO !DATE! !TIME![Log TRACE]  LPCD PXP.INI not found , GOTO :ChkNAPPFlow >>%LogPath%
	GOTO :ChkNAPPFlow
)
ECHO %DATE% %TIME%[Log TRACE]  Counting LPCD PXP*.ini ..... >>%LogPath%
ECHO %DATE% %TIME%[Log TRACE]  dir /b c:\OEM\Preload\Command\PAP\PXP*.ini >>%LogPath%
dir /b c:\OEM\Preload\Command\PAP\PXP*.ini >>%LogPath% 2>&1
for /f "tokens=1" %%i in ('dir /b c:\OEM\Preload\Command\PAP\PXP*.ini ^| find /c /v ""') do set Count_PXP=%%i
ECHO %DATE% %TIME%[Log TRACE]  Got PXP.ini amount is [%Count_PXP%] >>%LogPath%
IF %Count_PXP% GTR 1 (
	ECHO !DATE! !TIME![Log TRACE]  Create C:\OEM\NAPP\NAPP_MLP.tag >>%LogPath%
	dir /b c:\OEM\Preload\Command\PAP\PXP*.ini >C:\OEM\NAPP\NAPP_MLP.tag
) ElSE (
	ECHO !DATE! !TIME![Log TRACE]  Create C:\OEM\NAPP\NAPP_SLP.tag >>%LogPath%
	dir /b c:\OEM\Preload\Command\PAP\PXP*.ini >C:\OEM\NAPP\NAPP_SLP.tag
)

:ChkNAPPFlow
SET ThisFlow=D2D
FIND /I "FLOW=NAPP" C:\OEM\Preload\Command\AlaunchX\NAPP.INI && SET ThisFlow=NAPP>>%LogPath% 2>&1
ECHO %DATE% %TIME%[Log TRACE]  Create C:\OEM\NAPP\%ThisFlow%.tag >>%LogPath%
ECHO. >C:\OEM\NAPP\%ThisFlow%.tag


:ChkHiddenCase
If exist M:\D2D_WIN10\*.* (
	ECHO !DATE! !TIME![Log TRACE]  Found M:\D2D_WIN10 , create C:\OEM\NAPP\NAPP_WithHidden.tag >>%LogPath%
	ECHO !DATE! !TIME![Log TRACE]  Found M:\D2D_WIN10 , create C:\OEM\NAPP\NAPP_WithHidden.tag >C:\OEM\NAPP\NAPP_WithHidden.tag
)


:END
popd
ECHO %DATE% %TIME%[Log LEAVE]  ============ [SUB]%~dpnx0 ============ >> %LogPath%
ECHO.>>%LogPath%