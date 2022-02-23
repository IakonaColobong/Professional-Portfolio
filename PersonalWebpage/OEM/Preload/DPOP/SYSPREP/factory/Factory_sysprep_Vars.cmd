for /f "tokens=3 delims= " %%B in ('reg query HKLM\SOFTWARE\OEM\Metadata /v Brand ^| find /i "Brand"') do set Br=%%B
for /f "tokens=3 delims= " %%B in ('reg query HKLM\SOFTWARE\OEM\Metadata /v Sys ^| find /i "Sys"') do set Sys=%%B
for /f "tokens=3 delims= " %%B in ('reg query HKLM\SOFTWARE\OEM\Metadata /v Type ^| find /i "Type"') do set Type=%%B
ECHO %DATE% %TIME%[Log TRACE]  ======= Local Variables ======= >> %LogPath%
ECHO %DATE% %TIME%[Log TRACE]  BR=%Br% >> %LogPath%
ECHO %DATE% %TIME%[Log TRACE]  Sys=%Sys% >> %LogPath%
ECHO %DATE% %TIME%[Log TRACE]  Type=%Type% >> %LogPath%
ECHO %DATE% %TIME%[Log TRACE]  ======= Local Variables ======= >> %LogPath%