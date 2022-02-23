@echo off
SETLOCAL EnableDelayedExpansion
pushd "%~dp0"

set LogFile=CheckLogo8p1.log

echo.>> %LogFile%
echo %DATE% %TIME% [Log START]  ============ %~dpnx0 ============
echo %DATE% %TIME% [Log START]  ============ %~dpnx0 ============ >> %LogFile%

if exist *.tag del /s /q *.tag
del /s /q CheckCertification_failedlist.txt

if not exist "C:\OEM\Preload\Command\POP*.ini" (
	echo !DATE! !TIME! [Log TRACE] Not Acer Windows image, skip check
	echo !DATE! !TIME! [Log TRACE] Not Acer Windows image, skip check >> %LogFile%
	goto END
)

:CHECK_OS_VER_THEN_USE
echo %DATE% %TIME% [Log TRACE] Check OS version to see if CheckLogo8p1 need to be checked
echo %DATE% %TIME% [Log TRACE] Check OS version to see if CheckLogo8p1 need to be checked  >> %LogFile%

set FullOSVer=6.1.7600
for /f "tokens=4 delims=] " %%a in ('ver') do (
	REM 10.0.17134
    set FullOSVer=%%a
)
echo %DATE% %TIME% [Log TRACE] Full windows version is %FullOSVer%
echo %DATE% %TIME% [Log TRACE] Full windows version is %FullOSVer% >> %LogFile%

for /f "tokens=1,2 delims=." %%c in ("%FullOSVer%") do (
	REM 100
	set OSver=%%c%%d
	REM 10.0
	echo !DATE! !TIME! [Log TRACE] OS Version is %%c.%%d
	echo !DATE! !TIME! [Log TRACE] OS Version is %%c.%%d >> %LogFile%
)

if %OSver% GEQ 100 (
	echo !DATE! !TIME! [Log TRACE] Pass, no need to check CheckLogo8p1 in Windows 10 OS   
	echo !DATE! !TIME! [Log TRACE] Pass, no need to check CheckLogo8p1 in Windows 10 OS  >> %LogFile%
	echo !DATE! !TIME! [Log TRACE] Pass, no need to check CheckLogo8p1 in Windows 10 OS  > Pass.tag
	goto END
) else (
	echo !DATE! !TIME! [Log TRACE] OS is older than Windows 10, need to check CheckLogo8p1
	echo !DATE! !TIME! [Log TRACE] OS is older than Windows 10, need to check CheckLogo8p1 >> %LogFile%
)

call %Processor_architecture%\Run.cmd

if not exist %Processor_architecture%\CheckCertification_failedlist.txt (
	echo !DATE! !TIME! [Log ERROR] Fail, "%~dp0"%Processor_architecture%\CheckCertification_failedlist.txt not exists
	echo !DATE! !TIME! [Log ERROR] Fail, "%~dp0"%Processor_architecture%\CheckCertification_failedlist.txt not exists >> %LogFile%
	echo !DATE! !TIME! [Log ERROR] Fail, "%~dp0"%Processor_architecture%\CheckCertification_failedlist.txt not exists > Fail.tag
	goto END
)

echo.>> %LogFile%
type %Processor_architecture%\CheckCertification_failedlist.txt >> %LogFile% 2>&1
echo.>> %LogFile%

powershell -executionpolicy bypass -File CheckFileEmpty.ps1 %Processor_architecture%\CheckCertification_failedlist.txt | find /i "File is blank"

if %errorlevel% equ 0 (
	echo !DATE! !TIME! [Log TRACE] Pass, failedlist not exists   
	echo !DATE! !TIME! [Log TRACE] Pass, failedlist not exists  >> %LogFile%
	echo !DATE! !TIME! [Log TRACE] Pass, failedlist not exists  > Pass.tag
) else (
	echo !DATE! !TIME! [Log ERROR] Fail, failedlist exists, please check "%~dp0"%Processor_architecture%\CheckCertification_failedlist.txt
	echo !DATE! !TIME! [Log ERROR] Fail, failedlist exists, please check "%~dp0"%Processor_architecture%\CheckCertification_failedlist.txt >> %LogFile%
	echo !DATE! !TIME! [Log ERROR] Fail, failedlist exists, please check "%~dp0"%Processor_architecture%\CheckCertification_failedlist.txt > Fail.tag
)

:END
echo %DATE% %TIME% [Log LEAVE]  ============ %~dpnx0 ============
echo %DATE% %TIME% [Log LEAVE]  ============ %~dpnx0 ============ >> %LogFile%
echo.>>%LogFile%
popd
SETLOCAL DisableDelayedExpansion