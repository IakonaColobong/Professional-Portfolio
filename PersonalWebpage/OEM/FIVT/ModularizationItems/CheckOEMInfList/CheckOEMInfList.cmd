@echo off
SETLOCAL EnableDelayedExpansion
pushd "%~dp0"

set LogFile=CheckOEMInfList.log

echo.>> %LogFile%
echo %DATE% %TIME% [Log START]  ============ %~dpnx0 ============
echo %DATE% %TIME% [Log START]  ============ %~dpnx0 ============ >> %LogFile%

if exist *.tag del /s /q *.tag
if exist *.txt del /s /q *.txt

if not exist "C:\OEM\Preload\Command\POP*.ini" (
	echo !DATE! !TIME! [Log TRACE] Not Acer Windows image, skip check
	echo !DATE! !TIME! [Log TRACE] Not Acer Windows image, skip check >> %LogFile%
	goto END
)

set OEMINFLISTPath=C:\OEM\Preload\OEMINFLIST.ini

if exist %OEMINFLISTPath% (
	echo !DATE! !TIME! [Log TRACE] OEMINFLIST.ini exists, continue to check
	echo !DATE! !TIME! [Log TRACE] OEMINFLIST.ini exists, continue to check >> %LogFile%
	type %OEMINFLISTPath% >> %LogFile% 2>&1
	echo.>> %LogFile%
) else ( 
	echo !DATE! !TIME! [Log TRACE] Pass, OEMINFLIST.ini not exists, no need to check 
	echo !DATE! !TIME! [Log TRACE] Pass, OEMINFLIST.ini not exists, no need to check >> %LogFile%
	echo !DATE! !TIME! [Log TRACE] Pass, OEMINFLIST.ini not exists, no need to check > Pass.tag
	goto END
)

DISM /online /english /get-drivers > driverlist.txt

for /f "eol=[ skip=1 tokens=1 delims==" %%i in (%OEMINFLISTPath%) do (
	echo !DATE! !TIME! [Log TRACE] Inf original file name : %%i
	echo !DATE! !TIME! [Log TRACE] Inf original file name : %%i >> %LogFile%

	findstr /i /C:": %%i" driverlist.txt >> %LogFile% 2>&1
	if !errorlevel! equ 0 (
		echo !DATE! !TIME! [Log TRACE] %%i exist in this machine
		echo !DATE! !TIME! [Log TRACE] %%i exist in this machine >> %LogFile%
	) else (
		echo !DATE! !TIME! [Log ERROR] Fail, %%i not exists in this machine
		echo !DATE! !TIME! [Log ERROR] Fail, %%i not exists in this machine >> %LogFile%
		echo !DATE! !TIME! [Log ERROR] Fail, %%i not exists in this machine >> FailInfList.txt
	)
)

if exist FailInfList.txt (
	echo !DATE! !TIME! [Log ERROR] Fail, some inf files not exist in this machine
	echo !DATE! !TIME! [Log ERROR] Fail, some inf files not exist in this machine >> %LogFile%
	echo !DATE! !TIME! [Log ERROR] Fail, some inf files not exist in this machine > Fail.tag
) else (
	echo !DATE! !TIME! [Log TRACE] Pass, all inf exist in this machine
	echo !DATE! !TIME! [Log TRACE] Pass, all inf exist in this machine >> %LogFile%
	echo !DATE! !TIME! [Log TRACE] Pass, all inf exist in this machine > Pass.tag
)

:END
echo %DATE% %TIME% [Log LEAVE]  ============ %~dpnx0 ============
echo %DATE% %TIME% [Log LEAVE]  ============ %~dpnx0 ============ >> %LogFile%
echo.>> %LogFile%
popd
SETLOCAL DisableDelayedExpansion