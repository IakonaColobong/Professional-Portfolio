
@ECHO OFF
SET LogPath=C:\OEM\AcerLogs\Useralaunch.log
ECHO.>>%LogPath%
ECHO %DATE% %TIME%[Log START]  ============ %~dpnx0 ============ >> %LogPath%
pushd "%~dp0"

:GetSCLTemplate
SET SCLTemplate=Consumer
ECHO %DATE% %TIME%[Log TRACE]  FIND /i "APP Template=" C:\OEM\Preload\Command\PAP\PAP*.INI >>%LogPath%
FIND /i "APP Template=" C:\OEM\Preload\Command\PAP\PAP*.INI >C:\OEM\SCLTemplate.txt
ECHO %DATE% %TIME%[Log TRACE]  FIND /i "Commercial" C:\OEM\SCLTemplate.txt >>%LogPath%
FIND /i "Commercial" C:\OEM\SCLTemplate.txt >>%LogPath% 2>&1
IF %ERRORLEVEL% EQU 0 SET SCLTemplate=Commercial

ECHO %DATE% %TIME%[Log TRACE]  FIND /i "Model Type Name=Nitro" C:\OEM\Preload\Command\PAP\PAP*.INI>>%LogPath% 2>&1
FIND /i "Model Type Name=Nitro" C:\OEM\Preload\Command\PAP\PAP*.INI>>%LogPath% 2>&1
IF %ERRORLEVEL% EQU 0 SET SCLTemplate=Gaming

ECHO %DATE% %TIME%[Log TRACE]  FIND /i "Model Type Name=Predator" C:\OEM\Preload\Command\PAP\PAP*.INI>>%LogPath% 2>&1
FIND /i "Model Type Name=Predator" C:\OEM\Preload\Command\PAP\PAP*.INI>>%LogPath% 2>&1
IF %ERRORLEVEL% EQU 0 SET SCLTemplate=Gaming


:GetBrand
FOR /f "SKIP=2 Tokens=3 delims= " %%B in ('REG Query HKLM\Software\OEM\Metadata /v brand') do SET BR=%%B
IF /i "%BR%" EQU "Packard" SET BR=PackardBell
ECHO %DATE% %TIME%[Log TRACE]  Got [BR=%BR%] >>%LogPath%
IF /i "%BR%" EQU "acer" (
	ECHO %DATE% %TIME%[Log TRACE]  copy /y acer01_%SCLTemplate%.jpg c:\windows\web\wallpaper\acer01.jpg >>%LogPath%
	copy /y acer01_%SCLTemplate%.jpg c:\windows\web\wallpaper\acer01.jpg >>%LogPath% 2>&1
) else (
	copy /y %BR%01.jpg c:\windows\web\wallpaper\ >>%LogPath% 2>&1
)

ECHO %DATE% %TIME%[Log TRACE]  del /f /q *.jpg >>%LogPath% 2>&1
del /f /q *.jpg >>%LogPath% 2>&1

:END
popd
ECHO %DATE% %TIME%[Log LEAVE]  ============ %~dpnx0 ============ >> %LogPath%
ECHO.>>%LogPath%