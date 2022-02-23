
ECHO.>>%LogPath%
ECHO %DATE% %TIME%[Log START]  ============ [SUB]%~dpnx0 ============ >> %LogPath%
pushd "%~dp0"


ECHO %DATE% %TIME%[Log TRACE]  Find /i "SkuDisplayName=" C:\OEM\PRELOAD\command\POP*.ini>>%LogPath%
Find /i "SkuDisplayName=" C:\OEM\PRELOAD\command\POP*.ini>SkuDisplayName.txt
Type SkuDisplayName.txt >>%LogPath%
ECHO %DATE% %TIME%[Log TRACE]  Find /i "in S mode" SkuDisplayName.txt>>%LogPath% 2>&1
Find /i "in S mode" SkuDisplayName.txt>>%LogPath% 2>&1
IF %ERRORLEVEL% NEQ 0 ECHO %DATE% %TIME%[Log TRACE]  This is not Cloud image, goto :END>>%LogPath% && goto :END
::: 2017/3/13 Based on Windows Cloud WEG, set ManufacturingMode for customize image at audit mode.
ECHO %DATE% %TIME%[Log TRACE]  REG LOAD HKLM\TEST C:\Windows\System32\Config\System >>%LogPath% 2>&1
REG LOAD HKLM\TEST C:\Windows\System32\Config\System >>%LogPath% 2>&1
ECHO %DATE% %TIME%[Log TRACE]  REG ADD HKLM\TEST\ControlSet001\Control\CI\Policy /v ManufacturingMode /t REG_DWORD /d 1 /f >>%LogPath% 2>&1
REG ADD HKLM\TEST\ControlSet001\Control\CI\Policy /v ManufacturingMode /t REG_DWORD /d 1 /f >>%LogPath% 2>&1
ECHO %DATE% %TIME%[Log TRACE]  REG Unload HKLM\TEST >>%LogPath% 2>&1
REG Unload HKLM\TEST >>%LogPath% 2>&1


:END
popd
ECHO %DATE% %TIME%[Log LEAVE]  ============ [SUB]%~dpnx0 ============ >> %LogPath%
ECHO.>>%LogPath%