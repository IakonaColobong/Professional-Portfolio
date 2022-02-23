@echo off
SETLOCAL EnableDelayedExpansion
pushd "%~dp0"

set LogFile=CheckBIOSSkuID.log

echo.>>%LogFile%
echo %DATE% %TIME% [Log START]  ============ %~dpnx0 ============
echo %DATE% %TIME% [Log START]  ============ %~dpnx0 ============ >> %LogFile%

if exist *.tag del /s /q *.tag
del /s /q *_result.log >> %LogFile% 2>&1
if exist Dism_CurrentEdition.log del /s /q Dism_CurrentEdition.log

if not exist "C:\OEM\Preload\Command\POP*.ini" (
	echo !DATE! !TIME! [Log TRACE] Not Acer Windows image, skip check
	echo !DATE! !TIME! [Log TRACE] Not Acer Windows image, skip check >> %LogFile%
	goto END
)

:CHECK_BIOS_TYPE
echo %DATE% %TIME% [Log TRACE] Check it is One BIOS or not
echo %DATE% %TIME% [Log TRACE] Check it is One BIOS or not  >> %LogFile%

set CurrentSKUID=temp
set ResultLogPath=Temp_result.log
rem get SKUID by WCheckSku.exe
cd Tools
WCheckSku.exe /s
cd ..

if exist Tools\*_result.log (	
	echo !DATE! !TIME! [Log TRACE] It is One BIOS, need to check SKUID
	echo !DATE! !TIME! [Log TRACE] It is One BIOS, need to check SKUID >> %LogFile%
) else (
	echo !DATE! !TIME! [Log TRACE] Pass, it is not One BIOS, no need to check SKUID
	echo !DATE! !TIME! [Log TRACE] Pass, it is not One BIOS, no need to check SKUID >> %LogFile%
	echo !DATE! !TIME! [Log TRACE] Pass, it is not One BIOS, no need to check SKUID > Pass.tag
	goto END
)
for /f "tokens=*" %%v in ('dir /s /b *_result.log') do set ResultLogPath=%%v

:FIND_AND_CHECK_OSSKU
call Tools\FindValidDriveLetter.cmd >> %LogFile% 2>&1
echo %DATE% %TIME% [Log TRACE] Get valid letter is : %VALID_LETTER_1%
echo %DATE% %TIME% [Log TRACE] Get valid letter is : %VALID_LETTER_1% >> %LogFile%

set PBR_LETTER=%VALID_LETTER_1%
echo %DATE% %TIME% [Log TRACE] Tools\MountPartition.exe /unmount %PBR_LETTER%
echo %DATE% %TIME% [Log TRACE] Tools\MountPartition.exe /unmount %PBR_LETTER% >> %LogFile%
Tools\MountPartition.exe /unmount %PBR_LETTER% >> %LogFile% 2>&1
echo %DATE% %TIME% [Log TRACE] Tools\MountPartition.exe /mountbyfile "NAPP.dat" %PBR_LETTER%
echo %DATE% %TIME% [Log TRACE] Tools\MountPartition.exe /mountbyfile "NAPP.dat" %PBR_LETTER% >> %LogFile%
Tools\MountPartition.exe /mountbyfile "NAPP.dat" %PBR_LETTER% >> %LogFile% 2>&1

echo.>> %LogFile%
REM Only support W7/W10/W7+W10 GPT
set OSSKU=None
REM Hidden case
if exist %PBR_LETTER%\RCD.dat (
	echo !DATE! !TIME! [Log TRACE] %PBR_LETTER%\RCD.dat exists
	echo !DATE! !TIME! [Log TRACE] %PBR_LETTER%\RCD.dat exists >> %LogFile%
	
	if exist %PBR_LETTER%\D2D_WIN10\RCD\RCD.dat (
		echo !DATE! !TIME! [Log TRACE] %PBR_LETTER%\D2D_WIN10\RCD\RCD.dat exists
		echo !DATE! !TIME! [Log TRACE] %PBR_LETTER%\D2D_WIN10\RCD\RCD.dat exists >> %LogFile%
		
		set OSSKU=W7W10
		echo !DATE! !TIME! [Log TRACE] set OSSKU=!OSSKU!
		echo !DATE! !TIME! [Log TRACE] set OSSKU=!OSSKU! >> %LogFile%
		goto CHECK_BIOS_TABLE_CONSISTENCY
	)
	set OSSKU=W7
	echo !DATE! !TIME! [Log TRACE] Set OSSKU=!OSSKU!
	echo !DATE! !TIME! [Log TRACE] Set OSSKU=!OSSKU! >> %LogFile%
	goto CHECK_BIOS_TABLE_CONSISTENCY
) else (
	if exist %PBR_LETTER%\D2D_WIN10\RCD\RCD.dat (
		echo !DATE! !TIME! [Log TRACE] %PBR_LETTER%\D2D_WIN10\RCD\RCD.dat exists
		echo !DATE! !TIME! [Log TRACE] %PBR_LETTER%\D2D_WIN10\RCD\RCD.dat exists >> %LogFile%
		
		set OSSKU=W10
		echo !DATE! !TIME! [Log TRACE] set OSSKU=!OSSKU!
		echo !DATE! !TIME! [Log TRACE] set OSSKU=!OSSKU! >> %LogFile%
		goto CHECK_BIOS_TABLE_CONSISTENCY
	)
)
REM No hidden case
if exist C:\OEM\NAPP\RCD.dat (
	echo !DATE! !TIME! [Log TRACE] C:\OEM\NAPP\RCD.dat exists
	echo !DATE! !TIME! [Log TRACE] C:\OEM\NAPP\RCD.dat exists >> %LogFile%
	
	call :CHECK_RCD_DAT C:\OEM\NAPP\RCD.dat
	if !errorlevel! equ 2 (
		set OSSKU=W10
		echo !DATE! !TIME! [Log TRACE] set OSSKU=!OSSKU!
		echo !DATE! !TIME! [Log TRACE] set OSSKU=!OSSKU! >> %LogFile%
		goto CHECK_BIOS_TABLE_CONSISTENCY
	)
	if !errorlevel! equ 3 (
		set OSSKU=W7
		echo !DATE! !TIME! [Log TRACE] set OSSKU=!OSSKU!
		echo !DATE! !TIME! [Log TRACE] set OSSKU=!OSSKU! >> %LogFile%
		goto CHECK_BIOS_TABLE_CONSISTENCY
	)
)
echo %DATE% %TIME% [Log ERROR] Fail, unspecified OSSKU
echo %DATE% %TIME% [Log ERROR] Fail, unspecified OSSKU >> %LogFile%
echo %DATE% %TIME% [Log ERROR] Fail, unspecified OSSKU > Fail.tag
goto END

:CHECK_BIOS_TABLE_CONSISTENCY
for /f "delims=" %%a in (%ResultLogPath%) do (
	echo %%a | find /i "Test result" 	
	if !errorlevel! equ 0 (
		echo %%a | find /i "Pass"
		if !errorlevel! equ 0 (
			echo !DATE! !TIME! [Log TRACE] One BIOS table is consistent with spec
			echo !DATE! !TIME! [Log TRACE] One BIOS table is consistent with spec  >> %LogFile%
			goto CHECK_SKUID
		) else (
			echo !DATE! !TIME! [Log ERROR] Fail, One BIOS table is not consistent with spec
			echo !DATE! !TIME! [Log ERROR] Fail, One BIOS table is not consistent with spec >> %LogFile%
			echo !DATE! !TIME! [Log ERROR] Fail, One BIOS table is not consistent with spec > Fail.tag
			goto END
		)
	)
)
echo %DATE% %TIME% [Log ERROR] Fail, cannot find the test result
echo %DATE% %TIME% [Log ERROR] Fail, cannot find the test result >> %LogFile%
echo %DATE% %TIME% [Log ERROR] Fail, cannot find the test result > Fail.tag
goto END

:CHECK_SKUID
call :PARSE_AND_FIND_SKUID %ResultLogPath%
echo %DATE% %TIME% [Log TRACE] SKUID is: %CurrentSKUID%
echo %DATE% %TIME% [Log TRACE] SKUID is: %CurrentSKUID% >> %LogFile%

if %OSSKU% equ W7 (
	for %%j in (0002h,0003h,0006h,0007h) do (
		if %CurrentSKUID% equ %%j (
			echo !DATE! !TIME! [Log TRACE] Pass, BIOS SKUID is consistent with OS sku
			echo !DATE! !TIME! [Log TRACE] Pass, BIOS SKUID is consistent with OS sku >> %LogFile%
			echo !DATE! !TIME! [Log TRACE] Pass, BIOS SKUID is consistent with OS sku > Pass.tag
			goto END
		)
	)
	echo !DATE! !TIME! [Log ERROR] Fail, BIOS SKUID is not consistent with OS sku
	echo !DATE! !TIME! [Log ERROR] Fail, BIOS SKUID is not consistent with OS sku >> %LogFile%
	echo !DATE! !TIME! [Log ERROR] Fail, BIOS SKUID is not consistent with OS sku > Fail.tag
	goto END
)

if %OSSKU% equ W10 (
	Dism /Online /Get-CurrentEdition /English > Dism_CurrentEdition.log
	(type Dism_CurrentEdition.log | find /i "Professional") || ((type Dism_CurrentEdition.log | find /i "Enterprise"))
	if !errorlevel! equ 0 (
		echo !DATE! !TIME! [Log TRACE] This is W10 Pro
		echo !DATE! !TIME! [Log TRACE] This is W10 Pro >> %LogFile%
		for %%j in (0004h,0008h,000Ah,000Bh,F004h,F008h,F00Ah,F00Bh) do (
			if %CurrentSKUID% equ %%j (
				echo !DATE! !TIME! [Log TRACE] Pass, BIOS SKUID is consistent with OS sku
				echo !DATE! !TIME! [Log TRACE] Pass, BIOS SKUID is consistent with OS sku >> %LogFile%
				echo !DATE! !TIME! [Log TRACE] Pass, BIOS SKUID is consistent with OS sku > Pass.tag
				goto END
			)
		)
		echo !DATE! !TIME! [Log ERROR] Fail, BIOS SKUID is not consistent with OS sku
		echo !DATE! !TIME! [Log ERROR] Fail, BIOS SKUID is not consistent with OS sku >> %LogFile%
		echo !DATE! !TIME! [Log ERROR] Fail, BIOS SKUID is not consistent with OS sku > Fail.tag
		goto END
	) else (
		echo !DATE! !TIME! [Log TRACE] This is W10 non-Pro
		echo !DATE! !TIME! [Log TRACE] This is W10 non-Pro >> %LogFile%
		for %%j in (0004h,0008h,F004h,F008h) do (
			if %CurrentSKUID% equ %%j (
				echo !DATE! !TIME! [Log TRACE] Pass, BIOS SKUID is consistent with OS sku
				echo !DATE! !TIME! [Log TRACE] Pass, BIOS SKUID is consistent with OS sku >> %LogFile%
				echo !DATE! !TIME! [Log TRACE] Pass, BIOS SKUID is consistent with OS sku > Pass.tag
				goto END
			)
		)
		echo !DATE! !TIME! [Log ERROR] Fail, BIOS SKUID is not consistent with OS sku
		echo !DATE! !TIME! [Log ERROR] Fail, BIOS SKUID is not consistent with OS sku >> %LogFile%
		echo !DATE! !TIME! [Log ERROR] Fail, BIOS SKUID is not consistent with OS sku > Fail.tag
		goto END
	)
)

if %OSSKU% equ W7W10 (
	for %%j in (0005h,0009h) do (
		if %CurrentSKUID% equ %%j (
			echo !DATE! !TIME! [Log TRACE] Pass, BIOS SKUID is consistent with OS sku
			echo !DATE! !TIME! [Log TRACE] Pass, BIOS SKUID is consistent with OS sku >> %LogFile%
			echo !DATE! !TIME! [Log TRACE] Pass, BIOS SKUID is consistent with OS sku > Pass.tag
			goto END
		)
	)
	echo !DATE! !TIME! [Log ERROR] Fail, BIOS SKUID is not consistent with OS sku
	echo !DATE! !TIME! [Log ERROR] Fail, BIOS SKUID is not consistent with OS sku >> %LogFile%
	echo !DATE! !TIME! [Log ERROR] Fail, BIOS SKUID is not consistent with OS sku > Fail.tag
	goto END
)

:CHECK_RCD_DAT
type %1 | find /i "OS" | find /i "=" | find /i "W10"
if "%errorlevel%" equ "0" (
	echo !DATE! !TIME! [Log TRACE] Find W10 OS info in "%1"
	echo !DATE! !TIME! [Log TRACE] Find W10 OS info in "%1" >> %LogFile%
	exit /b 2
)
type %1 | find /i "OS" | find /i "=" | find /i "W7"
if "%errorlevel%" equ "0" (
	echo !DATE! !TIME! [Log TRACE] Find W7 OS info in "%1"
	echo !DATE! !TIME! [Log TRACE] Find W7 OS info in "%1" >> %LogFile%
	exit /b 3
)
exit /b 4

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
		exit /b 0
	)
)
exit /b 0

:END
if "%VALID_LETTER_1%" neq "" (
	echo %DATE% %TIME% [Log TRACE] Unmount %VALID_LETTER_1%
	Tools\MountPartition.exe /unmount %VALID_LETTER_1% >> %LogFile% 2>&1
)
echo %DATE% %TIME% [Log LEAVE]  ============ %~dpnx0 ============
echo %DATE% %TIME% [Log LEAVE]  ============ %~dpnx0 ============ >> %LogFile%
echo.>>%LogFile%
popd
SETLOCAL DisableDelayedExpansion