
SETLOCAL enableDelayedExpansion
pushd %~dp0
Set LogPath=SetBootFromNAPP.log
Set MountPartition=MountPartition.exe
ECHO [!DATE! !TIME!][INFO] %0 Start >> %LogPath%
echo.>> %LogPath%

REM Get VALID_LETTER_1 VALID_LETTER_2 VALID_LETTER_3
call FindValidDriveLetter.cmd >> %LogPath% 2>&1

type "..\..\SystemCD.dat" | find /i "BootMode=Legacy"
if %errorlevel% equ 0 goto SET_PQSERVICE_TO_ACTIVE

:MOUNT_WIM_DRIVE
	set WIM_LETTER=%VALID_LETTER_1%
	set WIM_PATH=	
	echo WIM_LETTER is %WIM_LETTER% >> %LogPath%
	if "%WIM_LETTER%" equ "" (
		echo Fail to find free drive letter for WIM drive >> %LogPath% 2>&1
		goto ERROR
	)
	MountPartition.exe /unmount %WIM_LETTER% >> %LogPath% 2>&1
	MountPartition.exe /mountbyfile "TempHidden\SCD\Sources\boot.wim" %WIM_LETTER% >> %LogPath% 2>&1
	if "%errorlevel%" equ "0" (
		set WIM_PATH=\TempHidden\SCD\Sources\boot.wim
		echo WIM_PATH is !WIM_PATH! >> %LogPath%
		goto MOUNT_WIM_DRIVE_END
	)
	MountPartition.exe /unmount %WIM_LETTER% >> %LogPath% 2>&1
	MountPartition.exe /mountbyfile "Sources\boot.wim" %WIM_LETTER% >> %LogPath% 2>&1
	if "%errorlevel%" equ "0" (
		set WIM_PATH=\Sources\boot.wim
		echo WIM_PATH is !WIM_PATH! >> %LogPath%
		goto MOUNT_WIM_DRIVE_END
	)
	IF NOT EXIST %WIM_LETTER%\ (
		echo Fail to mount WIM drive >> %LogPath% 2>&1
		goto ERROR
	)
:MOUNT_WIM_DRIVE_END

:MOUNT_SDI_DRIVE
	set SDI_LETTER=%VALID_LETTER_2%
	set SDI_PATH=
	echo SDI_LETTER is %SDI_LETTER% >> %LogPath%
	if "%SDI_LETTER%" equ "" (
		echo Fail to find free drive letter for SDI drive >> %LogPath% 2>&1
		goto ERROR
	)
	MountPartition.exe /unmount %SDI_LETTER% >> %LogPath% 2>&1
	MountPartition.exe /mountbyfile "TempHidden\SCD\boot\boot.sdi" %SDI_LETTER% >> %LogPath% 2>&1
	if "%errorlevel%" equ "0" (
		set SDI_PATH=\TempHidden\SCD\boot\boot.sdi
		echo SDI_PATH is !SDI_PATH! >> %LogPath%
		goto MOUNT_SDI_DRIVE_END
	)
	MountPartition.exe /unmount %SDI_LETTER% >> %LogPath% 2>&1
	MountPartition.exe /mountbyfile "boot\boot.sdi" %SDI_LETTER% >> %LogPath% 2>&1
	if "%errorlevel%" equ "0" (
		set SDI_PATH=\boot\boot.sdi
		echo SDI_PATH is !SDI_PATH! >> %LogPath%
		goto MOUNT_SDI_DRIVE_END
	)
	IF NOT EXIST %SDI_LETTER%\ (
		echo Fail to mount SDI drive >> %LogPath% 2>&1
		goto ERROR
	)
:MOUNT_SDI_DRIVE_END

:MOUNT_EFI_DRIVE
	set EFI_LETTER=%VALID_LETTER_3%
	set EFI_PATH=
	echo EFI_LETTER is %EFI_LETTER% >> %LogPath%
	if "%EFI_LETTER%" equ "" (
		echo Fail to find free drive letter for EFI drive >> %LogPath% 2>&1
		goto ERROR
	)
	MountPartition.exe /unmount %EFI_LETTER% >> %LogPath% 2>&1
	MountPartition.exe /mountbylabel ESP %EFI_LETTER% >> %LogPath% 2>&1
	if not exist %EFI_LETTER%\ (
		echo Fail to mount EFI drive >> %LogPath% 2>&1
		goto ERROR
	)
:MOUNT_EFI_DRIVE_END

:COPY_EFI
robocopy ..\..\EFI %EFI_LETTER%\EFI /mir >> %LogPath% 2>&1
IF NOT EXIST %EFI_LETTER%\EFI\Microsoft\Boot\BCD (
	echo Fail to find %EFI_LETTER%\EFI\Microsoft\Boot\BCD in ESP drive >> %LogPath% 2>&1
	goto ERROR
)
IF NOT EXIST %EFI_LETTER%\EFI\Microsoft\Boot\bootmgfw.efi (
	echo Fail to find %EFI_LETTER%\EFI\Microsoft\Boot\bootmgfw.efi in ESP drive >> %LogPath% 2>&1
	goto ERROR
)
set EFI_PATH=\EFI\Microsoft\Boot\bootmgfw.efi

:BCDEDIT_START
echo set WINPE_GUID={572bcd56-ffa7-11d9-aae0-0007e994107d} >> %LogPath% 2>&1
set WINPE_GUID={572bcd56-ffa7-11d9-aae0-0007e994107d} >> %LogPath% 2>&1

echo bcdedit /store %EFI_LETTER%\EFI\Microsoft\Boot\BCD -delete {default} /cleanup >> %LogPath% 2>&1
bcdedit /store %EFI_LETTER%\EFI\Microsoft\Boot\BCD -delete {default} /cleanup >> %LogPath% 2>&1

echo bcdedit /store %EFI_LETTER%\EFI\Microsoft\Boot\BCD -set {bootmgr} device partition=%EFI_LETTER% >> %LogPath% 2>&1
bcdedit /store %EFI_LETTER%\EFI\Microsoft\Boot\BCD -set {bootmgr} device partition=%EFI_LETTER% >> %LogPath% 2>&1

echo bcdedit /store %EFI_LETTER%\EFI\Microsoft\Boot\BCD -set {bootmgr} path %EFI_PATH% >> %LogPath% 2>&1
bcdedit /store %EFI_LETTER%\EFI\Microsoft\Boot\BCD -set {bootmgr} path %EFI_PATH% >> %LogPath% 2>&1

echo bcdedit /store %EFI_LETTER%\EFI\Microsoft\Boot\BCD -set {bootmgr} timeout 0 >> %LogPath% 2>&1
bcdedit /store %EFI_LETTER%\EFI\Microsoft\Boot\BCD -set {bootmgr} timeout 0 >> %LogPath% 2>&1

echo bcdedit /store %EFI_LETTER%\EFI\Microsoft\BOOT\BCD -create %WINPE_GUID% /d "Acer Recovery Management" -application osloader >> %LogPath% 2>&1
bcdedit /store %EFI_LETTER%\EFI\Microsoft\BOOT\BCD -create %WINPE_GUID% /d "Acer Recovery Management" -application osloader >> %LogPath% 2>&1

echo bcdedit /store %EFI_LETTER%\EFI\Microsoft\BOOT\BCD -create {ramdiskoptions} /d "Acer Recovery Management" >> %LogPath% 2>&1
bcdedit /store %EFI_LETTER%\EFI\Microsoft\BOOT\BCD -create {ramdiskoptions} /d "Acer Recovery Management" >> %LogPath% 2>&1

echo bcdedit /store %EFI_LETTER%\EFI\Microsoft\BOOT\BCD -set %WINPE_GUID% device ramdisk=[%WIM_LETTER%]%WIM_PATH%,{ramdiskoptions} >> %LogPath% 2>&1
bcdedit /store %EFI_LETTER%\EFI\Microsoft\BOOT\BCD -set %WINPE_GUID% device ramdisk=[%WIM_LETTER%]%WIM_PATH%,{ramdiskoptions} >> %LogPath% 2>&1

echo bcdedit /store %EFI_LETTER%\EFI\Microsoft\BOOT\BCD -set %WINPE_GUID% path \windows\system32\winload.efi >> %LogPath% 2>&1
bcdedit /store %EFI_LETTER%\EFI\Microsoft\BOOT\BCD -set %WINPE_GUID% path \windows\system32\winload.efi >> %LogPath% 2>&1

echo bcdedit /store %EFI_LETTER%\EFI\Microsoft\BOOT\BCD -set %WINPE_GUID% osdevice ramdisk=[%WIM_LETTER%]%WIM_PATH%,{ramdiskoptions}  >> %LogPath% 2>&1
bcdedit /store %EFI_LETTER%\EFI\Microsoft\BOOT\BCD -set %WINPE_GUID% osdevice ramdisk=[%WIM_LETTER%]%WIM_PATH%,{ramdiskoptions}  >> %LogPath% 2>&1

echo bcdedit /store %EFI_LETTER%\EFI\Microsoft\BOOT\BCD -set %WINPE_GUID% systemroot \windows >> %LogPath% 2>&1
bcdedit /store %EFI_LETTER%\EFI\Microsoft\BOOT\BCD -set %WINPE_GUID% systemroot \windows >> %LogPath% 2>&1

echo bcdedit /store %EFI_LETTER%\EFI\Microsoft\BOOT\BCD -set %WINPE_GUID% winpe yes >> %LogPath% 2>&1
bcdedit /store %EFI_LETTER%\EFI\Microsoft\BOOT\BCD -set %WINPE_GUID% winpe yes >> %LogPath% 2>&1

echo bcdedit /store %EFI_LETTER%\EFI\Microsoft\BOOT\BCD -set %WINPE_GUID% nx optin >> %LogPath% 2>&1
bcdedit /store %EFI_LETTER%\EFI\Microsoft\BOOT\BCD -set %WINPE_GUID% nx optin >> %LogPath% 2>&1

echo bcdedit /store %EFI_LETTER%\EFI\Microsoft\BOOT\BCD -set %WINPE_GUID% detecthal yes >> %LogPath% 2>&1
bcdedit /store %EFI_LETTER%\EFI\Microsoft\BOOT\BCD -set %WINPE_GUID% detecthal yes >> %LogPath% 2>&1

echo bcdedit /store %EFI_LETTER%\EFI\Microsoft\BOOT\BCD -displayorder %WINPE_GUID% -addfirst >> %LogPath% 2>&1
bcdedit /store %EFI_LETTER%\EFI\Microsoft\BOOT\BCD -displayorder %WINPE_GUID% -addfirst >> %LogPath% 2>&1

echo bcdedit /store %EFI_LETTER%\EFI\Microsoft\BOOT\BCD -set {ramdiskoptions} ramdisksdidevice partition=%SDI_LETTER% >> %LogPath% 2>&1
bcdedit /store %EFI_LETTER%\EFI\Microsoft\BOOT\BCD -set {ramdiskoptions} ramdisksdidevice partition=%SDI_LETTER% >> %LogPath% 2>&1

echo bcdedit /store %EFI_LETTER%\EFI\Microsoft\BOOT\BCD -set {ramdiskoptions} ramdisksdipath %SDI_PATH% >> %LogPath% 2>&1
bcdedit /store %EFI_LETTER%\EFI\Microsoft\BOOT\BCD -set {ramdiskoptions} ramdisksdipath %SDI_PATH% >> %LogPath% 2>&1

echo bcdedit /store %EFI_LETTER%\EFI\Microsoft\BOOT\BCD /default %WINPE_GUID% >> %LogPath% 2>&1
bcdedit /store %EFI_LETTER%\EFI\Microsoft\BOOT\BCD /default %WINPE_GUID% >> %LogPath% 2>&1
goto END

:SET_PQSERVICE_TO_ACTIVE
set PQSERVICE_LETTER=%VALID_LETTER_1%
ECHO [%DATE% %TIME%] MountPartition.exe /unmount %PQSERVICE_LETTER% >> %LogPath% 2>&1	
MountPartition.exe /unmount %PQSERVICE_LETTER% >> %LogPath% 2>&1
ECHO [%DATE% %TIME%] MountPartition.exe /mountbylabel "PQSERVICE" %PQSERVICE_LETTER% >> %LogPath% 2>&1
MountPartition.exe /mountbylabel "PQSERVICE" %PQSERVICE_LETTER% >> %LogPath% 2>&1

IF NOT EXIST %PQSERVICE_LETTER%\ (
	ECHO [!DATE! !TIME!] Fail to mount PQSERVICE drive >> %LogPath% 2>&1
	GOTO ERROR
)
Cscript /nologo GetDiskPartIndex.vbs >> %LogPath% 2>&1
FOR /f "tokens=1,3,5 delims==- " %%k in ('Cscript /nologo GetDiskPartIndex.vbs') do (
	IF %%k equ %PQSERVICE_LETTER% (
		ECHO [!DATE! !TIME!] DiskIndex of PQSERVICE Partition is %%l >> %LogPath%
		ECHO [%DATE% %TIME%] PartitionIndex of PQSERVICE Partition is %%m >> %LogPath%
				
		ECHO sel dis %%l > SetPQSERVICEParActive.txt
		ECHO sel par %%m >> SetPQSERVICEParActive.txt
		ECHO active >> SetPQSERVICEParActive.txt
		
		ECHO [%DATE% %TIME%] diskpart /s SetPQSERVICEParActive.txt >> %LogPath%
		diskpart /s SetPQSERVICEParActive.txt >> %LogPath% 2>&1
		IF !errorlevel! equ 0 (
			ECHO [%DATE% %TIME%] Set PQSERVICE Partition active successufully >> %LogPath%
			GOTO END
		) else (
			ECHO [%DATE% %TIME%] Fail to set PQSERVICE Partition active >> %LogPath%
			GOTO ERROR
		)
	)
)

:END
echo Unmount %VALID_LETTER_1% >> %LogPath% 2>&1
MountPartition.exe /unmount %VALID_LETTER_1% >> %LogPath% 2>&1
echo Unmount %VALID_LETTER_2% >> %LogPath% 2>&1
MountPartition.exe /unmount %VALID_LETTER_2% >> %LogPath% 2>&1
echo Unmount %VALID_LETTER_3% >> %LogPath% 2>&1
MountPartition.exe /unmount %VALID_LETTER_3% >> %LogPath% 2>&1
ECHO [!DATE! !TIME!][INFO] %0 END >> %LogPath% 2>&1
popd
exit /b 0

:ERROR
ECHO [!DATE! !TIME!][ERROR] %0 ERROR >> %LogPath% 2>&1
popd
exit /b -1