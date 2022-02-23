@ECHO OFF
SET LogPath=C:\OEM\AcerLogs\AuditAlaunch.log
ECHO.>>%LogPath%
ECHO %DATE% %TIME%[Log START]  ============ %~dpnx0 ============ >> %LogPath%
SETLOCAL ENABLEDELAYEDEXPANSION
Pushd "%~dp0"
:ChkPAP
IF /I EXIST C:\OEM\Preload\Command\PAP\*.* ECHO !DATE! !TIME![Log WARNING]  Useralaunch phase, DO Nothing. goto :END >>%LogPath% && goto :END

:START
FOR /F "tokens=3 delims= " %%B IN ('reg query HKLM\SOFTWARE\OEM\Metadata /v Brand ^| find /I "Brand"') DO SET Br=%%B
ECHO %DATE% %TIME%[Log TRACE]  SET Br=[%Br%] >>%LogPath%

:PREPARE_SYSPREP_FILE
ECHO %DATE% %TIME%[Log TRACE]  Prepare Sysprep.xml, copy /y .\SysprepXml\%PROCESSOR_ARCHITECTURE%\%Br%\Sysprep.xml .\Sysprep.xml >>%LogPath%
copy /y .\SysprepXml\%PROCESSOR_ARCHITECTURE%\%Br%\Sysprep.xml .\Sysprep.xml


:SET_DisableAntiSpyware
REM Add DisableAntiSpyware in sysprep.xml, if any 3rd party AV installed
REM SWOD image no need set DisableAntiSpyware
ECHO %DATE% %TIME%[Log TRACE]  [FIND] /I "\Software Assembler;" C:\OEM\Preload\Command\POP*.INI >> %LogPath% 2>&1
ECHO. >>%LogPath%
FIND /I "\Software Assembler;" C:\OEM\Preload\Command\POP*.INI >> %LogPath% 2>&1
IF /I "%ERRORLEVEL%" EQU "0" ECHO !DATE! !TIME![Log TRACE]  This is SWOD image, No need SET_DisableAntiSpyware. >>%LogPath% && goto SET_NOTIFICATION_ICONS
ECHO %DATE% %TIME%[Log TRACE]  CScript.exe /Nologo _GetAV.vbs >> %LogPath% 2>&1
CScript.exe /Nologo _GetAV.vbs >> %LogPath% 2>&1
SET AVCount=%ERRORLEVEL%
ECHO %DATE% %TIME%[Log TRACE]  [AVCount] is %AVCount%, if LSS then 2, No need SET_DisableAntiSpyware. >>%LogPath%
IF %AVCount% LSS 2 goto SET_NOTIFICATION_ICONS
:_AddSysprepXmlDisableAntiSpyware
ECHO.>>%LogPath%
ECHO %DATE% %TIME%[Log TRACE]  ----------------- [Start] SET_DisableAntiSpyware ------------------- >>%LogPath%
CScript.exe /nologo _AddSysprepXmlDisableAntiSpyware.vbs "Sysprep.xml" "true" >> %LogPath% 2>&1
ECHO.>>%LogPath%
ECHO %DATE% %TIME%[Log TRACE]  -----------------  [END] SET_DisableAntiSpyware ------------------- >>%LogPath%
ECHO.>>%LogPath%

:SET_NOTIFICATION_ICONS
ECHO %DATE% %TIME%[Log TRACE]  call Acer_sysprep_SetNotificationICON.cmd .\Sysprep.xml >>%LogPath%
call Acer_sysprep_SetNotificationICON.cmd .\Sysprep.xml


ECHO %DATE% %TIME%[Log TRACE]  Clear Acer Software Installation Command, DEL /Q c:\oem\preload\utility\Acer_Install.cmd >> %LogPath%
DEL /Q c:\oem\preload\utility\Acer_Install.cmd >> %LogPath% 2>&1


:Check_Minidump
REM 2013/11/29 Rhea
REM prevent unexcepted power shutdown caused preload process something wrong
if exist C:\Windows\Minidump\*.* (
	ECHO ^|-------   Checking Minidump   -------^| > SysprepMinidump.log
	ECHO. >>SysprepMinidump.log
	ECHO ^|------- ERROR ERROR ERROR!!!! -------^| >> SysprepMinidump.log
	ECHO ^|------- ERROR ERROR ERROR!!!! -------^| >> SysprepMinidump.log
	ECHO ^|------- ERROR ERROR ERROR!!!! -------^| >> SysprepMinidump.log
	ECHO. >>SysprepMinidump.log
	ECHO %DATE% %TIME%[Log TRACE]  Find the Minidump folder Please check if exist any unexceped power shutdown ...... >> SysprepMinidump.log
	notepad SysprepMinidump.log
)
if exist C:\windows\MEMORY.DMP (
	ECHO ^|-------   Checking MEMORY.DMP   -------^| >> SysprepMinidump.log
	ECHO. >>SysprepMinidump.log
	ECHO ^|------- ERROR ERROR ERROR!!!! -------^| >> SysprepMinidump.log
	ECHO ^|------- ERROR ERROR ERROR!!!! -------^| >> SysprepMinidump.log
	ECHO ^|------- ERROR ERROR ERROR!!!! -------^| >> SysprepMinidump.log
	ECHO. >>SysprepMinidump.log
	ECHO %DATE% %TIME%[Log TRACE]  Find the MEMORY.DMP Please check if exist any unexceped power shutdown ...... >> SysprepMinidump.log
	notepad SysprepMinidump.log
)

:DetectFirmwareInterface
ECHO %DATE% %TIME%[Log TRACE]  [Workaround for eRCD, build x86 in MBR mode] call run.cmd >>%LogPath%
call RUN.cmd >>%LogPath% 2>&1
if exist C:\OEM\Preload\BIOS_UEFI.tag goto :SYSPREP_SETUP
ECHO !DATE! !TIME![Log TRACE]  set MBR partition 2 bootable, Diskpart /s SetP2Active.txt >>%LogPath%
Diskpart /s SetP2Active.txt >>%LogPath% 2>&1
ECHO !DATE! !TIME![Log TRACE]  DEL /Q /F SetP2Active.txt >>%LogPath% 2>&1
DEL /Q /F SetP2Active.txt >>%LogPath% 2>&1

:SYSPREP_SETUP
ECHO %DATE% %TIME%[Log TRACE]  Copy ".\sysprep.xml" to ".\sysprep_done.tag" >> %LogPath%
copy /y .\sysprep.xml .\sysprep_done.tag >> %LogPath% 2>&1


tskill sysprep /a /v
taskkill /IM sysprep.exe /F
ECHO %DATE% %TIME%[Log TRACE]  DEL /Q sysprep_*.xml >>%LogPath% 2>&1
DEL /Q sysprep_*.xml >>%LogPath% 2>&1
pushd c:\Windows\System32\Sysprep
ECHO %DATE% %TIME%[Log TRACE]  sysprep.exe /oobe /generalize /quit /quiet /unattend:C:\OEM\Preload\DPOP\Sysprep\sysprep.xml >>%LogPath% 2>&1
sysprep.exe /oobe /generalize /quit /quiet /unattend:C:\OEM\Preload\DPOP\Sysprep\sysprep.xml
popd
IF EXIST c:\windows\system32\sysprep\Sysprep_succeeded.tag (
	ECHO !DATE! !TIME![Log TRACE]  Sysprep_succeeded.tag Found! >>%LogPath%
) ELSE (
	ECHO !DATE! !TIME![Log ERROR]  ERROR! ERROR! ERROR! Sysprep_succeeded.tag not found.>>%LogPath%
)
ECHO %DATE% %TIME%[Log TRACE]  Type %WINDIR%\Setup\State\State.ini >>%LogPath%
Type %WINDIR%\Setup\State\State.ini >>%LogPath%
ECHO %DATE% %TIME%[Log TRACE]  FIND /I "IMAGE_STATE_GENERALIZE_RESEAL_TO_OOBE" %WINDIR%\Setup\State\State.ini >>%LogPath% 2>&1
FIND /I "IMAGE_STATE_GENERALIZE_RESEAL_TO_OOBE" "%WINDIR%\Setup\State\State.ini" >>%LogPath% 2>&1
IF %ERRORLEVEL% NEQ 0 (
	ECHO !DATE! !TIME![Log ERROR]  ERROR! ERROR! ERROR! The State.ini checking is FAIL. >>%LogPath%
	Notepad C:\Windows\System32\sysprep\Panther\setuperr.log
) ELSE (
	ECHO !DATE! !TIME![Log TRACE]  The State.ini checking is PASS. >>%LogPath%
)


:SET_BCDBOOT
if exist C:\OEM\Preload\BIOS_UEFI.tag (
	ECHO !DATE! !TIME![Log TRACE]  set GPT d drive bootable >> %LogPath%
	ECHO !DATE! !TIME![Log TRACE]  Bcdedit /delete {current} /f >> %LogPath% 2>&1
	Bcdedit /delete {current} /f >> %LogPath% 2>&1
	ECHO !DATE! !TIME![Log TRACE]  Mount ESP drive, Mountvol S: /s >> %LogPath%
	Mountvol S: /s >> %LogPath% 2>&1
	ECHO !DATE! !TIME![Log TRACE]  Bcdboot D:\windows /s S: >> %LogPath% 2>&1
	Bcdboot D:\windows /s S: >> %LogPath% 2>&1
	ECHO !DATE! !TIME![Log TRACE]  Unmount ESP drive, Mountvol S: /d >> %LogPath%
	Mountvol S: /d >> %LogPath% 2>&1
)


:NumlockForNB
ECHO %DATE% %TIME%[Log TRACE]  call Acer_sysprep_Numlock.cmd >>%LogPath%
call Acer_sysprep_Numlock.cmd

:END
SETLOCAL DISABLEDELAYEDEXPANSION
Popd
ECHO %DATE% %TIME%[Log LEAVE]  ============ %~dpnx0 ============ >> %LogPath%
ECHO.>>%LogPath%