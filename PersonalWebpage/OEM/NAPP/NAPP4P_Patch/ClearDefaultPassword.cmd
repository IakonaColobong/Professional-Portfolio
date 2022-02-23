
@ECHO OFF
Echo.
ECHO %DATE% %TIME%[Log START]  ============ [SUB]%~dpnx0 ============
pushd "%~dp0"

ECHO %DATE% %TIME%[Log TRACE]  REG LOAD HKLM\TEST C:\Windows\System32\Config\SOFTWARE
REG LOAD HKLM\TEST C:\Windows\System32\Config\SOFTWARE

ECHO %DATE% %TIME%[Log TRACE]  reg query "HKLM\TEST\Microsoft\Windows NT\CurrentVersion\Winlogon"
reg query "HKLM\TEST\Microsoft\Windows NT\CurrentVersion\Winlogon"

ECHO %DATE% %TIME%[Log TRACE]  reg delete "HKLM\TEST\Microsoft\Windows NT\CurrentVersion\Winlogon" /v DefaultPassword /f
reg delete "HKLM\TEST\Microsoft\Windows NT\CurrentVersion\Winlogon" /v DefaultPassword /f

ECHO %DATE% %TIME%[Log TRACE]  REG Unload HKLM\TEST
REG Unload HKLM\TEST

popd
ECHO %DATE% %TIME%[Log LEAVE]  ============ [SUB]%~dpnx0 ============
Echo.
