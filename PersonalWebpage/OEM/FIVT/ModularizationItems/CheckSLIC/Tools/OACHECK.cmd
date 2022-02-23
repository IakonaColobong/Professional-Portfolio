
SETLOCAL enableDelayedExpansion
pushd %~dp0
del /f /q *.log
del /f /q *.txt

Set LogPath=OACHECK.log
ECHO [%DATE% %TIME%][INFO] %0 Start >> %LogPath%
echo.>> %LogPath%

if not exist "C:\OEM\Preload\Command\POP*.ini" (
	echo Not Acer Windows image, SLIC should not exist >> %LogPath%
	call :CHECKSLIC NO
	goto END
)

:MOUNT_OS_BY_DEVICEID
echo [MOUNT_OS_BY_DEVICEID] >> %LogPath%
if exist Hiddendrive rd /s /q Hiddendrive
md Hiddendrive
if exist OSdrive rd /s /q OSdrive
md OSdrive
wmic volume where DriveType=3 get DeviceID > LocalDisk.txt
REM Redirect the result to LocalDisk2.txt is must needed, or an error will occur, may due to a newline parameter
type LocalDisk.txt | find /i "volume" > LocalDisk2.txt 2>&1
for /f "tokens=*" %%v in (LocalDisk2.txt) do (
	set DeviceID=%%v
	if "!DeviceID:~0,4!" equ "\\?\" (
		echo Mountvol OSdrive !DeviceID! >> %LogPath%
		Mountvol OSdrive !DeviceID!
		if exist OSdrive\OEM\Preload\Command\POP*.ini (
			echo Find OSdrive >> %LogPath%
			goto MOUNT_HIDDEN_BY_DEVICEID
		)		
		Mountvol OSdrive /d
	)
)

:MOUNT_HIDDEN_BY_DEVICEID
echo.>> %LogPath%
echo [MOUNT_HIDDEN_BY_DEVICEID] >> %LogPath%
for /f "tokens=*" %%v in (LocalDisk2.txt) do (
	set DeviceID=%%v
	if "!DeviceID:~0,4!" equ "\\?\" (
		echo Mountvol Hiddendrive !DeviceID! >> %LogPath%
		Mountvol Hiddendrive !DeviceID!
		if exist Hiddendrive\NAPP.dat (
			echo Find Hiddendrive >> %LogPath%
			goto FIND_AND_CHECK_RCD_DAT
		)
		Mountvol Hiddendrive /d
	)
)

:FIND_AND_CHECK_RCD_DAT
echo.>> %LogPath%
echo [FIND_AND_CHECK_RCD_DAT] >> %LogPath%
if exist Hiddendrive\RCD.dat call :CHECK_RCD_DAT Hiddendrive\RCD.dat
if %errorlevel% equ 2 (
	echo This machine has W7 OS, SLIC should exist. >> %LogPath%
	call :CHECKSLIC YES
	goto END
)
if exist OSdrive\Windows\RCD.dat call :CHECK_RCD_DAT OSdrive\Windows\RCD.dat
if %errorlevel% equ 2 (
	echo This machine has W7 OS, SLIC should exist. >> %LogPath%
	call :CHECKSLIC YES
	goto END
)
if exist OSdrive\TempHiddenPartition\RCD.dat call :CHECK_RCD_DAT OSdrive\TempHiddenPartition\RCD.dat
if %errorlevel% equ 2 (
	echo This machine has W7 OS, SLIC should exist. >> %LogPath%
	call :CHECKSLIC YES
	goto END
)
if exist Hiddendrive\D2D_WIN7\RCD.dat call :CHECK_RCD_DAT Hiddendrive\D2D_WIN7\RCD.dat
if %errorlevel% equ 2 (
	echo This machine has W7 OS, SLIC should exist. >> %LogPath%
	call :CHECKSLIC YES
	goto END
)
if exist OSdrive\OEM\NAPP\RCD.dat call :CHECK_RCD_DAT OSdrive\OEM\NAPP\RCD.dat
if %errorlevel% equ 2 (
	echo This machine has W7 OS, SLIC should exist. >> %LogPath%
	call :CHECKSLIC YES
	goto END
)

echo This machine don't have W7 OS. >> %LogPath%
echo No W7 OS, SLIC should not exist >> %LogPath%
call :CHECKSLIC NO
goto END

:CHECK_RCD_DAT
type %1 | find /i "OS" | find /i "=" | find /i "W7"
if "%errorlevel%" equ "0" (
	echo Find OS info in "%1" >> %LogPath%
	echo OS is W7 >> %LogPath%
	exit /b 2
) else (
	echo Find OS info in "%1" >> %LogPath%
	echo OS is not W7 >> %LogPath%
	exit /b 3
)

:CHECKSLIC
echo.>> %LogPath%
echo [CHECKSLIC] >> %LogPath%
if %1 equ YES (
	SET STR="BIOS Category=Marked"
) else (
	SET STR="ACPI BIOS table SLIC is absent"
)
OACheck.exe > OA.log
echo Search for %STR% in OA.log >> %LogPath%
type OA.log | FIND /I %STR% >> %LogPath%
IF %ERRORLEVEL% == 0 (
	echo. >> %LogPath%
	echo Check Result : PASS >> %LogPath%
	echo. >> %LogPath%
) else (
	echo. >> %LogPath%
	echo Check Result : FAIL >> %LogPath%
	echo. >> %LogPath%
)
exit /b 0

:END
if exist Hiddendrive\NAPP.dat Mountvol Hiddendrive /d
rd /s /q Hiddendrive
if exist OSDrive (
	Mountvol OSdrive /d
	rd /s /q OSdrive
)
echo [%DATE% %TIME%][INFO] %0 END >> %LogPath% 2>&1
popd
SETLOCAL DisableDelayedExpansion
exit /b 0
