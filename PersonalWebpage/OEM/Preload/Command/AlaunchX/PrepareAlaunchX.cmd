
@ECHO OFF
SET LogPath=C:\OEM\AcerLogs\%1.log
ECHO.>>%LogPath%
ECHO %DATE% %TIME%[Log START]  ============ %~dpnx0 ============ >> %LogPath%
pushd "%~dp0"
ECHO %DATE% %TIME%[Log TRACE]  copy /y acerReboot.exe c:\windows\system32\*.* >>%LogPath% 2>&1
if exist acerReboot.exe (
	copy /y acerReboot.exe c:\windows\system32\*.* >>%LogPath% 2>&1
)
call :%1
ECHO %DATE% %TIME%[Log TRACE]  del /f /q acerReboot.exe >>%LogPath%
del /f /q acerReboot.exe >>%LogPath%
popd
ECHO %DATE% %TIME%[Log LEAVE]  ============ %~dpnx0 ============ >> %LogPath%
ECHO.>>%LogPath%
exit /b 0


:AuditAlaunch
REM 2015/6/22 Rhea
REM 		this Sub will be callbed by Acer_Install.cmd
ECHO %DATE% %TIME%[Log TRACE]  call :PrepareAlaunchX >>%LogPath%
call :PrepareAlaunchX
exit /b 0


:SCD_WinPE
REM 2015/6/18 Rhea
REM 	for Support update via SCD, If exist AlaunchX_%PROCESSOR_ARCHITECTURE%, then should update AlaunchX
IF /I EXIST .\AlaunchX_%PROCESSOR_ARCHITECTURE%\*.* (
	ECHO %DATE% %TIME%[Log TRACE]  call :PrepareAlaunchX >>%LogPath%
	call :PrepareAlaunchX
) ELSE (
	ECHO %DATE% %TIME%[Log TRACE]  AlaunchX_%PROCESSOR_ARCHITECTURE% not found, do nothing. >>%LogPath%
)
exit /b 0


:PrepareAlaunchX
ECHO %DATE% %TIME%[Log TRACE]  Copy /y .\AlaunchX_%PROCESSOR_ARCHITECTURE%\*.* .\*.* >>%LogPath%
Copy /y .\AlaunchX_%PROCESSOR_ARCHITECTURE%\*.* .\*.* >>%LogPath% 2>&1
ECHO %DATE% %TIME%[Log TRACE]  RD /S /Q AlaunchX_amd64 >>%LogPath% 2>&1
RD /S /Q AlaunchX_amd64 >>%LogPath% 2>&1
ECHO %DATE% %TIME%[Log TRACE]  RD /S /Q AlaunchX_x86 >>%LogPath% 2>&1
RD /S /Q AlaunchX_x86 >>%LogPath% 2>&1
exit /b 0