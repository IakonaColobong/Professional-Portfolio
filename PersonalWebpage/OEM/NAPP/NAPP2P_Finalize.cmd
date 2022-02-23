
pushd "%~dp0"
SET LogPath=C:\OEM\AcerLogs\NAPP2P.log
ECHO.>>%LogPath%
ECHO.>>%LogPath%
SETLOCAL ENABLEDELAYEDEXPANSION
ECHO %DATE% %TIME%[Log START]  ============ [NAPP]%~dpnx0 ============ >> %LogPath%

:::
::: 2019/4/8 Move NAPP2P_Finalize_GenerateRegionTag.cmd to Module-SCD_WinPE phase
:::
REM ECHO %DATE% %TIME%[Log TRACE]  call %~dp0\NAPP2P_Finalize_GenerateRegionTag.cmd >>%LogPath%
REM call %~dp0\NAPP2P_Finalize_GenerateRegionTag.cmd
ECHO %DATE% %TIME%[Log TRACE]  call %~dp0\NAPP2P_Finalize_Checkflow.cmd >>%LogPath%
call %~dp0\NAPP2P_Finalize_Checkflow.cmd

:::	2017/3/13 call NAPP2P_Finalize_ManufacturingMode.cmd for Windows Cloud image
if exist %~dp0\NAPP2P_Finalize_ManufacturingMode.cmd (
	ECHO %DATE% %TIME%[Log TRACE]  call %~dp0\NAPP2P_Finalize_ManufacturingMode.cmd >>%LogPath%
	call %~dp0\NAPP2P_Finalize_ManufacturingMode.cmd
)

::: 2017/3/13 Set TPM NoAutoProvision as 1 to prevent OS take owner for TPM
if exist %~dp0\NAPP2P_Finalize_TPMNoAutoProvision.cmd (
	ECHO %DATE% %TIME%[Log TRACE]  call %~dp0\NAPP2P_Finalize_TPMNoAutoProvision.cmd >>%LogPath%
	call %~dp0\NAPP2P_Finalize_TPMNoAutoProvision.cmd
)

::: For leave log that module install in the SCD_WinPE
ECHO %DATE% %TIME%[Log TRACE]  xcopy x:\windows\logs\dism\*.* C:\OEM\AcerLogs\DISM_SCDWinPE\dism\*.* /vesyf >>%LogPath% 2>&1
xcopy x:\windows\logs\dism\*.* C:\OEM\AcerLogs\DISM_SCDWinPE\dism\*.* /vesyf >>%LogPath% 2>&1

if exist C:\OEM\Factory\Factory_2P.cmd (
	ECHO !DATE! !TIME![Log TRACE]  [Start] call C:\OEM\Factory\Factory_2P.cmd >>%LogPath%
	call C:\OEM\Factory\Factory_2P.cmd
	ECHO !DATE! !TIME![Log TRACE]  [Leave] call C:\OEM\Factory\Factory_2P.cmd >>%LogPath%
)
SETLOCAL DISABLEDELAYEDEXPANSION
ECHO %DATE% %TIME%[Log LEAVE]  ============ [NAPP]%~dpnx0 ============ >> %LogPath%
ECHO.>>%LogPath%
ECHO.>>%LogPath%
popd