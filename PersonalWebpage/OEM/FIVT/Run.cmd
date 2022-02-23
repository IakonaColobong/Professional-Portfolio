echo. >> C:\OEM\AcerLogs\Useralaunch.log
echo. >> C:\OEM\AcerLogs\Useralaunch.log
pushd "%~dp0"
echo %DATE% %TIME% [Log START]  ============ %~dpnx0 ============ >> C:\OEM\AcerLogs\Useralaunch.log

if exist Reboot.tag (
	echo Already reboot once, goto check >> C:\OEM\AcerLogs\Useralaunch.log
	goto Check_Flow
)

:Clear_AlaunchX
(tasklist | find /i "AlaunchX") && (
	ECHO %DATE% %TIME% [Log TRACE]  Clear existed AlaunchX...
	tskill AlaunchX.exe /a /v || taskkill /IM AlaunchX.exe /F
	ECHO %DATE% %TIME% [Log TRACE]  goto Clear_AlaunchX
	goto Clear_AlaunchX
) >> C:\OEM\AcerLogs\Useralaunch.log 2>&1
echo.> Reboot.tag
shutdown -r -t 0
pause

:Check_Flow
SET @Flag1=CHECK
SET @Flag2=FAIL

find /i "FLOW=CD2D" C:\OEM\Preload\Command\AlaunchX\NAPP.ini >> C:\OEM\AcerLogs\Useralaunch.log 2>&1
if %errorlevel% EQU 0 (
	echo errorlevel = %errorlevel%, This is CD2D flow, no need to run FIVT Tool >> C:\OEM\AcerLogs\Useralaunch.log
	SET @Flag1=NoCHECK
)
find /i "FLOW=D2D" C:\OEM\Preload\Command\AlaunchX\NAPP.ini >> C:\OEM\AcerLogs\Useralaunch.log 2>&1
if %errorlevel% EQU 0 (
	echo errorlevel = %errorlevel%, This is D2D flow, no need to run FIVT Tool >> C:\OEM\AcerLogs\Useralaunch.log
	SET @Flag1=NoCHECK
)
if %@Flag1% EQU CHECK (
	echo Flag1 = %@Flag1%, Not D2D or CD2D flow, run FIVT Tool >> C:\OEM\AcerLogs\Useralaunch.log
	call :Run
)

echo %DATE% %TIME% [Log LEAVE]  ============ %~dpnx0 ============ >> C:\OEM\AcerLogs\Useralaunch.log
echo. >> C:\OEM\AcerLogs\Useralaunch.log
echo. >> C:\OEM\AcerLogs\Useralaunch.log

exit /b 0

:Run
cmd /c FIVT.exe /factory
call :Check 
exit /b 0

:Check
if exist C:\OEM\FIVT\Pass.tag set @Flag2=PASS
if %@Flag2% EQU PASS  (
	Echo The result of FIVT tool is PASS. Continue AlaunchX >> C:\OEM\AcerLogs\Useralaunch.log 2>&1
	attrib -h -s -r C:\OEM\FIVT\*.dll /s 
	del C:\OEM\FIVT\*.dll /s /q >> C:\OEM\AcerLogs\Useralaunch.log 2>&1
	attrib -h -s -r C:\OEM\FIVT\*.exe /s
	del C:\OEM\FIVT\*.exe /s /q >> C:\OEM\AcerLogs\Useralaunch.log 2>&1
	attrib -h -s -r C:\OEM\FIVT\*.wtl /s
	del C:\OEM\FIVT\*.wtl /s /q >> C:\OEM\AcerLogs\Useralaunch.log 2>&1
	attrib -h -s -r C:\OEM\FIVT\*.dat /s
	del C:\OEM\FIVT\*.dat /s /q >> C:\OEM\AcerLogs\Useralaunch.log 2>&1
) else (
	Echo The result of FIVT tool is Fail. Terminate AlaunchX >> C:\OEM\AcerLogs\Useralaunch.log 2>&1
	Taskkill /f /IM AlaunchX.exe /t
)
exit /b 0