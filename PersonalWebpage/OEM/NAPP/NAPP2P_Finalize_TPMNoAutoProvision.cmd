
ECHO.>>%LogPath%
ECHO %DATE% %TIME%[Log START]  ============ [SUB]%~dpnx0 ============ >> %LogPath%
pushd "%~dp0"


ECHO %DATE% %TIME%[Log TRACE]  REG LOAD HKLM\TEST C:\Windows\System32\Config\System >>%LogPath% 2>&1
REG LOAD HKLM\TEST C:\Windows\System32\Config\System >>%LogPath% 2>&1
ECHO %DATE% %TIME%[Log TRACE]  REG ADD HKLM\TEST\ControlSet001\Services\TPM\WMI /v NoAutoProvision /t REG_DWORD /d 1 /f >>%LogPath% 2>&1
REG ADD HKLM\TEST\ControlSet001\Services\TPM\WMI /v NoAutoProvision /t REG_DWORD /d 1 /f >>%LogPath% 2>&1
ECHO %DATE% %TIME%[Log TRACE]  REG Unload HKLM\TEST >>%LogPath% 2>&1
REG Unload HKLM\TEST >>%LogPath% 2>&1


:END
popd
ECHO %DATE% %TIME%[Log LEAVE]  ============ [SUB]%~dpnx0 ============ >> %LogPath%
ECHO.>>%LogPath%