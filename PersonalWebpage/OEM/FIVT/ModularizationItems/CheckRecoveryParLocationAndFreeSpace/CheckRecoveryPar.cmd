@echo off
SETLOCAL EnableDelayedExpansion
pushd "%~dp0"

set LogFile="%~dp0"CheckRecoveryPar.log

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

call Tools\FindValidDriveLetter.cmd >> %LogFile% 2>&1
echo %DATE% %TIME% [Log TRACE] Get valid letter is : %VALID_LETTER_1% %VALID_LETTER_2%
echo %DATE% %TIME% [Log TRACE] Get valid letter is : %VALID_LETTER_1% %VALID_LETTER_2%  >> %LogFile%

set PBR_LETTER=%VALID_LETTER_1%
echo %DATE% %TIME% [Log TRACE] Tools\MountPartition.exe /unmount %PBR_LETTER%
echo %DATE% %TIME% [Log TRACE] Tools\MountPartition.exe /unmount %PBR_LETTER% >> %LogFile%
Tools\MountPartition.exe /unmount %PBR_LETTER% >> %LogFile% 2>&1
echo %DATE% %TIME% [Log TRACE] Tools\MountPartition.exe /mountbyfile "NAPP.dat" %PBR_LETTER%
echo %DATE% %TIME% [Log TRACE] Tools\MountPartition.exe /mountbyfile "NAPP.dat" %PBR_LETTER% >> %LogFile%
Tools\MountPartition.exe /mountbyfile "NAPP.dat" %PBR_LETTER% >> %LogFile% 2>&1

:FIND_AND_CHECK_RCD_DAT
echo.>> %LogFile%
if exist %PBR_LETTER%\D2D_WIN10\RCD\RCD.dat (
	call :CHECK_RCD_DAT %PBR_LETTER%\D2D_WIN10\RCD\RCD.dat
	if !errorlevel! equ 2 (
		echo !DATE! !TIME! [Log TRACE] This machine has W10 OS, need to check Recovery partition
		echo !DATE! !TIME! [Log TRACE] This machine has W10 OS, need to check Recovery partition >> %LogFile%
		goto CHECK_RECOVERY_PAR_LOCATION
	)
)
if exist C:\OEM\NAPP\RCD.dat (
	call :CHECK_RCD_DAT C:\OEM\NAPP\RCD.dat
	if !errorlevel! equ 2 (
		echo !DATE! !TIME! [Log TRACE] This machine has W10 OS, need to check Recovery partition
		echo !DATE! !TIME! [Log TRACE] This machine has W10 OS, need to check Recovery partition. >> %LogFile%
		goto CHECK_RECOVERY_PAR_LOCATION
	)
)

echo %DATE% %TIME% [Log TRACE] Pass, this machine don't have W10 OS, no need to check Recovery partition 
echo %DATE% %TIME% [Log TRACE] Pass, this machine don't have W10 OS, no need to check Recovery partition >> %LogFile%
echo %DATE% %TIME% [Log TRACE] Pass, this machine don't have W10 OS, no need to check Recovery partition > Pass.tag
goto END

:CHECK_RECOVERY_PAR_LOCATION
set Recovery_LETTER=%VALID_LETTER_2%
echo %DATE% %TIME% [Log TRACE] Tools\MountPartition.exe /unmount %Recovery_LETTER%
echo %DATE% %TIME% [Log TRACE] Tools\MountPartition.exe /unmount %Recovery_LETTER% >> %LogFile%
Tools\MountPartition.exe /unmount %Recovery_LETTER% >> %LogFile% 2>&1
echo %DATE% %TIME% [Log TRACE] Tools\MountPartition.exe /mountbylabel "Recovery" %Recovery_LETTER%
echo %DATE% %TIME% [Log TRACE] Tools\MountPartition.exe /mountbylabel "Recovery" %Recovery_LETTER% >> %LogFile%
Tools\MountPartition.exe /mountbylabel "Recovery" %Recovery_LETTER% >> %LogFile% 2>&1

if not exist %Recovery_LETTER%\ (
	echo !DATE! !TIME! Fail, fail to mount Recovery partition or Recovery partition not exists 
	echo !DATE! !TIME! Fail, fail to mount Recovery partition or Recovery partition not exists >> %LogFile%
	echo !DATE! !TIME! Fail, fail to mount Recovery partition or Recovery partition not exists > Fail.tag
	goto END
)

set OSDiskIndex=0
set OSParIndex=0
set RecoveryDiskIndex=0
set RecoveryParIndex=0
set RecoveryRequiredParIndex=0

Cscript /nologo Tools\GetDiskPartIndex.vbs >> %LogFile% 2>&1

for /f "tokens=1,3,5 delims==- " %%k in ('Cscript /nologo Tools\GetDiskPartIndex.vbs') do (
	if %%k equ C: (
		set OSDiskIndex=%%l
		echo !DATE! !TIME! [Log TRACE] DiskIndex of OS partition is !OSDiskIndex!
		echo !DATE! !TIME! [Log TRACE] DiskIndex of OS partition is !OSDiskIndex! >> %LogFile%
		set OSParIndex=%%m
		echo !DATE! !TIME! [Log TRACE] PartitionIndex of OS partition is !OSParIndex!
		echo !DATE! !TIME! [Log TRACE] PartitionIndex of OS partition is !OSParIndex! >> %LogFile%
	)
	if %%k equ %Recovery_LETTER% (
		set RecoveryDiskIndex=%%l
		echo !DATE! !TIME! [Log TRACE] DiskIndex of Recovery partition is !RecoveryDiskIndex!
		echo !DATE! !TIME! [Log TRACE] DiskIndex of Recovery partition is !RecoveryDiskIndex! >> %LogFile%
		set RecoveryParIndex=%%m
		echo !DATE! !TIME! [Log TRACE] PartitionIndex of Recovery Partition is !RecoveryParIndex!
		echo !DATE! !TIME! [Log TRACE] PartitionIndex of Recovery Partition is !RecoveryParIndex! >> %LogFile%
	)
)

if %OSDiskIndex% equ %RecoveryDiskIndex% (
	echo !DATE! !TIME! [Log TRACE] DiskIndex of Recovery partition and OS partition is the same
	echo !DATE! !TIME! [Log TRACE] DiskIndex of Recovery partition and OS partition is the same >> %LogFile%
) else (
	echo !DATE! !TIME! [Log ERROR] Fail, diskIndex of Recovery partition [%RecoveryDiskIndex%] and OS partition [%OSDiskIndex%] is different
	echo !DATE! !TIME! [Log ERROR] Fail, diskIndex of Recovery partition [%RecoveryDiskIndex%] and OS partition [%OSDiskIndex%] is different >> %LogFile%
	echo !DATE! !TIME! [Log ERROR] Fail, diskIndex of Recovery partition [%RecoveryDiskIndex%] and OS partition [%OSDiskIndex%] is different > FailReason.txt
	goto CHECK_RECOVERY_PAR_FREE_SPACE
)

set /a RecoveryRequiredParIndex=%OSParIndex%+1
if %RecoveryParIndex% equ %RecoveryRequiredParIndex% (
	echo !DATE! !TIME! [Log TRACE] ParIndex of Recovery partition match spec
	echo !DATE! !TIME! [Log TRACE] ParIndex of Recovery partition match spec >> %LogFile%
) else (
	echo !DATE! !TIME! [Log ERROR] Fail, parIndex of Recovery partition not match spec
	echo !DATE! !TIME! [Log ERROR] Fail, parIndex of Recovery partition not match spec >> %LogFile%
	echo !DATE! !TIME! [Log ERROR] Fail, parIndex of Recovery partition not match spec > FailReason.txt
)

:CHECK_RECOVERY_PAR_FREE_SPACE

set NAPPDatPath=C:\OEM\NAPP\NAPP.dat
if exist %PBR_LETTER%\NAPP.dat set NAPPDatPath=%PBR_LETTER%\NAPP.dat
echo %DATE% %TIME% [Log TRACE] Check the NAPP major version in %NAPPDatPath%
echo %DATE% %TIME% [Log TRACE] Check the NAPP major version in %NAPPDatPath% >> %LogFile%
call :CHECK_NAPP_DAT %NAPPDatPath%
if %errorlevel% equ 2 (
	echo !DATE! !TIME! [Log TRACE] For 19H1 and newer build, use new rule to check
	echo !DATE! !TIME! [Log TRACE] For 19H1 and newer build, use new rule to check >> %LogFile%
	powershell -ExecutionPolicy ByPass -File "Tools\[19H1]WinREFreeSpaceDetection.ps1" >> %LogFile% 2>&1
) else (
	echo !DATE! !TIME! [Log TRACE] For RS5 and older build, use old rule to check
	echo !DATE! !TIME! [Log TRACE] For RS5 and older build, use old rule to check >> %LogFile%
	powershell -ExecutionPolicy ByPass -File "Tools\[Before 19H1]WinREFreeSpaceDetection.ps1" >> %LogFile% 2>&1
)

if exist Tools\WinREFreeSpaceNotMeetSpec.tag (	
	echo !DATE! !TIME! [Log ERROR] Fail, free space of Recovery partition not match spec
	echo !DATE! !TIME! [Log ERROR] Fail, free space of Recovery partition not match spec >> %LogFile%
	echo !DATE! !TIME! [Log ERROR] Fail, free space of Recovery partition not match spec >> FailReason.txt
) else (
	echo !DATE! !TIME! [Log TRACE] Free space of Recovery partition match spec
	echo !DATE! !TIME! [Log TRACE] Free space of Recovery partition match spec >> %LogFile%
)

:RESULT
if exist FailReason.txt (
	echo !DATE! !TIME! [Log ERROR] Fail, the location or free space of Recovery partition not match spec
	echo !DATE! !TIME! [Log ERROR] Fail, the location or free space of Recovery partition not match spec >> %LogFile%
	echo !DATE! !TIME! [Log ERROR] Fail, the location or free space of Recovery partition not match spec > Fail.tag
) else (
	echo !DATE! !TIME! [Log TRACE] Pass, the location and free space of Recovery partition match spec 
	echo !DATE! !TIME! [Log TRACE] Pass, the location and free space of Recovery partition match spec >> %LogFile%
	echo !DATE! !TIME! [Log TRACE] Pass, the location and free space of Recovery partition match spec > Pass.tag
)
goto END

:CHECK_RCD_DAT
type %1 | find /i "OS" | find /i "=" | find /i "W10"
if "%errorlevel%" equ "0" (
	echo !DATE! !TIME! [Log TRACE] Find W10 OS info in "%1"
	echo !DATE! !TIME! [Log TRACE] Find W10 OS info in "%1" >> %LogFile%
	exit /b 2
) else (
	echo !DATE! !TIME! [Log TRACE] Cannot find W10 OS info in "%1"
	echo !DATE! !TIME! [Log TRACE] Cannot find W10 OS info in "%1" >> %LogFile%
	exit /b 3
)

:CHECK_NAPP_DAT
for /f "tokens=2 delims==." %%v in ('type %1 ^| find /i "Version"') do (
	if %%v GEQ 14 (
		echo !DATE! !TIME! [Log TRACE] NAPP major version is %%v, larger than or equal to 14 in "%1"
		echo !DATE! !TIME! [Log TRACE] NAPP major version is %%v, larger than or equal to 14 in "%1" >> %LogFile%
		exit /b 2
	) else (
		echo !DATE! !TIME! [Log TRACE] NAPP major version is %%v, less than 14 in "%1"
		echo !DATE! !TIME! [Log TRACE] NAPP major version is %%v, less than 14 in "%1" >> %LogFile%
		exit /b 3
	)
)

:END
echo %DATE% %TIME% [Log TRACE] Unmount %VALID_LETTER_1%
echo %DATE% %TIME% [Log TRACE] Unmount %VALID_LETTER_1% >> %LogFile%
Tools\MountPartition.exe /unmount %VALID_LETTER_1% >> %LogFile% 2>&1
echo %DATE% %TIME% [Log TRACE] Unmount %VALID_LETTER_2%
echo %DATE% %TIME% [Log TRACE] Unmount %VALID_LETTER_2% >> %LogFile%
Tools\MountPartition.exe /unmount %VALID_LETTER_2% >> %LogFile% 2>&1
echo %DATE% %TIME% [Log LEAVE]  ============ %~dpnx0 ============
echo %DATE% %TIME% [Log LEAVE]  ============ %~dpnx0 ============ >> %LogFile%
echo.>> %LogFile%
popd
SETLOCAL DisableDelayedExpansion