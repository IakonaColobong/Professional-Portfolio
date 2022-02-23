@echo off
SETLOCAL EnableDelayedExpansion
pushd "%~dp0"

set LogFile="%~dp0"CheckSLIC.log

echo.>>%LogFile%
echo %DATE% %TIME% [Log START]  ============ %~dpnx0 ============
echo %DATE% %TIME% [Log START]  ============ %~dpnx0 ============ >> %LogFile%

if exist *.tag del /s /q *.tag

if not exist "C:\OEM\Preload\Command\POP*.ini" (
	echo !DATE! !TIME! [Log TRACE] Not Acer Windows image, skip check
	echo !DATE! !TIME! [Log TRACE] Not Acer Windows image, skip check >> %LogFile%
	goto END
)

call Tools\OACHECK.cmd

if not exist Tools\OACHECK.log (
	echo !DATE! !TIME! [Log ERROR] Fail, %~dp0Tools\OACHECK.log not exists
	echo !DATE! !TIME! [Log ERROR] Fail, %~dp0Tools\OACHECK.log not exists >> %LogFile%
	echo !DATE! !TIME! [Log ERROR] Fail, %~dp0Tools\OACHECK.log not exists > Fail.tag
	goto END
)

type Tools\OACHECK.log | find /i "Check Result : PASS"

if %errorlevel% equ 0 (
	echo !DATE! !TIME! [Log TRACE] Pass, SLIC table existence meet spec   
	echo !DATE! !TIME! [Log TRACE] Pass, SLIC table existence meet spec  >> %LogFile%
	echo !DATE! !TIME! [Log TRACE] Pass, SLIC table existence meet spec  > Pass.tag
) else (
	echo !DATE! !TIME! [Log ERROR] Fail, SLIC table existence not meet spec
	echo !DATE! !TIME! [Log ERROR] Fail, SLIC table existence not meet spec >> %LogFile%
	echo !DATE! !TIME! [Log ERROR] Fail, SLIC table existence not meet spec > Fail.tag
)

:END
echo %DATE% %TIME% [Log LEAVE]  ============ %~dpnx0 ============
echo %DATE% %TIME% [Log LEAVE]  ============ %~dpnx0 ============ >> %LogFile%
echo.>>%LogFile%
popd
SETLOCAL DisableDelayedExpansion