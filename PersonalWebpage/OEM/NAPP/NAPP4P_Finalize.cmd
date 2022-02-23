
@ECHO OFF
SETLOCAL ENABLEDELAYEDEXPANSION
pushd "%~dp0"

IF EXIST N:\Windows\System32\oobe\msoobe.exe SET @DST=N:
IF EXIST C:\Windows\System32\oobe\msoobe.exe SET @DST=C:
md %@DST%\OEM\AcerLogs2
SET LogPath=%@DST%\OEM\AcerLogs2\NAPP4P.log
Echo.>>%LogPath%
Echo.>>%LogPath%
ECHO %DATE% %TIME%[Log START]  ============ [NAPP]%~dpnx0 ============ >> %LogPath%

ECHO %DATE% %TIME%[Log TRACE]  icacls C:\Recovery\Customizations /inheritance:r /T >>%LogPath% 2>&1
icacls C:\Recovery\Customizations /inheritance:r /T >>%LogPath% 2>&1
ECHO %DATE% %TIME%[Log TRACE]  icacls C:\Recovery\Customizations /grant:r SYSTEM:^(F^) /T >>%LogPath% 2>&1
icacls C:\Recovery\Customizations /grant:r SYSTEM:(F) /T >>%LogPath% 2>&1
ECHO %DATE% %TIME%[Log TRACE]  icacls C:\Recovery\Customizations /grant:r *S-1-5-32-544:^(F^) /T >>%LogPath% 2>&1
icacls C:\Recovery\Customizations /grant:r *S-1-5-32-544:(F) /T >>%LogPath% 2>&1
ECHO %DATE% %TIME%[Log TRACE]  icacls C:\Recovery\OEM /inheritance:r /T >>%LogPath% 2>&1
icacls C:\Recovery\OEM /inheritance:r /T >>%LogPath% 2>&1
ECHO %DATE% %TIME%[Log TRACE]  icacls C:\Recovery\OEM /grant:r SYSTEM:^(F^) /T >>%LogPath% 2>&1
icacls C:\Recovery\OEM /grant:r SYSTEM:(F) /T >>%LogPath% 2>&1
ECHO %DATE% %TIME%[Log TRACE]  icacls C:\Recovery\OEM /grant:r *S-1-5-32-544:^(F^) /T >>%LogPath% 2>&1
icacls C:\Recovery\OEM /grant:r *S-1-5-32-544:(F) /T >>%LogPath% 2>&1
ECHO %DATE% %TIME%[Log TRACE]  attrib +H C:\Recovery >>%LogPath% 2>&1
attrib +H C:\Recovery >>%LogPath% 2>&1

::: 2017/3/27 Remove WinRE Enable workaround, NAPP revise boot to WinPE script to fix WinRE be disabled issue.
REM ECHO %DATE% %TIME%[Log TRACE]  call C:\OEM\Preload\DPOP\WINRECUSTOMIZE\Enable_WinRE.cmd >>%LogPath%
REM call C:\OEM\Preload\DPOP\WINRECUSTOMIZE\Enable_WinRE.cmd NAPP4P


::: For Founder HPA
IF EXIST c:\oem\preload\Softlumos\NAPP4P_Softlumos.cmd (
	ECHO !DATE! !TIME![Log TRACE]  call c:\oem\preload\Softlumos\NAPP4P_Softlumos.cmd>>%LogPath%
	call c:\oem\preload\Softlumos\NAPP4P_Softlumos.cmd >>%LogPath% 2>&1
)
::: For Discard ALT+F10
IF EXIST C:\OEM\Preload\ResourceCD\*.* (
	ECHO !DATE! !TIME![Log TRACE]  This is HPA case >>%LogPath%
	IF EXIST E:\EFI\OEM (
		ECHO !DATE! !TIME![Log TRACE]  RD /S /Q E:\EFI\OEM >>%LogPath% 2>&1
		RD /S /Q E:\EFI\OEM >>%LogPath% 2>&1
	) else (
		ECHO !DATE! !TIME![Log TRACE]  E:\EFI\OEM not found. >>%LogPath%
	)
) ELSE (
	ECHO !DATE! !TIME![Log TRACE]  C:\OEM\Preload\ResourceCD\*.* not found. >>%LogPath%
)

ECHO %DATE% %TIME%[Log TRACE]  Find /i "SkuDisplayName=" C:\OEM\PRELOAD\command\POP*.ini>>%LogPath%
Find /i "SkuDisplayName=" C:\OEM\PRELOAD\command\POP*.ini>SkuDisplayName.txt
Type SkuDisplayName.txt >>%LogPath%
ECHO %DATE% %TIME%[Log TRACE]  Find /i "in S mode" SkuDisplayName.txt>>%LogPath% 2>&1
Find /i "in S mode" SkuDisplayName.txt>>%LogPath% 2>&1
IF %ERRORLEVEL% EQU 0 (
	ECHO %DATE% %TIME%[Log TRACE]  This is Cloud image>>%LogPath%
	ECHO %DATE% %TIME%[Log TRACE]  REG LOAD HKLM\TEST C:\Windows\System32\Config\System >>%LogPath% 2>&1
	REG LOAD HKLM\TEST C:\Windows\System32\Config\System >>%LogPath% 2>&1
	ECHO %DATE% %TIME%[Log TRACE]  REG DELETE HKLM\TEST\ControlSet001\Control\CI\Policy /v ManufacturingMode /f >>%LogPath% 2>&1
	REG DELETE HKLM\TEST\ControlSet001\Control\CI\Policy /v ManufacturingMode /f >>%LogPath% 2>&1
	ECHO %DATE% %TIME%[Log TRACE]  REG Unload HKLM\TEST >>%LogPath% 2>&1
	REG Unload HKLM\TEST >>%LogPath% 2>&1
) ELSE (
	ECHO %DATE% %TIME%[Log TRACE]  This is not Cloud image>>%LogPath%
)


:::	2017/3/13 Remove NoAutoProvision for TPM feature
ECHO %DATE% %TIME%[Log TRACE]  REG LOAD HKLM\TEST C:\Windows\System32\Config\System >>%LogPath% 2>&1
REG LOAD HKLM\TEST C:\Windows\System32\Config\System >>%LogPath% 2>&1
ECHO %DATE% %TIME%[Log TRACE]  REG DELETE HKLM\TEST\ControlSet001\Services\TPM\WMI /v NoAutoProvision /f >>%LogPath% 2>&1
REG DELETE HKLM\TEST\ControlSet001\Services\TPM\WMI /v NoAutoProvision /f >>%LogPath% 2>&1
ECHO %DATE% %TIME%[Log TRACE]  REG Unload HKLM\TEST >>%LogPath% 2>&1
REG Unload HKLM\TEST >>%LogPath% 2>&1

::::	2017/4/25
::::	Instead of FIVT to check OS Drive freespace for meet OPD
::::	Due to 32G will reduce the OS drive size after apply single-instance then can meet the OPD spec
::::
::::	2019/1/10
::::	Skip to pop up warning meesage for OSDriveFreeSpaceLSS16.tag
::::
if not exist C:\OEM\NAPP\D2D.tag (
	ECHO !DATE! !TIME![Log TRACE]  D2D.tag not found >>%LogPath%
	ECHO !DATE! !TIME![Log TRACE]  cscript /nologo _CreateSmallStorageTag.vbs>>%LogPath%
	cscript /nologo _CreateSmallStorageTag.vbs>>%LogPath% 2>&1
	if exist .\StorageSmallThen32G.tag (
		ECHO !DATE! !TIME![Log TRACE]  This is small storage sku, cscript /nologo _CheckingOSDriveFreeSpaceNoMsg.vbs>>%LogPath%
		cscript /nologo _CheckingOSDriveFreeSpaceNoMsg.vbs>>%LogPath%
	) else (
		ECHO !DATE! !TIME![Log TRACE]  This is not small storage sku, cscript /nologo _CheckingOSDriveFreeSpace.vbs>>%LogPath%
		cscript /nologo _CheckingOSDriveFreeSpace.vbs>>%LogPath%
		if exist c:\oem\preload\OSDriveFreeSpaceLSS16.tag (
			ECHO !DATE! !TIME![Log TRACE]  c:\oem\preload\OSDriveFreeSpaceLSS16.tag found, call CheckFreeSpaceTag.cmd >>%LogPath%
			call CheckFreeSpaceTag.cmd
		)
	)
) else (
	ECHO !DATE! !TIME![Log TRACE]  D2D.tag found, skip checking OS Drive Free Space. >>%LogPath%
)
echo [%DATE% %TIME%] bcdedit /timeout 30 >> %LogPath% 2>&1
bcdedit /timeout 30 >> %LogPath% 2>&1
::::
:::: 2019/2/27 Zip Acerlogs Folder to save storage space for 32G eMMC sku
::::
SET OSCPU=x86
ECHO %DATE% %TIME%[Log TRACE]  Find /i "CPU=X64" C:\OEM\PRELOAD\command\POP*.ini>>%LogPath%
Find /i "CPU=X64" C:\OEM\PRELOAD\command\POP*.ini>>%LogPath% 2>&1 && SET OSCPU=amd64
ECHO %DATE% %TIME%[Log TRACE]  Find /i "CPU=ARM64" C:\OEM\PRELOAD\command\POP*.ini>>%LogPath%
Find /i "CPU=ARM64" C:\OEM\PRELOAD\command\POP*.ini>>%LogPath% 2>&1 && SET OSCPU=ARM64
ECHO !DATE! !TIME![Log TRACE]  C:\OEM\Preload\utility\7za\%OSCPU%\7za.exe a C:\OEM\Acerlogs.zip c:\oem\acerlogs -pAcer >>%LogPath% 2>&1
C:\OEM\Preload\utility\7za\%OSCPU%\7za.exe a C:\OEM\Acerlogs.zip c:\oem\acerlogs -pAcer >>%LogPath% 2>&1
ECHO !DATE! !TIME![Log TRACE]  copy /y C:\OEM\Acerlogs.zip C:\Recovery\OEM\ >>%LogPath% 2>&1
copy /y C:\OEM\Acerlogs.zip C:\Recovery\OEM\ >>%LogPath% 2>&1
ECHO !DATE! !TIME![Log TRACE]  del /f /q C:\OEM\Acerlogs.zip >>%LogPath% 2>&1
del /f /q C:\OEM\Acerlogs.zip >>%LogPath% 2>&1
ECHO !DATE! !TIME![Log TRACE]  rd /s /q c:\oem\acerlogs >>%LogPath% 2>&1
rd /s /q c:\oem\acerlogs >>%LogPath% 2>&1

ECHO !DATE! !TIME![Log TRACE]  call NAPP4P_Finalize_Cleanup.cmd >>%LogPath% 2>&1
call NAPP4P_Finalize_Cleanup.cmd >>%LogPath% 2>&1

ECHO !DATE! !TIME![Log TRACE]  md c:\oem\Acerlogs >>%LogPath% 2>&1
md c:\oem\Acerlogs >>%LogPath% 2>&1
ECHO !DATE! !TIME![Log TRACE]  copy %LogPath% c:\oem\Acerlogs >>%LogPath% 2>&1
copy %LogPath% c:\oem\Acerlogs >>%LogPath% 2>&1

SET LogPath=%@DST%\OEM\AcerLogs\NAPP4P.log
if exist C:\OEM\NAPP\D2D.tag (
	ECHO !DATE! !TIME![Log TRACE]  D2D.tag found, not NAPP flow, reboot to OOBE. >> %LogPath%
	wpeutil reboot >> %LogPath% 2>&1
) else if exist C:\OEM\Factory\Factory.cmd (
	ECHO !DATE! !TIME![Log TRACE]  Exist C:\OEM\Factory\Factory.cmd, call C:\OEM\Factory\Factory.cmd. >> %LogPath%
	Call C:\OEM\Factory\Factory.cmd >> %LogPath% 2>&1
	ECHO !DATE! !TIME![Log TRACE]  Completed C:\OEM\Factory\Factory.cmd. >> %LogPath%
) else (
	ECHO !DATE! !TIME![Log TRACE]  Not exist C:\OEM\Factory\Factory.cmd, reboot to OOBE. >> %LogPath%
	wpeutil reboot >> %LogPath% 2>&1
)


popd
ECHO %DATE% %TIME%[Log LEAVE]  ============ [NAPP]%~dpnx0 ============ >> %LogPath%
Echo.>>%LogPath%
Echo.>>%LogPath%