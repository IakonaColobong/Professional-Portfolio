@ECHO off
ECHO.
ECHO %DATE% %TIME%[Log START]  ============ [SUB]%~dpnx0 ============
Pushd %~dp0
:START
ECHO %DATE% %TIME%[Log TRACE]  Execute DetectFirmwareInterface_%Processor_Architecture%.exe
start /w DetectFirmwareInterface_%Processor_Architecture%.exe
if %errorlevel% EQU 0 (
	ECHO !DATE! !TIME![Log TRACE]  This is Legacy BIOS
	ECHO !DATE! !TIME![Log TRACE]  This is Legacy BIOS >C:\OEM\Preload\BIOS_Legacy.tag
) else if %errorlevel% EQU 1 (
	ECHO !DATE! !TIME![Log TRACE]  This is UEFI BIOS
	ECHO !DATE! !TIME![Log TRACE]  This is UEFI BIOS >C:\OEM\Preload\BIOS_UEFI.tag
) else (
	ECHO !DATE! !TIME![Log TRACE]  ERROR! ERROR! ERROR! Can't be detect FirmwareInterface
)
:END
Popd
ECHO %DATE% %TIME%[Log LEAVE]  ============ [SUB]%~dpnx0 ============
ECHO.