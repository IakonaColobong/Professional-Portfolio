
@echo off
SET LogPath=C:\OEM\AcerLogs\SCD_WinPE.log
ECHO.>>%LogPath%
ECHO.>>%LogPath%
ECHO %DATE% %TIME%[Log START]  ============ %~dpnx0 ============ >> %LogPath%

if not exist c:\OEM\Preload\Region mkdir c:\OEM\Preload\Region
if exist c:\OEM\Preload\Region\*.tag del /f /q c:\OEM\Preload\Region\*.tag

pushd c:\OEM\Preload\Region

ECHO %DATE% %TIME%[Log TRACE]  Checking Base Image >> %LogPath%
ECHO %DATE% %TIME%[Log TRACE]  find /I "LanguageFullName=Multi- PA Base" c:\oem\preload\command\POP*.ini >> %LogPath%
find /I "LanguageFullName=Multi- PA Base" c:\oem\preload\command\POP*.ini >> %LogPath% 2>&1
if /I "%ERRORLEVEL%" EQU "0" (
	ECHO %DATE% %TIME%[Log TRACE]  PA base found. call :PABase >> %LogPath%
	call :PABase
	ECHO %DATE% %TIME%[Log TRACE]  goto :DONE >> %LogPath%
	goto :DONE
)

ECHO %DATE% %TIME%[Log TRACE]  Checking Base Image >> %LogPath%
ECHO %DATE% %TIME%[Log TRACE]  find /I "LanguageFullName=Multi- AAP Base" c:\oem\preload\command\POP*.ini >> %LogPath%
find /I "LanguageFullName=Multi- AAP Base" c:\oem\preload\command\POP*.ini >> %LogPath% 2>&1
if /I "%ERRORLEVEL%" EQU "0" (
	ECHO %DATE% %TIME%[Log TRACE]  AAP base found. call :AAPBase >> %LogPath%
	call :AAPBase
	ECHO %DATE% %TIME%[Log TRACE]  goto :DONE >> %LogPath%
	goto :DONE
)

ECHO %DATE% %TIME%[Log TRACE]  Checking Base Image >> %LogPath%
ECHO %DATE% %TIME%[Log TRACE]  find /I "LanguageFullName=Multi- EMEA Base" c:\oem\preload\command\POP*.ini >> %LogPath%
find /I "LanguageFullName=Multi- EMEA Base" c:\oem\preload\command\POP*.ini >> %LogPath% 2>&1
if /I "%ERRORLEVEL%" EQU "0" (
	ECHO %DATE% %TIME%[Log TRACE]  EMEA base found. call :EMEABase >> %LogPath%
	call :EMEABase
	ECHO %DATE% %TIME%[Log TRACE]  goto :DONE >> %LogPath%
	goto :DONE
)

ECHO %DATE% %TIME%[Log TRACE]  Checking Base Image >> %LogPath%
ECHO %DATE% %TIME%[Log TRACE]  find /I "LanguageFullName=Multi- GC Base" c:\oem\preload\command\POP*.ini >> %LogPath%
find /I "LanguageFullName=Multi- GC Base" c:\oem\preload\command\POP*.ini >> %LogPath% 2>&1
if /I "%ERRORLEVEL%" EQU "0" (
	ECHO %DATE% %TIME%[Log TRACE]  GC base found. call :GCBase >> %LogPath%
	call :GCBase
	ECHO %DATE% %TIME%[Log TRACE]  goto :DONE >> %LogPath%
	goto :DONE
)

ECHO %DATE% %TIME%[Log TRACE]  Checking Base Image >> %LogPath%
ECHO %DATE% %TIME%[Log TRACE]  find /I "LanguageFullName=Multi- Japan Base" c:\oem\preload\command\POP*.ini >> %LogPath%
find /I "LanguageFullName=Multi- Japan Base" c:\oem\preload\command\POP*.ini >> %LogPath% 2>&1
if /I "%ERRORLEVEL%" EQU "0" (
	ECHO %DATE% %TIME%[Log TRACE]  JA base found. call :JABase >> %LogPath%
	call :JABase
	ECHO %DATE% %TIME%[Log TRACE]  goto :DONE >> %LogPath%
	goto :DONE
)

ECHO %DATE% %TIME%[Log TRACE]  Checking Base Image >> %LogPath%
ECHO %DATE% %TIME%[Log TRACE]  find /I "LanguageFullName=Multi- Korean Base" c:\oem\preload\command\POP*.ini >> %LogPath%
find /I "LanguageFullName=Multi- Korean Base" c:\oem\preload\command\POP*.ini >> %LogPath% 2>&1
if /I "%ERRORLEVEL%" EQU "0" (
	ECHO %DATE% %TIME%[Log TRACE]  KO base found. call :KOBase >> %LogPath%
	call :KOBase
	ECHO %DATE% %TIME%[Log TRACE]  goto :DONE >> %LogPath%
	goto :DONE
)

:DONE
popd
ECHO %DATE% %TIME%[Log LEAVE]  ============ [SUB]%~dpnx0 ============ >> %LogPath%
ECHO.>>%LogPath%
exit /b 0
















:PABase
ECHO %DATE% %TIME%[Log TRACE]  It is PA Base >> %LogPath%
call :chkLP Canada.tag E1 F1
call :chkLP USA.tag    E0
call :chkNoTag LatAM.tag
exit /b 0

:AAPBase
ECHO %DATE% %TIME%[Log TRACE]  It is AAP Base  >> %LogPath%
call :chkLP Taiwan.tag S7
call :chkLP TW_rule1.tag TC
if exist TW_rule1.tag (
	ECHO %DATE% %TIME%[Log TRACE]  TW_rule1.tag found, Fulfill TW rule1 >> %LogPath%
	call :chkLP TW_rule2.tag S4
	if exist TW_rule2.tag (
		ECHO %DATE% %TIME%[Log TRACE]  TW_rule2.tag found, Not fulfill TW rule2 >> %LogPath%
	) else (
		ECHO %DATE% %TIME%[Log TRACE]  Fulfill TW rule2, generate Taiwan.tag >> %LogPath%
		Echo Taiwan > Taiwan.tag
	)
	del /f /q TW_rule*.tag
)
call :chkLP Australia.tag AU
call :chkNoTag AAP.tag
exit /b 0

:EMEABase
ECHO %DATE% %TIME%[Log TRACE]  It is EMEA Base  >> %LogPath%
call :chkLP Germany.tag  D0
call :chkLP France.tag   F0
call :chkLP Russia.tag   R0
call :chkLP UKGB.tag     E2
call :chkLP Nordic.tag   DA NO SV FI
rem call :chkLP WEU_rule1.tag DE FR IT NO ES PT
rem if exist WEU_rule1.tag (
rem 	Echo Fulfill WEU rule1 >> %LogPath%
rem 	call :chkLP WEU_rule2.tag AR E3 HR TR SL SK CS HU EL HE U5
rem 	if exist WEU_rule2.tag (
rem 		Echo Not fulfill WEU rule2 >> %LogPath%
rem 		del /f /q WEU_rule*.tag
rem 	) else (
rem 		Echo Fulfill WEU rule2 >> %LogPath%
rem 		del /f /q WEU_rule*.tag
rem 		Echo Western Europe > WEU.tag
rem 	)
rem )
call :chkNoTag RestEU.tag
exit /b 0

:GCBase
ECHO %DATE% %TIME%[Log TRACE]  It is GC Base  >> %LogPath%
call :chkNoTag China.tag
exit /b 0

:JABase
ECHO %DATE% %TIME%[Log TRACE]  It is JA Base  >> %LogPath%
call :chkLP Japan.tag JA
exit /b 0

:KOBase
ECHO %DATE% %TIME%[Log TRACE]  It is KO Base  >> %LogPath%
call :chkLP Korean.tag KO
exit /b 0


:chkLP
ECHO %DATE% %TIME%[Log TRACE]  [Sub:chkLP] %* >> %LogPath%
for /F "tokens=1 delims= " %%L IN ("%*") DO (
	ECHO %DATE% %TIME%[Log TRACE]  arg1=%%L, set TagName=%%L >> %LogPath%
	set TagName=%%L
)
for /F "tokens=1,* delims= " %%P IN ("%*") DO (
	ECHO %DATE% %TIME%[Log TRACE]  arg2=%%Q, call :chkLP_each %%Q >> %LogPath%
	call :chkLP_each %%Q
)
exit /b 0


:chkLP_each
ECHO %DATE% %TIME%[Log TRACE]  [Sub:chkLP_each] %* >> %LogPath%
ECHO %DATE% %TIME%[Log TRACE]  TagName=%TagName% >> %LogPath%
for %%L IN (%*) DO (
	ECHO %DATE% %TIME%[Log TRACE]  call :chkLP_PXP %TagName% %%L >> %LogPath%
	call :chkLP_PXP %TagName% %%L
)
exit /b 0



:chkNoTag
if not exist *.tag (
	ECHO %DATE% %TIME%[Log TRACE]  No existed tag, generate %1 >> %LogPath%
	Echo %1 > %1
)
exit /b 0


:chkLP_PXP
ECHO %DATE% %TIME%[Log TRACE]  [Sub:chkLP_PXP] %1 %2 >> %LogPath%
ECHO %DATE% %TIME%[Log TRACE]  Checking PXP %2 >> %LogPath%
ECHO %DATE% %TIME%[Log TRACE]  dir /b C:\oem\Preload\Command\PAP\PXP*.INI >> %LogPath%
dir /b C:\oem\Preload\Command\PAP\PXP*.INI >> %LogPath%
if exist C:\oem\Preload\Command\PAP\PXP?????Z???%2??.INI (
	ECHO %DATE% %TIME%[Log TRACE]  C:\oem\Preload\Command\PAP\PXP?????Z???%2??.INI found, generate %1 >> %LogPath%
	Echo %1 > %1
)
exit /b 0




:EOF