@ECHO OFF
SET LogPath=C:\OEM\AcerLogs\Useralaunch.log
Echo.>>%LogPath%
ECHO %DATE% %TIME%[Log START]  ============ %~dpnx0 ============ >> %LogPath%
:START
SETLOCAL ENABLEDELAYEDEXPANSION
pushd %~dp0


::::
::::	2016/3/30 Rhea
::::  ---- Add for HPA START ----
:::: 		DT HPA image, will do system backup by HPA utility
::::		BeforeESP.bat script similar with [Sysprep in Factory]
:::: 		BeforeESP.bat will be trigger after call Autobackup.cmd in [Sysprep in Factory]
::::  ---- Add for HPA END ----
::::
:HPASolution
IF /i EXIST c:\oem\autobackup\AutoBackup.cmd (
	pushd c:\oem\autobackup
	ECHO !DATE! !TIME![Log TRACE]  call c:\oem\autobackup\AutoBackup.cmd >>%LogPath%
	call c:\oem\autobackup\AutoBackup.cmd
	popd
)
IF EXIST FactorySysprepFAIL_Rebooted.tag (
	ECHO !DATE! !TIME![Log TRACE]  FactorySysprepFAIL_Rebooted.tag found, del /f /q FactorySysprepFAIL_Rebooted.tag >>%LogPath%
	del /f /q FactorySysprepFAIL_Rebooted.tag >>%LogPath% 2>&1
	ECHO !DATE! !TIME![Log TRACE]  goto :Clear_Sysprep >>%LogPath%
	goto :Clear_Sysprep
)

call Factory_sysprep_Vars.cmd

ECHO %DATE% %TIME%[Log TRACE]  Disable prior unattend.xml >> %LogPath%
if exist c:\windows\panther\x64.xml ren c:\windows\panther\x64.xml Factory_sysprep_unattend_x64.xml
if exist c:\windows\panther\x86.xml ren c:\windows\panther\x86.xml Factory_sysprep_unattend_x86.xml


:ResetPowerShellExePolicy
Echo. >> %LogPath%
ECHO %DATE% %TIME%[Log TRACE]  Reset PowerShell Policy... >> %LogPath%
C:\windows\system32\WindowsPowerShell\v1.0\powershell.exe set-executionpolicy Restricted >> %LogPath% 2>&1
C:\windows\system32\WindowsPowerShell\v1.0\powershell.exe get-executionpolicy >> %LogPath% 2>&1

ECHO %DATE% %TIME%[Log TRACE]  copy /y .\SysprepXml\%Processor_Architecture%\%Br%\Sysprep.xml .\Sysprep.xml>>%LogPath%
copy /y .\SysprepXml\%Processor_Architecture%\%Br%\Sysprep.xml .\Sysprep.xml>>%LogPath% 2>&1
ECHO %DATE% %TIME%[Log TRACE]  call FactorySysprep_TBLayoutModification.cmd >>%LogPath%
call FactorySysprep_TBLayoutModification.cmd
ECHO %DATE% %TIME%[Log TRACE]  call FactorySysprep_LayoutModification.cmd >>%LogPath%
call FactorySysprep_LayoutModification.cmd
ECHO %DATE% %TIME%[Log TRACE]  call FactorySysprep_FirstRunTask.cmd >>%LogPath%
call FactorySysprep_FirstRunTask.cmd


:RestoreUnattendForPBR
SET RestoreSysprepPath=C:\OEM\Preload\DPOP\Sysprep\sysprep.xml
FIND /I "Offline-RCD=Y" C:\OEM\Preload\Command\POP*.ini >>%LogPath% 2>&1 && SET RestoreSysprepPath=C:\OEM\Preload\DPOP\Sysprep\OfflineRCD\%Processor_Architecture%\%Br%\Unattend.xml
ECHO %DATE% %TIME%[Log TRACE]  powershell.exe -ExecutionPolicy ByPass -command "%~dp0RestoreUnattend.ps1 \"%RestoreSysprepPath%\"" >>%LogPath% 2>&1
powershell.exe -ExecutionPolicy ByPass -command "%~dp0RestoreUnattend.ps1 \"%RestoreSysprepPath%\"" >>%LogPath% 2>&1
ECHO %DATE% %TIME%[Log TRACE]  Copy /y "%~dp0RestoreUnattend.xml" C:\Recovery\OEM\RestoreOEMCustomize\Unattend.xml >>%LogPath% 2>&1
Copy /y "%~dp0RestoreUnattend.xml" C:\Recovery\OEM\RestoreOEMCustomize\Unattend.xml >>%LogPath% 2>&1


:SETAppAsso_BeforeSysprep
call C:\OEM\Preload\DPOP\JumpStartSettings\SET_AppAsso.cmd BeforeSysprep Online


:Clear_Sysprep
(tasklist | find /i "sysprep") && (
	ECHO !DATE! !TIME![Log TRACE]  Clear existed sysprep...
	tskill sysprep.exe /a /v || taskkill /IM sysprep.exe /F
	ECHO !DATE! !TIME![Log TRACE]  goto Clear_Sysprep
	goto Clear_Sysprep
) >>%LogPath% 2>&1


:Sysprep_System
ECHO %DATE% %TIME%[Log TRACE]  Execute command: sysprep.exe /oobe /quit /quiet /unattend:%~dp0sysprep.xml >> %LogPath%
C:\windows\system32\sysprep\sysprep.exe /oobe /quit /quiet /unattend:%~dp0sysprep.xml
IF EXIST c:\windows\system32\sysprep\Sysprep_succeeded.tag (
	ECHO !DATE! !TIME![Log TRACE]  Sysprep_succeeded.tag Found! >>%LogPath%
) ELSE (
	ECHO !DATE! !TIME![Log ERROR]  ERROR! ERROR! ERROR! Sysprep_succeeded.tag not found.>>%LogPath%
)
ECHO %DATE% %TIME%[Log TRACE]  FIND /I "ImageState=" C:\Windows\Setup\State\State.ini >>%LogPath% 2>&1
FIND /I "ImageState=" C:\Windows\Setup\State\State.ini >>%LogPath% 2>&1
FOR /F "SKIP=2 TOKENS=2 DELIMS==" %%S in ('FIND /I "ImageState=" C:\Windows\Setup\State\State.ini') DO SET SetupState=%%S
ECHO %DATE% %TIME%[Log TRACE]  Got the windows Setup State is [%SetupState%] >>%LogPath% 2>&1
IF /I "%SetupState%" NEQ "IMAGE_STATE_SPECIALIZE_RESEAL_TO_OOBE" (
	ECHO !DATE! !TIME![Log ERROR]  ERROR! The Setup State not meet requirement! Reboot to retry >FactorySysprepFAIL_Rebooted.tag
	ECHO !DATE! !TIME![Log ERROR]  ERROR! The Setup State not meet requirement! Reboot to retry >>%LogPath%
	ECHO !DATE! !TIME![Log ERROR]  regedit /s C:\OEM\Preload\DPOP\OEMCustomize\LaunchFactory.reg for call Alaunchx >>%LogPath%
	regedit /s C:\OEM\Preload\DPOP\OEMCustomize\LaunchFactory.reg >>%LogPath% 2>&1
	ECHO !DATE! !TIME![Log TRACE]  acerReboot.exe with timeout 60 and Pause>>%LogPath%
	acerReboot.exe >>%LogPath%
	timeout /t 60
	pause
) ELSE (
	ECHO !DATE! !TIME![Log TRACE]  Setup State checking is PASS >>%LogPath%
)

:SETAppAsso_AfterSysprep
call C:\OEM\Preload\DPOP\JumpStartSettings\SET_AppAsso.cmd AfterSysprep Online

ECHO %DATE% %TIME%[Log TRACE]  Checking PowerShell Policy... >> %LogPath%
ECHO %DATE% %TIME%[Log TRACE]  C:\windows\system32\WindowsPowerShell\v1.0\powershell.exe get-executionpolicy >> %LogPath% 2>&1
C:\windows\system32\WindowsPowerShell\v1.0\powershell.exe get-executionpolicy >> %LogPath% 2>&1

REM ========================Added for Install Priority reversal ==============================
REM 2015/6/26
REM [USMT] and [Sysprep in Factory] install priority reversal
REM Move call UserAlaunch2nd_Finalize.cmd to [Sysprep in Factory]
if exist "C:\OEM\NAPP\UserAlaunch2nd_Finalize.cmd" (
	call C:\OEM\NAPP\UserAlaunch2nd_Finalize.cmd
)
ECHO %DATE% %TIME%[Log TRACE]  shutdown /r /t 5 >>%LogPath%
REM Shutdown.tag for tall AlaunchX do not terminate process
ECHO %DATE% %TIME%[Log TRACE]  shutdown /r /t 5 > C:\OEM\Preload\Command\AlaunchX\Shutdown.tag
shutdown /r /t 5
REM ========================Added for Install Priority reversal ==============================

:END
popd
SETLOCAL DISABLEDELAYEDEXPANSION
ECHO %DATE% %TIME%[Log LEAVE]  ============ %~dpnx0 ============ >> %LogPath%
Echo.>>%LogPath%