
@echo off
SETLOCAL EnableDelayedExpansion
pushd "%~dp0"

set LogFile=CheckUnknownDevice.log

if not exist C:\OEM\Acerlogs md C:\OEM\Acerlogs
Set DevconLogFile=C:\OEM\Acerlogs\FactoryDeviceStatus.txt 

echo.>>%LogFile%
echo %DATE% %TIME% [Log START]  ============ %~dpnx0 ============
echo %DATE% %TIME% [Log START]  ============ %~dpnx0 ============ >> %LogFile%
echo %DATE% %TIME% [Log START]  ============ %~dpnx0 ============ >> %DevconLogFile%

if exist *.tag del /s /q *.tag
if exist Unknown.txt del /s /q Unknown.txt

if not exist "C:\OEM\Preload\Command\POP*.ini" (
	echo !DATE! !TIME! [Log TRACE] Not Acer Windows image, skip check
	echo !DATE! !TIME! [Log TRACE] Not Acer Windows image, skip check >> %LogFile%
                echo !DATE! !TIME! [Log TRACE] Not Acer Windows image, skip check >> %DevconLogFile%
	goto END
)

echo %DATE% %TIME% [Log TRACE] timeout /t 10 to wait device ready
echo %DATE% %TIME% [Log TRACE] timeout /t 10 to wait device ready >> %LogFile%
timeout /t 10

echo %DATE% %TIME% [Log TRACE] find CPU type from "C:\OEM\Preload\Command\PAP\PAP*.ini"
echo %DATE% %TIME% [Log TRACE] find CPU type from "C:\OEM\Preload\Command\PAP\PAP*.ini" >> %LogFile%
find /i "CPU=" "C:\OEM\Preload\Command\PAP\PAP*.ini" > C:\OEM\FIVT\ModularizationItems\CheckUnknownDevice\CPUInfo.txt
for /f "tokens=2 delims==" %%f in (C:\OEM\FIVT\ModularizationItems\CheckUnknownDevice\CPUInfo.txt) do (
    set CPU_Type=%%f
    echo CPU Type=[!CPU_Type!]
    echo CPU Type=[!CPU_Type!] >> %LogFile%
)

echo %DATE% %TIME% [Log TRACE] Processor_architecture is [!CPU_Type!] 
echo %DATE% %TIME% [Log TRACE] Processor_architecture is [!CPU_Type!] >> %DevconLogFile%
echo %DATE% %TIME% [Log TRACE] "call !CPU_Type!\devcon.exe status *"
echo %DATE% %TIME% [Log TRACE] "call !CPU_Type!\devcon.exe status *" >> %DevconLogFile%
call !CPU_Type!\devcon.exe status * >> %DevconLogFile% 2>&1

CScript.exe /nologo ListUnknow.vbs /dli >> %LogFile%

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
echo %OSver%

if %OSver% GEQ 100 (
	if exist Unknown.txt (
		echo !DATE! !TIME! [Log ERROR] Fail, unknown device exist
		echo !DATE! !TIME! [Log ERROR] Fail, unknown device exist >> %LogFile%
		echo !DATE! !TIME! [Log ERROR] Fail, unknown device exist > Fail.tag
		type Unknown.txt >> %LogFile%
	) else (
		echo !DATE! !TIME! [Log TRACE] Pass, no any unknown device exists 
		echo !DATE! !TIME! [Log TRACE] Pass, no any unknown device exists  >> %LogFile%
		echo !DATE! !TIME! [Log TRACE] Pass, no any unknown device exists  > Pass.tag
	)
) else (
	echo !DATE! !TIME! [Log TRACE] Pass, no need to check unknown device in OS older than Windows 10 
	echo !DATE! !TIME! [Log TRACE] Pass, no need to check unknown device in OS older than Windows 10  >> %LogFile%
	echo !DATE! !TIME! [Log TRACE] Pass, no need to check unknown device in OS older than Windows 10  > Pass.tag
)

:END
echo %DATE% %TIME% [Log LEAVE]  ============ %~dpnx0 ============
echo %DATE% %TIME% [Log LEAVE]  ============ %~dpnx0 ============ >> %LogFile%
echo %DATE% %TIME% [Log LEAVE]  ============ %~dpnx0 ============ >> %DevconLogFile%
echo.>>%LogFile%
popd
SETLOCAL DisableDelayedExpansion