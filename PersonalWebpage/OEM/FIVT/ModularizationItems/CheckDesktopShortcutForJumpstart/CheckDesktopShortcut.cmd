
@echo off
SETLOCAL EnableDelayedExpansion
pushd "%~dp0"

set LogFile=CheckDesktopShortcut.log

echo.>>%LogFile%
echo %DATE% %TIME% [Log START]  ============ %~dpnx0 ============
echo %DATE% %TIME% [Log START]  ============ %~dpnx0 ============ >> %LogFile%

if exist *.tag del /s /q *.tag
if exist *.txt del /s /q *.txt

if not exist "C:\OEM\Preload\Command\POP*.ini" (
	echo !DATE! !TIME! [Log TRACE] Not Acer Windows image, skip check
	echo !DATE! !TIME! [Log TRACE] Not Acer Windows image, skip check >> %LogFile%
	goto END
)

ver > GetOSVersion.txt

FIND /i "6.1." GetOSVersion.txt >> %LogFile% 2>&1
if %errorlevel% equ 0 (
	echo !DATE! !TIME! [Log TRACE] Pass, this is W7, no need to check Desktop Shortcut
    echo !DATE! !TIME! [Log TRACE] Pass, this is W7, no need to check Desktop Shortcut >> %LogFile%
	echo !DATE! !TIME! [Log TRACE] Pass, this is W7, no need to check Desktop Shortcut > Pass.tag
	goto END
) else (
	echo !DATE! !TIME! [Log TRACE] This is not W7, need to Check Desktop Shortcut
    echo !DATE! !TIME! [Log TRACE] This is not W7, need to Check Desktop Shortcut >> %LogFile%
)

:CheckDesktopShortcutCount
set CountShortcut=0

echo %DATE% %TIME%[Log TRACE]  powershell.exe -noprofile -executionpolicy unrestricted -file PublicDesktopPINCheck.ps1 >> %LogFile%
powershell.exe -noprofile -executionpolicy unrestricted -file PublicDesktopPINCheck.ps1 >> %LogFile% 2>&1
set CountShortcut=%errorlevel%

echo %DATE% %TIME% [Log TRACE] CountShortcut=[%CountShortcut%]
echo %DATE% %TIME% [Log TRACE] CountShortcut=[%CountShortcut%] >> %LogFile%

if %CountShortcut% gtr 1 (
	echo !DATE! !TIME! [Log ERROR] Fail, desktop shortcut count is more than 1
	echo !DATE! !TIME! [Log ERROR] Fail, desktop shortcut count is more than 1 >> %LogFile%
	echo !DATE! !TIME! [Log ERROR] Fail, desktop shortcut count is more than 1 > Fail.tag
) else (
	echo !DATE! !TIME! [Log TRACE] Pass, desktop shortcut count is 1 or 0.
	echo !DATE! !TIME! [Log TRACE] Pass, desktop shortcut count is 1 or 0. >> %LogFile%
	echo !DATE! !TIME! [Log TRACE] Pass, desktop shortcut count is 1 or 0. > Pass.tag
)

:END
echo %DATE% %TIME% [Log LEAVE]  ============ %~dpnx0 ============
echo %DATE% %TIME% [Log LEAVE]  ============ %~dpnx0 ============ >> %LogFile%
echo.>>%LogFile%
popd
SETLOCAL DisableDelayedExpansion
