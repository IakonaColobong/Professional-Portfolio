@echo off
SETLOCAL EnableDelayedExpansion
pushd "%~dp0"

set LogFile=CheckCSUP.log

echo.>>%LogFile%
echo %DATE% %TIME% [Log START]  ============ %~dpnx0 ============
echo %DATE% %TIME% [Log START]  ============ %~dpnx0 ============ >> %LogFile%

if exist *.tag del /s /q *.tag

if not exist "C:\OEM\Preload\Command\POP*.ini" (
	echo !DATE! !TIME! [Log TRACE] Not Acer Windows image, skip check
	echo !DATE! !TIME! [Log TRACE] Not Acer Windows image, skip check >> %LogFile%
	goto END
)

if exist C:\Windows\CSUP.txt (
	echo !DATE! !TIME! [Log TRACE] Pass, C:\Windows\CSUP.txt exists, the CSUP day is:
	type C:\Windows\CSUP.txt
	echo.
	echo !DATE! !TIME! [Log TRACE] Pass, C:\Windows\CSUP.txt exists, the CSUP day is:  >> %LogFile%
	type C:\Windows\CSUP.txt >> %LogFile%
	echo.>> %LogFile%
	echo !DATE! !TIME! [Log TRACE] Pass, C:\Windows\CSUP.txt exists, the CSUP day is:  > Pass.tag
	type C:\Windows\CSUP.txt >> Pass.tag
	echo.>> Pass.tag
) else (
	echo !DATE! !TIME! [Log ERROR] Fail, C:\Windows\CSUP.txt not exists
	echo !DATE! !TIME! [Log ERROR] Fail, C:\Windows\CSUP.txt not exists >> %LogFile%
	echo !DATE! !TIME! [Log ERROR] Fail, C:\Windows\CSUP.txt not exists > Fail.tag
)

:END
echo %DATE% %TIME% [Log LEAVE]  ============ %~dpnx0 ============
echo %DATE% %TIME% [Log LEAVE]  ============ %~dpnx0 ============ >> %LogFile%
echo.>>%LogFile%
popd
SETLOCAL DisableDelayedExpansion