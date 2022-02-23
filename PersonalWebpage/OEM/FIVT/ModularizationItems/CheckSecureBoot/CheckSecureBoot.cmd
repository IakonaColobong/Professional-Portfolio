@echo off
SETLOCAL EnableDelayedExpansion
pushd "%~dp0"

set LogFile=CheckSecureBoot.log

echo.>>%LogFile%
echo %DATE% %TIME% [Log START]  ============ %~dpnx0 ============
echo %DATE% %TIME% [Log START]  ============ %~dpnx0 ============ >> %LogFile%

if exist *.tag del /s /q *.tag
if exist *_result.log del /s /q *_result.log

if not exist "C:\OEM\Preload\Command\POP*.ini" (
	echo !DATE! !TIME! [Log TRACE] Not Acer Windows image, skip check
	echo !DATE! !TIME! [Log TRACE] Not Acer Windows image, skip check >> %LogFile%
	goto END
)

:CHECK_OS_VER
echo %DATE% %TIME% [Log TRACE] Check OS version to see if SecureBoot need to be checked
echo %DATE% %TIME% [Log TRACE] Check OS version to see if SecureBoot need to be checked  >> %LogFile%

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

if %OSver% GEQ 62 (
	echo !DATE! !TIME! [Log TRACE] OS is newer than Windows 8, need to check secure boot
	echo !DATE! !TIME! [Log TRACE] OS is newer than Windows 8, need to check secure boot >> %LogFile%
) else (
	echo !DATE! !TIME! [Log TRACE] Pass, no need to check secure boot in OS older than Windows 8 
	echo !DATE! !TIME! [Log TRACE] Pass, no need to check secure boot in OS older than Windows 8  >> %LogFile%
	echo !DATE! !TIME! [Log TRACE] Pass, no need to check secure boot in OS older than Windows 8  > Pass.tag
	goto END
)

:CHECK_CLOUD_OS
echo %DATE% %TIME% [Log TRACE] Check OS type to see if SecureBoot need to be checked
echo %DATE% %TIME% [Log TRACE] Check OS type to see if SecureBoot need to be checked  >> %LogFile%

reg query "HKLM\SOFTWARE\OEM\Metadata" /v CloudSku | find /i "True" >> %LogFile% 2>&1

if %errorlevel% equ 0 (
	echo !DATE! !TIME! [Log TRACE] Pass, no need to check secure boot in Cloud or S mode OS 
	echo !DATE! !TIME! [Log TRACE] Pass, no need to check secure boot in Cloud or S mode OS  >> %LogFile%
	echo !DATE! !TIME! [Log TRACE] Pass, no need to check secure boot in Cloud or S mode OS  > Pass.tag
	goto END
) else (
	echo !DATE! !TIME! [Log TRACE] Not Cloud or S mode OS, need to check secure boot
	echo !DATE! !TIME! [Log TRACE] Not Cloud or S mode OS, need to check secure boot >> %LogFile%
)

:CHECK_SKUID
echo %DATE% %TIME% [Log TRACE] Check SKUID to see if SecureBoot need to be checked
echo %DATE% %TIME% [Log TRACE] Check SKUID to see if SecureBoot need to be checked  >> %LogFile%

set CurrentSKUID=temp
set ResultLogPath=Temp_result.log
rem get SKUID by WCheckSku.exe
WCheckSku.exe /s
for /f "tokens=*" %%v in ('dir /b *_result.log') do set ResultLogPath=%%v

if exist %ResultLogPath% (
	call :PARSE_AND_FIND_SKUID %ResultLogPath%
	for %%j in ("F004h","F008h","F00Ah","F00Bh") do (
		if "!CurrentSKUID!" equ %%j (
			echo !DATE! !TIME! [Log TRACE] Pass, find specific SKUID: !CurrentSKUID!, no need to check secure boot
			echo !DATE! !TIME! [Log TRACE] Pass, find specific SKUID: !CurrentSKUID!, no need to check secure boot  >> %LogFile%
			echo !DATE! !TIME! [Log TRACE] Pass, find specific SKUID: !CurrentSKUID!, no need to check secure boot  > Pass.tag
			goto END
		)
	)
	echo !DATE! !TIME! [Log TRACE] Specific SKUID not found, continue to check secure boot
	echo !DATE! !TIME! [Log TRACE] Specific SKUID not found, continue to check secure boot >> %LogFile%
) else (
	echo !DATE! !TIME! [Log TRACE] Not One BIOS, continue to check secure boot
	echo !DATE! !TIME! [Log TRACE] Not One BIOS, continue to check secure boot >> %LogFile%
)

powershell Confirm-SecureBootUEFI | find /i "True"
if %errorlevel% equ 0 (
	echo !DATE! !TIME! [Log TRACE] Pass, secure boot is enabled
	echo !DATE! !TIME! [Log TRACE] Pass, secure boot is enabled  >> %LogFile%
	echo !DATE! !TIME! [Log TRACE] Pass, secure boot is enabled  > Pass.tag
) else (
	echo !DATE! !TIME! [Log ERROR] Fail, secure boot is disabled or not supported
	echo !DATE! !TIME! [Log ERROR] Fail, secure boot is disabled or not supported >> %LogFile%
	echo !DATE! !TIME! [Log ERROR] Fail, secure boot is disabled or not supported > Fail.tag
)
goto END


:PARSE_AND_FIND_SKUID
set /a counter=0
set /a specificLinenumber=0
for /f "tokens=*" %%a in (%1) do (
	set /a counter+=1
    if "%%a" equ "Your Computer Value:" (
		set /a specificLinenumber=!counter!+2
		goto :FIND_SKUID
	)
)
exit /b 0

:FIND_SKUID
set /a tempcounter=0
for /f "tokens=1" %%a in (%1) do (
	set /a tempcounter+=1
	if !tempcounter!==%specificLinenumber% (
		set CurrentSKUID=%%a
		echo !DATE! !TIME! [Log TRACE] SKUID is !CurrentSKUID!
		echo !DATE! !TIME! [Log TRACE] SKUID is !CurrentSKUID! >> %LogFile%
		exit /b 0
	)
)
exit /b 0

:END
echo %DATE% %TIME% [Log LEAVE]  ============ %~dpnx0 ============
echo %DATE% %TIME% [Log LEAVE]  ============ %~dpnx0 ============ >> %LogFile%
echo.>>%LogFile%
popd
SETLOCAL DisableDelayedExpansion