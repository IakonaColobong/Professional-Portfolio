
@Echo off
SET LogPath=C:\OEM\AcerLogs\%1.log
ECHO.>>%LogPath%
ECHO %DATE% %TIME%[Log START]  ============ %~dpnx0 ============ >> %LogPath%
ECHO %DATE% %TIME%[Log TRACE]  Enable Delayed environment variable >> %LogPath%
SETLOCAL ENABLEDELAYEDEXPANSION
pushd "%~dp0"


SET Reg_Prefix=HKLM\SOFTWARE
SET RefPreloadFile=C:\OEM\Preload\Command\POP*.ini
SET GCMReadinessReg=\OEM\GCMReadiness
SET GCMReg=\OEM\Metadata\GCM
SET GCMReg_X64=\Wow6432Node\OEM\Metadata\GCM
SET APBundlePolicy=C:\OEM\PRELOAD\command\APBundlePolicy.xml

ECHO %DATE% %TIME%[Log TRACE]  call :%1 >>%LogPath%
call :%1


:END
popd
ECHO %DATE% %TIME%[Log TRACE]  Disable Delayed environment variable >> %LogPath%
SETLOCAL DISABLEDELAYEDEXPANSION
ECHO %DATE% %TIME%[Log LEAVE]  ============ %~dpnx0 ============ >> %LogPath%
ECHO.>>%LogPath%
exit /b 0




:SCD_WinPE
::::	2019/4/18
::::		Changed the setting same as Useralaunch, the LPCD/Softload is be known
::::		Due to some application request to pin in favorite bar and need set before specialize.
::::	2016/5/3
::::		1) For Offline-RCD only, for NotificationArea setting.
::::		2) Registry status same as AuditAlaunch, All SW should installed on Useralaunch
::::	2016/5/13
::::	PAP.ini will be copied to C:\OEM\Preload\Command\PAP after SCD_WinPE module execute finish
SET SCDPatchTools=C:\TempHidden\SCD\Patch\Tools
IF EXIST M:\D2D_WIN10\SCD\Patch\Tools\PreloadPN\PAP (
	ECHO !DATE! !TIME![Log TRACE]  SET SCDPatchTools=M:\D2D_WIN10\SCD\Patch\Tools >>%LogPath% 2>&1
	SET SCDPatchTools=M:\D2D_WIN10\SCD\Patch\Tools
)
	
SET RefPreloadFile=%SCDPatchTools%\PreloadPN\PAP\PAP*.ini
SET APBundlePolicy=%SCDPatchTools%\APBundlePolicy.xml
SET DISMPath=DISM /Image:C:\

::::	2019/5/14
::::	Cannot call DISM command when OS hive is mounting or caused DISM error 32
::::	----------------------------------------------------
::::	
::::	Error: 32
::::	
::::	An initialization error occurred. 
::::	For more information, review the log file.
::::	An error occurred closing a servicing component in the image. 
::::	Wait a few minutes and try running the command again.
::::	
::::	----------------------------------------------------
ECHO %DATE% %TIME%[Log TRACE]  call :DismGetIntl for getting current installed language's list >>%LogPath%
call :DismGetIntl

ECHO %DATE% %TIME%[Log TRACE]  SET GCMReadiness registry for current Hive. call :InitialGCM >>%LogPath%
call :InitialGCM
ECHO %DATE% %TIME%[Log TRACE]  SET GCMReadiness [OL] and [IR] registry for current Hive. call :InitialGCM3 >>%LogPath%
call :InitialGCM3
ECHO %DATE% %TIME%[Log TRACE]  call :QueryGCMReg to log current hive >>%LogPath%
call :QueryGCMReg


:::: for Offline hive
SET Reg_Prefix=HKLM\TempHive
ECHO %DATE% %TIME%[Log TRACE]  REG Load %Reg_Prefix% C:\Windows\system32\config\software >>%LogPath% 2>&1
REG Load %Reg_Prefix% C:\Windows\system32\config\software >>%LogPath% 2>&1
ECHO %DATE% %TIME%[Log TRACE]  GCM Readiness key and set the value as empty, REG Import NGCM_Default_Offline.reg >>%LogPath% 2>&1
REG Import NGCM_Default_Offline.reg >>%LogPath% 2>&1
ECHO %DATE% %TIME%[Log TRACE]  SET GCMReadiness registry for Offline Hive. call :InitialGCM >>%LogPath%
call :InitialGCM
ECHO %DATE% %TIME%[Log TRACE]  SET GCMReadiness [OL] and [IR] registry for Offline Hive. call :InitialGCM3 >>%LogPath%
call :InitialGCM3
ECHO %DATE% %TIME%[Log TRACE]  call :QueryGCMReg to log Offline hive >>%LogPath%
call :QueryGCMReg
ECHO %DATE% %TIME%[Log TRACE]  REG Unload %Reg_Prefix% >>%LogPath% 2>&1
REG Unload %Reg_Prefix% >>%LogPath% 2>&1
exit /b 0


:AuditAlaunch
IF /I EXIST C:\OEM\PRELOAD\command\PAP\*.* ECHO %DATE% %TIME%[Log TRACE]  PAP folder found, exit /b 0 >>%LogPath% && exit /b 0
ECHO %DATE% %TIME%[Log TRACE]  GCM Readiness key and set the value as empty, Regedit /s NGCM_Default.reg. >> %LogPath%
REG Import NGCM_Default.reg >> %LogPath% 2>&1
call :InitialGCM
timeout /t 3 /nobreak
exit /b 0



:BeforeOOBE
ECHO %DATE% %TIME%[Log TRACE]  call :QueryGCMReg for backup log before set registry >>%LogPath%
call :QueryGCMReg
exit /b 0


:Useralaunch
call :InitialGCM2
timeout /t 3 /nobreak
exit /b 0



:FirstBoot
IF /I NOT EXIST C:\OEM\PRELOAD\command\PAP\*.* ECHO %DATE% %TIME%[Log TRACE]  Not found PAP folder, exit /b 0 >>%LogPath% && exit /b 0
REM ----------------- SET UserLocale -----------------
ECHO %DATE% %TIME%[Log TRACE]  ----------------- SET UserLocale ----------------- >>%LogPath%
ECHO %DATE% %TIME%[Log TRACE]  reg query "HKCU\Control Panel\International" /v LocaleName >> %LogPath%
reg query "HKCU\Control Panel\International" /v LocaleName >> %LogPath% 2>&1
FOR /F "skip=2 tokens=3" %%P in ('reg query "HKCU\Control Panel\International" /v LocaleName') do (
	ECHO %DATE% %TIME%[Log TRACE]  SET UserLocale=[%%P]>>%LogPath%
	SET UserLocale=%%P
)

call :Set_GCMReadinessReg UL REG_SZ "%UserLocale%"
exit /b 0



:InitialGCM
:::: ----------------- [AuditAlaunch] SET MRDVersion / MRDPAGE-id / FormFactor -----------------
:::: __ReadGCMXmlToWriteReg.vbs must execute before set OSSKU registry
ECHO. >> %LogPath%
ECHO %DATE% %TIME%[Log TRACE]  ----------------- [A] SET MRDVersion / MRDPAGE-id / FormFactor ----------------- >>%LogPath%
ECHO %DATE% %TIME%[Log TRACE]  CScript /nologo __ReadGCMXmlToWriteReg.vbs %Reg_Prefix% "%APBundlePolicy%" >> %LogPath% 2>&1
CScript /nologo __ReadGCMXmlToWriteReg.vbs %Reg_Prefix% "%APBundlePolicy%" >> %LogPath% 2>&1
ECHO. >> %LogPath%



:::: ----------------- SET OS Version -----------------
::::	2016/5/3
::::		Remove detection, always set OSVersion as Windows 10
ECHO %DATE% %TIME%[Log TRACE]  ----------------- SET OS Version ----------------- >> %LogPath%
SET OSVersion=Windows 10
ECHO %DATE% %TIME%[Log TRACE]  OSVersion=[%OSVersion%] >>%LogPath%
ECHO. >> %LogPath%



:::: ----------------- SET Brand -----------------
ECHO %DATE% %TIME%[Log TRACE]  ----------------- SET Brand ----------------- >> %LogPath%
ECHO %DATE% %TIME%[Log TRACE]  Find /I "Brand=" %RefPreloadFile% >> %LogPath% 2>&1
Find /I "Brand=" %RefPreloadFile% >> %LogPath% 2>&1
For /f "skip=2 tokens=2 delims==" %%A in ('Find /I "Brand=" %RefPreloadFile%') do (
	SET Brand=%%A
	if "%%A" equ "ACER" SET Brand=Acer
	if "%%A" equ "GATEWAY" SET Brand=Gateway
	if "%%A" equ "PACKARD BELL" SET Brand=Packard Bell
)
ECHO %DATE% %TIME%[Log TRACE]  Brand=[%Brand%] >>%LogPath%
ECHO. >> %LogPath%


:::: ----------------- SET RCD Base -----------------
::::	2016/5/3
::::		Offline-RCD without Brand/LOB info in the POP*.ini, set those data by PAP file.
ECHO %DATE% %TIME%[Log TRACE]  ----------------- SET RCD Base ----------------- >> %LogPath%
SET POPFileName=
ECHO %DATE% %TIME%[Log TRACE]  Get the POP.ini file Name. >> %LogPath%
ECHO %DATE% %TIME%[Log TRACE]  DIR /b C:\OEM\Preload\Command\POP*.INI>> %LogPath%
DIR /b C:\OEM\Preload\Command\POP*.INI>> %LogPath% 2>&1
FOR /F "tokens=1 delims=." %%F in ('DIR /b C:\OEM\Preload\Command\POP*.INI') do (
	SET POPFileName=%%~nF
	goto GetBaseRCD
)
:GetBaseRCD
ECHO %DATE% %TIME%[Log TRACE]  Got POP File Name is [%POPFileName%]>>%LogPath%
SET RCDBase=%POPFileName:~10,2%
ECHO %DATE% %TIME%[Log TRACE]  RCD Base GAIA code is [%RCDBase%]>>%LogPath%
ECHO. >> %LogPath%


:::: ----------------- SET IR by RCD Base -----------------
ECHO %DATE% %TIME%[Log TRACE]  ----------------- SET IR by RCD Base ----------------- >>%LogPath%
ECHO %DATE% %TIME%[Log TRACE]  FIND /I "%RCDBase%=" BaseImageRegionsMapping.ini >> %LogPath% 2>&1
FIND /I "%RCDBase%=" BaseImageRegionsMapping.ini >> %LogPath% 2>&1
FOR /F "Skip=2 Tokens=2 Delims==" %%R in ('FIND /I "%RCDBase%=" BaseImageRegionsMapping.ini') DO SET BaseImageRegions=%%R
ECHO %DATE% %TIME%[Log TRACE]  %RCDBase% Regions is [%BaseImageRegions%] >> %LogPath%



call :Set_GCMReadinessReg OSSKU REG_SZ "%OSVersion%"
call :Set_GCMReadinessReg Brand REG_SZ "%Brand%"
call :Set_GCMReadinessReg RCDBase REG_SZ "%RCDBase%"
call :Set_GCMReadinessReg IR REG_SZ "%BaseImageRegions%"
call :Set_GCM_Metadata OS REG_SZ "%OSVersion%"
call :Set_GCM_Metadata Brand REG_SZ "%Brand%"
exit /b 0



:InitialGCM2
REM ----------------- [Useralaunch] SET MRDVersion / MRDPAGE-id / FormFactor -----------------
ECHO. >> %LogPath%
ECHO %DATE% %TIME%[Log TRACE]  ----------------- [U] SET MRDVersion / MRDPAGE-id / FormFactor ----------------- >>%LogPath%
ECHO %DATE% %TIME%[Log TRACE]  Backup GCMReadiness registry to GCMReadiness_Backup.reg first. >>%LogPath%
REG EXPORT HKLM\SOFTWARE\OEM\GCMReadiness .\GCMReadiness_Backup.reg /y >> %LogPath% 2>&1
ECHO %DATE% %TIME%[Log TRACE]  CScript /nologo __ReadGCMXmlToWriteReg.vbs %Reg_Prefix% "C:\OEM\PRELOAD\command\APBundlePolicy.xml" >> %LogPath% 2>&1
CScript /nologo __ReadGCMXmlToWriteReg.vbs %Reg_Prefix% "C:\OEM\PRELOAD\command\APBundlePolicy.xml" >> %LogPath% 2>&1
ECHO. >> %LogPath%

REM ----------------- SET Project Code -----------------
ECHO %DATE% %TIME%[Log TRACE]  ----------------- SET Project Code ----------------- >>%LogPath%
SET POPPath=C:\oem\preload\command\POP*.ini
SET PAPPath=C:\OEM\Preload\Command\PAP\PAP*.ini
ECHO %DATE% %TIME%[Log TRACE]  Checking if CPP-RCD >>%LogPath%
SET IsCPPRCD=FALSE
ECHO %DATE% %TIME%[Log TRACE]  FIND /I "CPP-RCD=Y" c:\oem\preload\command\POP*.ini>>%LogPath% 2>&1
FIND /I "CPP-RCD=Y" c:\oem\preload\command\POP*.ini>>%LogPath% 2>&1
IF %ERRORLEVEL% EQU 0 ECHO %DATE% %TIME%[Log TRACE]  SET IsCPPRCD=TRUE>>%LogPath% && SET IsCPPRCD=TRUE
FOR /F "skip=2 tokens=2 delims==" %%J in ('FIND /I "ProjectCode=" %POPPath%') do ECHO %DATE% %TIME%[Log TRACE]  POPPrj is [%%J]>>%LogPath% && SET POPPrj=%%J
FOR /F "skip=2 tokens=2 delims==" %%J in ('FIND /I "ProjectCode=" %PAPPath%') do ECHO %DATE% %TIME%[Log TRACE]  PAPPrj is [%%J]>>%LogPath% && SET PAPPrj=%%J
IF /I "%PAPPrj%" EQU "" (
	SET ProjectName=%POPPrj%
) ELSE (
	IF /I "%IsCPPRCD%" EQU "TRUE" (
		SET ProjectName=%PAPPrj%
	) ELSE (
		SET ProjectName=%POPPrj%
	)
)
ECHO %DATE% %TIME%[Log TRACE]  GOT ProjectCode is [%ProjectName%]>>%LogPath%
ECHO. >> %LogPath%


REM ----------------- SET LPCDList -----------------
ECHO %DATE% %TIME%[Log TRACE]  ----------------- SET LPCDList ----------------- >>%LogPath%
SET LPCDList=
ECHO %DATE% %TIME%[Log TRACE]  dir /b C:\OEM\Preload\Command\PAP\PXP*.INI >> %LogPath%
dir /b C:\OEM\Preload\Command\PAP\PXP*.INI >> %LogPath% 2>&1
ECHO. >>%LogPath%
FOR /F "delims=" %%L IN ('dir /b C:\OEM\Preload\Command\PAP\PXP*.INI') DO (
	PUSHD C:\OEM\Preload\Command\PAP
	ECHO !DATE! !TIME![Log TRACE]  FIND /I "SWBOM Language=" %%L >> %LogPath%
	FIND /I "SWBOM Language=" %%L >> %LogPath% 2>&1
	ECHO. >>%LogPath%
	FOR /F "skip=2 tokens=2 delims==" %%C IN ('FIND /I "SWBOM Language=" %%L') DO (
		SET LPCDList=!LPCDList!,%%C
	)
	POPD
)
SET LPCDList=%LPCDList:~1%
ECHO %DATE% %TIME%[Log TRACE]  Got LPCD List is [%LPCDList%]>> %LogPath%
ECHO. >> %LogPath%


REM ----------------- SET Model Name -----------------
ECHO %DATE% %TIME%[Log TRACE]  ----------------- SET Model Name ----------------- >>%LogPath%
ECHO %DATE% %TIME%[Log TRACE]  Cscript.exe /nologo __WriteGCMModel.vbs %Reg_Prefix% >> %LogPath% 2>&1
Cscript.exe /nologo __WriteGCMModel.vbs %Reg_Prefix% >> %LogPath% 2>&1
ECHO. >> %LogPath%

call :Set_GCM_Metadata LPCD REG_SZ "%LPCDList%"
call :Set_GCM_Metadata Project REG_SZ "%ProjectName%"
call :Set_GCM_Metadata Language REG_SZ ""
call :Set_GCM_Metadata Region REG_SZ ""
exit /b 0




:DismGetIntl
ECHO %DATE% %TIME%[Log TRACE]  %DISMPath% /get-intl /english > Dism_GetIntl.log
%DISMPath% /get-intl /english > Dism_GetIntl.log
ECHO.>>%LogPath%
type Dism_GetIntl.log >>%LogPath%
ECHO.>>%LogPath%
exit /b 0




:InitialGCM3
:::: ----------------- SET OS UI Language -----------------
ECHO %DATE% %TIME%[Log TRACE]  ----------------- SET OS UI Language ----------------- >> %LogPath%
SET OSLangList=
REM **************************************************************
REM *
REM * 	find /i "Installed language(s):" Dism_GetIntl.log
REM *
REM * 	---------- DISM_GETINTL.LOG
REM * 	Installed language(s): ja-JP
REM * 	Installed language(s): ko-KR
REM * 	Installed language(s): zh-CN
REM *	Installed language(s): zh-TW
REM *
REM **************************************************************
ECHO %DATE% %TIME%[Log TRACE]  FIND /I "Installed language(s):" Dism_GetIntl.log >> %LogPath%
FIND /I "Installed language(s):" Dism_GetIntl.log >> %LogPath% 2>&1
ECHO ******************************************* >> %LogPath%
For /f "skip=2 tokens=3 delims=: " %%L in ('FIND /I "Installed language(s):" Dism_GetIntl.log') do (
	ECHO !DATE! !TIME![Log TRACE]  Now processing [%%L].... SET TEMPL=[%%L] >> %LogPath%
	SET TEMPL=%%L
	ECHO !DATE! !TIME![Log TRACE]  FIND /I "%%L=" OLCompatibleMapping.ini >>%LogPath%
	FIND /I "%%L=" OLCompatibleMapping.ini >>%LogPath% 2>&1
	ECHO !DATE! !TIME![Log TRACE]  Before OLCompatibleMapping, TEMPL is [!TEMPL!] >>%LogPath%
	For /f "skip=2 tokens=2 delims==" %%A in ('FIND /I "%%L=" OLCompatibleMapping.ini') do SET TEMPL=%%A
	ECHO !DATE! !TIME![Log TRACE]  After OLCompatibleMapping, TEMPL is [!TEMPL!] >>%LogPath%
	SET OSLangList=!OSLangList!,!TEMPL!
	ECHO !DATE! !TIME![Log TRACE]  OSLangList is [!OSLangList!] >>%LogPath%
	SET TEMPL=""
)
SET OSLangList=%OSLangList:~1%
ECHO %DATE% %TIME%[Log TRACE]  Got OS UI Language List = [%OSLangList%] >> %LogPath%
ECHO. >> %LogPath%

:::: ----------------- SET ImageRegion -----------------
ECHO %DATE% %TIME%[Log TRACE]  ----------------- SET ImageRegion ----------------- >>%LogPath%
SET ImageRegion=
:::: 2016/4/6
::::	GCM Spec changed, XML will show "DEDE and FRFR" instead of "DE and FR"
SET MappingFile=MRDRegionMapping_New.ini
ECHO %DATE% %TIME%[Log TRACE]  Cscript /nologo __CheckGCMRegionName.vbs "C:\OEM\PRELOAD\command\APBundlePolicy.xml" DE>>%LogPath% 2>&1
Cscript /nologo __CheckGCMRegionName.vbs "C:\OEM\PRELOAD\command\APBundlePolicy.xml" DE>>%LogPath% 2>&1
if %ERRORLEVEL% EQU 9 (
	ECHO %DATE% %TIME%[Log TRACE]  SET MappingFile=MRDRegionMapping.ini >>%LogPath%
	SET MappingFile=MRDRegionMapping.ini
)

ECHO %DATE% %TIME%[Log TRACE]  DIR /b c:\OEM\Preload\Region\*.tag >>%LogPath%
DIR /b c:\OEM\Preload\Region\*.tag >>%LogPath%
ECHO. >> %LogPath%
FOR /F "tokens=1 delims=" %%R in ('DIR /b c:\OEM\Preload\Region\*.tag') do (
	REM Get the tag file name and Find GCM naming in MRDRegionMapping.ini
	ECHO !DATE! !TIME![Log TRACE]  Now Processing Region Tag File Name is [%%~nR] >>%LogPath%
	ECHO !DATE! !TIME![Log TRACE]  FIND /I "%%~nR=" %MappingFile% >>%LogPath%
	FIND /I "%%~nR=" %MappingFile% >>%LogPath% 2>&1
	For /f "skip=2 tokens=2 delims==" %%T in ('FIND /I "%%~nR=" %MappingFile%') do (
		SET ImageRegion=!ImageRegion!,%%T
		ECHO !DATE! !TIME![Log TRACE]  Get Image Region=[%%T]>>%LogPath%
	)
	ECHO ********************************************* >> %LogPath%
)
SET ImageRegion=%ImageRegion:~1%
ECHO %DATE% %TIME%[Log TRACE]  Got Image Region List = [%ImageRegion%] >> %LogPath%
ECHO. >> %LogPath%

call :Set_GCMReadinessReg OL REG_SZ "%OSLangList%"
call :Set_GCMReadinessReg IR REG_SZ "%ImageRegion%"
exit /b 0




:Set_GCMReadinessReg
ECHO. >> %LogPath%
ECHO %DATE% %TIME%[Log TRACE]  [SUB :Set_GCMReadinessReg START] >> %LogPath%
ECHO %DATE% %TIME%[Log TRACE]  reg add %Reg_Prefix%%GCMReadinessReg% /v %1 /t %2 /d "%~3" /f >> %LogPath%
reg add %Reg_Prefix%%GCMReadinessReg% /v %1 /t %2 /d "%~3" /f >> %LogPath% 2>&1
ECHO %DATE% %TIME%[Log TRACE]  [SUB :Set_GCMReadinessReg LEAVE] >> %LogPath%
ECHO. >> %LogPath%
exit /b 0


:Set_GCM_Metadata
ECHO. >> %LogPath%
ECHO %DATE% %TIME%[Log TRACE]  [SUB :Set_GCM_Metadata START] >> %LogPath%
ECHO %DATE% %TIME%[Log TRACE]  reg add %Reg_Prefix%%GCMReg% /v %1 /t %2 /d "%~3" /f >> %LogPath%
reg add %Reg_Prefix%%GCMReg% /v %1 /t %2 /d "%~3" /f >> %LogPath% 2>&1
reg add %Reg_Prefix%%GCMReg_X64% /v %1 /t %2 /d "%~3" /f >> %LogPath% 2>&1
ECHO %DATE% %TIME%[Log TRACE]  [SUB :Set_GCM_Metadata LEAVE] >> %LogPath%
ECHO. >> %LogPath%
exit /b 0


:QueryGCMReg
ECHO.>>%LogPath%
ECHO ------------------------ Region: Query GCM Registry ------------------------ >>%LogPath%
ECHO %DATE% %TIME%[Log TRACE]  REG query %Reg_Prefix%%GCMReadinessReg% /s >>%LogPath% 2>&1
REG query %Reg_Prefix%%GCMReadinessReg% /s >>%LogPath% 2>&1
ECHO %DATE% %TIME%[Log TRACE]  REG query %Reg_Prefix%%GCMReg% /s >>%LogPath% 2>&1
REG query %Reg_Prefix%%GCMReg% /s >>%LogPath% 2>&1
ECHO ------------------------ Region: Query GCM Registry ------------------------ >>%LogPath%
ECHO.>>%LogPath%
exit /b 0
