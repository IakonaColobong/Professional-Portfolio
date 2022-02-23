
SETLOCAL enableDelayedExpansion
pushd "%~dp0"
SET NAPPLogPath=GoToNAPP.log
echo.>> %NAPPLogPath%
echo.>> %NAPPLogPath%
ECHO [%DATE% %TIME%][INFO] %~dpnx0 Start >> %NAPPLogPath%


REM Get VALID_LETTER_1 VALID_LETTER_2 VALID_LETTER_3 
call C:\OEM\Preload\utility\FindValidDriveLetter.cmd
type "SystemCD.dat" | find /i "BootMode=Legacy"
if %errorlevel% equ 0 goto SET_PQSERVICE_TO_ACTIVE

:MOUNT_WIM_DRIVE
ECHO [%DATE% %TIME%] MOUNT_WIM_DRIVE>>%NAPPLogPath%
set WIM_LETTER=%VALID_LETTER_1%
set WIM_PATH=
echo [%DATE% %TIME%] WIM_LETTER is [%WIM_LETTER%] >> %NAPPLogPath%
if "%WIM_LETTER%" equ "" (
	echo [!DATE! !TIME!] Fail to find free drive letter for WIM drive >> %NAPPLogPath% 2>&1
	goto ERROR
)
SET MountPartitionPath=MountPartition.exe
type "SystemCD.dat" | find /i "CPU=ARM64"
if %errorlevel% equ 0 SET MountPartitionPath=MountPartition_ARM64.exe
ECHO [%DATE% %TIME%] %MountPartitionPath% /unmount %WIM_LETTER% >> %NAPPLogPath% 2>&1
%MountPartitionPath% /unmount %WIM_LETTER% >> %NAPPLogPath% 2>&1
ECHO [%DATE% %TIME%] %MountPartitionPath% /mountbyfile "TempHidden\SCD\Sources\boot.wim" %WIM_LETTER% >> %NAPPLogPath% 2>&1
%MountPartitionPath% /mountbyfile "TempHidden\SCD\Sources\boot.wim" %WIM_LETTER% >> %NAPPLogPath% 2>&1
if "%errorlevel%" equ "0" (
	set WIM_PATH=\TempHidden\SCD\Sources\boot.wim
	echo [!DATE! !TIME!] WIM_PATH is [!WIM_PATH!] >> %NAPPLogPath%
	goto MOUNT_WIM_DRIVE_END
)
ECHO [%DATE% %TIME%] %MountPartitionPath% /unmount %WIM_LETTER% >> %NAPPLogPath% 2>&1
%MountPartitionPath% /unmount %WIM_LETTER% >> %NAPPLogPath% 2>&1
ECHO [%DATE% %TIME%] %MountPartitionPath% /mountbyfile "Sources\boot.wim" %WIM_LETTER% >> %NAPPLogPath% 2>&1
%MountPartitionPath% /mountbyfile "Sources\boot.wim" %WIM_LETTER% >> %NAPPLogPath% 2>&1
if "%errorlevel%" equ "0" (
	set WIM_PATH=\Sources\boot.wim
	echo [!DATE! !TIME!] WIM_PATH is [!WIM_PATH!] >> %NAPPLogPath%
	goto MOUNT_WIM_DRIVE_END
)
IF NOT EXIST %WIM_LETTER%\ (
	echo [!DATE! !TIME!] Fail to mount WIM drive >> %NAPPLogPath% 2>&1
	goto ERROR
)
:MOUNT_WIM_DRIVE_END

:MOUNT_SDI_DRIVE
ECHO [%DATE% %TIME%] MOUNT_SDI_DRIVE>>%NAPPLogPath%
set SDI_LETTER=%VALID_LETTER_2%
set SDI_PATH=
echo [%DATE% %TIME%] SDI_LETTER is %SDI_LETTER% >> %NAPPLogPath%
if "%SDI_LETTER%" equ "" (
	echo [!DATE! !TIME!] Fail to find free drive letter for SDI drive >> %NAPPLogPath% 2>&1
	goto ERROR
)
ECHO [%DATE% %TIME%] %MountPartitionPath% /unmount %SDI_LETTER% >> %NAPPLogPath% 2>&1	
%MountPartitionPath% /unmount %SDI_LETTER% >> %NAPPLogPath% 2>&1
ECHO [%DATE% %TIME%] %MountPartitionPath% /mountbyfile "TempHidden\SCD\boot\boot.sdi" %SDI_LETTER% >> %NAPPLogPath% 2>&1
%MountPartitionPath% /mountbyfile "TempHidden\SCD\boot\boot.sdi" %SDI_LETTER% >> %NAPPLogPath% 2>&1
if "%errorlevel%" equ "0" (
	set SDI_PATH=\TempHidden\SCD\boot\boot.sdi
	echo [!DATE! !TIME!] SDI_PATH is [!SDI_PATH!] >> %NAPPLogPath%
	goto MOUNT_SDI_DRIVE_END
)
ECHO [%DATE% %TIME%] %MountPartitionPath% /unmount %SDI_LETTER% >> %NAPPLogPath% 2>&1
%MountPartitionPath% /unmount %SDI_LETTER% >> %NAPPLogPath% 2>&1
ECHO [%DATE% %TIME%] %MountPartitionPath% /mountbyfile "boot\boot.sdi" %SDI_LETTER% >> %NAPPLogPath% 2>&1
%MountPartitionPath% /mountbyfile "boot\boot.sdi" %SDI_LETTER% >> %NAPPLogPath% 2>&1
if "%errorlevel%" equ "0" (
	set SDI_PATH=\boot\boot.sdi
	echo [!DATE! !TIME!] SDI_PATH is [!SDI_PATH!] >> %NAPPLogPath%
	goto MOUNT_SDI_DRIVE_END
)
IF NOT EXIST %SDI_LETTER%\ (
	echo [!DATE! !TIME!] Fail to mount SDI drive >> %NAPPLogPath% 2>&1
	goto ERROR
)
:MOUNT_SDI_DRIVE_END

:MOUNT_EFI_DRIVE
ECHO [%DATE% %TIME%] MOUNT_EFI_DRIVE>>%NAPPLogPath%
set EFI_LETTER=%VALID_LETTER_3%
set EFI_PATH=
echo [%DATE% %TIME%] EFI_LETTER is %EFI_LETTER% >> %NAPPLogPath%
if "%EFI_LETTER%" equ "" (
	echo [!DATE! !TIME!] Fail to find free drive letter for EFI drive >> %NAPPLogPath% 2>&1
	goto ERROR
)
ECHO [%DATE% %TIME%] %MountPartitionPath% /unmount [%EFI_LETTER%] >> %NAPPLogPath% 2>&1
%MountPartitionPath% /unmount %EFI_LETTER% >> %NAPPLogPath% 2>&1
ECHO [%DATE% %TIME%] %MountPartitionPath% /mountbylabel ESP [%EFI_LETTER%] >> %NAPPLogPath% 2>&1	
%MountPartitionPath% /mountbylabel ESP %EFI_LETTER% >> %NAPPLogPath% 2>&1	
if not exist %EFI_LETTER%\ (
	echo Fail to mount EFI drive >> %NAPPLogPath% 2>&1
	goto ERROR
)
:MOUNT_EFI_DRIVE_END

:COPY_EFI
rem robocopy ..\..\EFI %EFI_LETTER%\EFI /mir >> %NAPPLogPath% 2>&1
IF NOT EXIST %EFI_LETTER%\EFI\Microsoft\Boot\BCD (
	echo [!DATE! !TIME!] Fail to find %EFI_LETTER%\EFI\Microsoft\Boot\BCD in ESP drive >> %NAPPLogPath% 2>&1
	goto ERROR
)
IF NOT EXIST %EFI_LETTER%\EFI\Microsoft\Boot\bootmgfw.efi (
	echo [!DATE! !TIME!] Fail to find %EFI_LETTER%\EFI\Microsoft\Boot\bootmgfw.efi in ESP drive >> %NAPPLogPath% 2>&1
	goto ERROR
)
set EFI_PATH=\EFI\Microsoft\Boot\bootmgfw.efi

:BCDEDIT_START
echo [%DATE% %TIME%] set WINPE_GUID={572bcd56-ffa7-11d9-aae0-0007e994107d} >> %NAPPLogPath% 2>&1
set WINPE_GUID={572bcd56-ffa7-11d9-aae0-0007e994107d} >> %NAPPLogPath% 2>&1

rem 20170324, Keep OS GUID in BCD file so that SCDTemplate can restore it to boot from OS
rem echo [%DATE% %TIME%] bcdedit /store %EFI_LETTER%\EFI\Microsoft\Boot\BCD -delete {default} /cleanup >> %NAPPLogPath% 2>&1
rem bcdedit /store %EFI_LETTER%\EFI\Microsoft\Boot\BCD -delete {default} /cleanup >> %NAPPLogPath% 2>&1

SET BCDEditPath=bcdedit.exe
if exist C:\Windows\Sysnative\bcdedit.exe SET BCDEditPath=C:\Windows\Sysnative\bcdedit.exe
echo [%DATE% %TIME%] %BCDEditPath% /store %EFI_LETTER%\EFI\Microsoft\Boot\BCD -set {bootmgr} device partition=%EFI_LETTER% >> %NAPPLogPath% 2>&1
%BCDEditPath% /store %EFI_LETTER%\EFI\Microsoft\Boot\BCD -set {bootmgr} device partition=%EFI_LETTER% >> %NAPPLogPath% 2>&1

echo [%DATE% %TIME%] %BCDEditPath% /store %EFI_LETTER%\EFI\Microsoft\Boot\BCD -set {bootmgr} path %EFI_PATH% >> %NAPPLogPath% 2>&1
%BCDEditPath% /store %EFI_LETTER%\EFI\Microsoft\Boot\BCD -set {bootmgr} path %EFI_PATH% >> %NAPPLogPath% 2>&1

echo [%DATE% %TIME%] %BCDEditPath% /store %EFI_LETTER%\EFI\Microsoft\Boot\BCD -set {bootmgr} timeout 0 >> %NAPPLogPath% 2>&1
%BCDEditPath% /store %EFI_LETTER%\EFI\Microsoft\Boot\BCD -set {bootmgr} timeout 0 >> %NAPPLogPath% 2>&1

echo [%DATE% %TIME%] %BCDEditPath% /store %EFI_LETTER%\EFI\Microsoft\BOOT\BCD -create %WINPE_GUID% /d "Acer Recovery Management" -application osloader >> %NAPPLogPath% 2>&1
%BCDEditPath% /store %EFI_LETTER%\EFI\Microsoft\BOOT\BCD -create %WINPE_GUID% /d "Acer Recovery Management" -application osloader >> %NAPPLogPath% 2>&1

echo [%DATE% %TIME%] %BCDEditPath% /store %EFI_LETTER%\EFI\Microsoft\BOOT\BCD -create {ramdiskoptions} /d "Acer Recovery Management" >> %NAPPLogPath% 2>&1
%BCDEditPath% /store %EFI_LETTER%\EFI\Microsoft\BOOT\BCD -create {ramdiskoptions} /d "Acer Recovery Management" >> %NAPPLogPath% 2>&1

echo [%DATE% %TIME%] %BCDEditPath% /store %EFI_LETTER%\EFI\Microsoft\BOOT\BCD -set %WINPE_GUID% device ramdisk=[%WIM_LETTER%]%WIM_PATH%,{ramdiskoptions} >> %NAPPLogPath% 2>&1
%BCDEditPath% /store %EFI_LETTER%\EFI\Microsoft\BOOT\BCD -set %WINPE_GUID% device ramdisk=[%WIM_LETTER%]%WIM_PATH%,{ramdiskoptions} >> %NAPPLogPath% 2>&1

echo [%DATE% %TIME%] %BCDEditPath% /store %EFI_LETTER%\EFI\Microsoft\BOOT\BCD -set %WINPE_GUID% path \windows\system32\winload.efi >> %NAPPLogPath% 2>&1
%BCDEditPath% /store %EFI_LETTER%\EFI\Microsoft\BOOT\BCD -set %WINPE_GUID% path \windows\system32\winload.efi >> %NAPPLogPath% 2>&1

echo [%DATE% %TIME%] %BCDEditPath% /store %EFI_LETTER%\EFI\Microsoft\BOOT\BCD -set %WINPE_GUID% osdevice ramdisk=[%WIM_LETTER%]%WIM_PATH%,{ramdiskoptions}  >> %NAPPLogPath% 2>&1
%BCDEditPath% /store %EFI_LETTER%\EFI\Microsoft\BOOT\BCD -set %WINPE_GUID% osdevice ramdisk=[%WIM_LETTER%]%WIM_PATH%,{ramdiskoptions}  >> %NAPPLogPath% 2>&1

echo [%DATE% %TIME%] %BCDEditPath% /store %EFI_LETTER%\EFI\Microsoft\BOOT\BCD -set %WINPE_GUID% systemroot \windows >> %NAPPLogPath% 2>&1
%BCDEditPath% /store %EFI_LETTER%\EFI\Microsoft\BOOT\BCD -set %WINPE_GUID% systemroot \windows >> %NAPPLogPath% 2>&1

echo [%DATE% %TIME%] %BCDEditPath% /store %EFI_LETTER%\EFI\Microsoft\BOOT\BCD -set %WINPE_GUID% winpe yes >> %NAPPLogPath% 2>&1
%BCDEditPath% /store %EFI_LETTER%\EFI\Microsoft\BOOT\BCD -set %WINPE_GUID% winpe yes >> %NAPPLogPath% 2>&1

echo [%DATE% %TIME%] %BCDEditPath% /store %EFI_LETTER%\EFI\Microsoft\BOOT\BCD -set %WINPE_GUID% nx optin >> %NAPPLogPath% 2>&1
%BCDEditPath% /store %EFI_LETTER%\EFI\Microsoft\BOOT\BCD -set %WINPE_GUID% nx optin >> %NAPPLogPath% 2>&1

echo [%DATE% %TIME%] %BCDEditPath% /store %EFI_LETTER%\EFI\Microsoft\BOOT\BCD -set %WINPE_GUID% detecthal yes >> %NAPPLogPath% 2>&1
%BCDEditPath% /store %EFI_LETTER%\EFI\Microsoft\BOOT\BCD -set %WINPE_GUID% detecthal yes >> %NAPPLogPath% 2>&1

echo [%DATE% %TIME%] %BCDEditPath% /store %EFI_LETTER%\EFI\Microsoft\BOOT\BCD -displayorder %WINPE_GUID% -addfirst >> %NAPPLogPath% 2>&1
%BCDEditPath% /store %EFI_LETTER%\EFI\Microsoft\BOOT\BCD -displayorder %WINPE_GUID% -addfirst >> %NAPPLogPath% 2>&1

echo [%DATE% %TIME%] %BCDEditPath% /store %EFI_LETTER%\EFI\Microsoft\BOOT\BCD -set {ramdiskoptions} ramdisksdidevice partition=%SDI_LETTER% >> %NAPPLogPath% 2>&1
%BCDEditPath% /store %EFI_LETTER%\EFI\Microsoft\BOOT\BCD -set {ramdiskoptions} ramdisksdidevice partition=%SDI_LETTER% >> %NAPPLogPath% 2>&1

echo [%DATE% %TIME%] %BCDEditPath% /store %EFI_LETTER%\EFI\Microsoft\BOOT\BCD -set {ramdiskoptions} ramdisksdipath %SDI_PATH% >> %NAPPLogPath% 2>&1
%BCDEditPath% /store %EFI_LETTER%\EFI\Microsoft\BOOT\BCD -set {ramdiskoptions} ramdisksdipath %SDI_PATH% >> %NAPPLogPath% 2>&1

echo [%DATE% %TIME%] %BCDEditPath% /store %EFI_LETTER%\EFI\Microsoft\BOOT\BCD /default %WINPE_GUID% >> %NAPPLogPath% 2>&1
%BCDEditPath% /store %EFI_LETTER%\EFI\Microsoft\BOOT\BCD /default %WINPE_GUID% >> %NAPPLogPath% 2>&1
goto END

:SET_PQSERVICE_TO_ACTIVE
set PQSERVICE_LETTER=%VALID_LETTER_1%
ECHO [%DATE% %TIME%] %MountPartitionPath% /unmount %PQSERVICE_LETTER% >> %NAPPLogPath% 2>&1	
%MountPartitionPath% /unmount %PQSERVICE_LETTER% >> %NAPPLogPath% 2>&1
ECHO [%DATE% %TIME%] %MountPartitionPath% /mountbylabel "PQSERVICE" %PQSERVICE_LETTER% >> %NAPPLogPath% 2>&1
%MountPartitionPath% /mountbylabel "PQSERVICE" %PQSERVICE_LETTER% >> %NAPPLogPath% 2>&1

IF NOT EXIST %PQSERVICE_LETTER%\ (
	ECHO [!DATE! !TIME!] Fail to mount PQSERVICE drive >> %NAPPLogPath% 2>&1
	GOTO ERROR
)
Cscript /nologo GetDiskPartIndex.vbs >> %NAPPLogPath% 2>&1
FOR /f "tokens=1,3,5 delims==- " %%k in ('Cscript /nologo GetDiskPartIndex.vbs') do (
	IF %%k equ %PQSERVICE_LETTER% (
		ECHO [!DATE! !TIME!] DiskIndex of PQSERVICE Partition is %%l >> %NAPPLogPath%
		ECHO [!DATE! !TIME!] PartitionIndex of PQSERVICE Partition is %%m >> %NAPPLogPath%
				
		ECHO sel dis %%l > SetPQSERVICEParActive.txt
		ECHO sel par %%m >> SetPQSERVICEParActive.txt
		ECHO active >> SetPQSERVICEParActive.txt
		
		ECHO [!DATE! !TIME!] diskpart /s SetPQSERVICEParActive.txt >> %NAPPLogPath%
		diskpart /s SetPQSERVICEParActive.txt >> %NAPPLogPath% 2>&1
		IF !errorlevel! equ 0 (
			ECHO [!DATE! !TIME!] Set PQSERVICE Partition active successufully >> %NAPPLogPath%
			GOTO END
		) else (
			ECHO [!DATE! !TIME!] Fail to set PQSERVICE Partition active >> %NAPPLogPath%
			GOTO ERROR
		)
	)
)

:END
ECHO [%DATE% %TIME%] Unmount %VALID_LETTER_1% >> %NAPPLogPath% 2>&1
%MountPartitionPath% /unmount %VALID_LETTER_1% >> %NAPPLogPath% 2>&1
ECHO [%DATE% %TIME%] Unmount %VALID_LETTER_2% >> %NAPPLogPath% 2>&1
%MountPartitionPath% /unmount %VALID_LETTER_2% >> %NAPPLogPath% 2>&1
ECHO [%DATE% %TIME%] Unmount %VALID_LETTER_3% >> %NAPPLogPath% 2>&1
%MountPartitionPath% /unmount %VALID_LETTER_3% >> %NAPPLogPath% 2>&1
ECHO [!DATE! !TIME!][INFO] %0 END >> %NAPPLogPath% 2>&1
popd
exit /b 0
	
:ERROR
ECHO [!DATE! !TIME!][ERROR] %0 ERROR >> %NAPPLogPath% 2>&1
popd
exit /b -1