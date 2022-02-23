
@echo off
SETLOCAL EnableDelayedExpansion
pushd "%~dp0"

set LogFile=CheckVGADriver.log

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

echo.>> %LogFile%
echo %DATE% %TIME% [Log TRACE] Query WMI to get VGA driver provider
echo %DATE% %TIME% [Log TRACE] Query WMI to get VGA driver provider >> %LogFile%

wmic path win32_pnpsigneddriver where "deviceclass='DISPLAY'" get DriverProviderName > VGA_DriverProvider.txt
type VGA_DriverProvider.txt | find /i "Microsoft"
if %errorlevel% equ 0 (
	echo !DATE! !TIME! [Log ERROR] Fail, VGA driver provider is Microsoft
	echo !DATE! !TIME! [Log ERROR] Fail, VGA driver provider is Microsoft >> %LogFile%
	echo !DATE! !TIME! [Log ERROR] Fail, VGA driver provider is Microsoft > Fail.tag
) else (
	echo !DATE! !TIME! [Log TRACE] Pass, VGA driver provider is not Microsoft 
	echo !DATE! !TIME! [Log TRACE] Pass, VGA driver provider is not Microsoft >> %LogFile%
	echo !DATE! !TIME! [Log TRACE] Pass, VGA driver provider is not Microsoft > Pass.tag
)

:END
echo %DATE% %TIME% [Log LEAVE]  ============ %~dpnx0 ============
echo %DATE% %TIME% [Log LEAVE]  ============ %~dpnx0 ============ >> %LogFile%
echo.>>%LogFile%
popd
SETLOCAL DisableDelayedExpansion