@echo off
SETLOCAL EnableDelayedExpansion
pushd "%~dp0"

echo.>>%LogFile%
echo %DATE% %TIME% [Log START]  ============ %~dpnx0 ============
echo %DATE% %TIME% [Log START]  ============ %~dpnx0 ============ >> %LogFile%

if exist *.tag del /s /q *.tag
if exist *.log del /s /q *.log

echo %DATE% %TIME% [Log TRACE] This is Windows7, check License Status   
echo %DATE% %TIME% [Log TRACE] This is Windows7, check License Status  >> %LogFile%

CScript.exe /nologo slmgr.vbs /dli > slmgrInfo.log

type slmgrInfo.log | find /i "License Status: Licensed"
if %errorlevel% equ 0 (
	echo !DATE! !TIME! [Log TRACE] Pass, License Status is Licensed 
	echo !DATE! !TIME! [Log TRACE] Pass, License Status is Licensed >> %LogFile%
	echo !DATE! !TIME! [Log TRACE] Pass, License Status is Licensed > Pass.tag
) else (
	echo !DATE! !TIME! [Log ERROR] Fail, License Status is not Licensed
	echo !DATE! !TIME! [Log ERROR] Fail, License Status is not Licensed >> %LogFile%
	echo !DATE! !TIME! [Log ERROR] Fail, License Status is not Licensed > Fail.tag
	type slmgrInfo.log >> Fail.tag
)
goto END

:END
echo %DATE% %TIME% [Log LEAVE]  ============ %~dpnx0 ============
echo %DATE% %TIME% [Log LEAVE]  ============ %~dpnx0 ============ >> %LogFile%
echo.>> %LogFile%
popd
SETLOCAL DisableDelayedExpansion