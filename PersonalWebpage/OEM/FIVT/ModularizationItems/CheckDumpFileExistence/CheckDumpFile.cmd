@echo off
SETLOCAL EnableDelayedExpansion
pushd "%~dp0"

set LogFile=CheckDumpFile.log

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

if exist C:\Windows\MEMORY.DMP (
	echo !DATE! !TIME! [Log ERROR] Fail, C:\Windows\MEMORY.DMP exists
	echo !DATE! !TIME! [Log ERROR] Fail, C:\Windows\MEMORY.DMP exists >> %LogFile%
	echo !DATE! !TIME! [Log ERROR] Fail, C:\Windows\MEMORY.DMP exists > FailReason.txt
)

if exist C:\Windows\Minidump\*.dmp (
	echo !DATE! !TIME! [Log ERROR] Fail, C:\Windows\Minidump\*.dmp exist:
	dir /s /b C:\Windows\Minidump\*.DMP
	echo !DATE! !TIME! [Log ERROR] Fail, C:\Windows\Minidump\*.dmp exist: >> %LogFile%
	dir /s /b C:\Windows\Minidump\*.DMP >> %LogFile%
	echo !DATE! !TIME! [Log ERROR] Fail, C:\Windows\Minidump\*.dmp exist >> FailReason.txt
	dir /s /b C:\Windows\Minidump\*.DMP >> FailReason.txt
)
if exist FailReason.txt (
	echo !DATE! !TIME! [Log ERROR] Fail, some dump files exist
	echo !DATE! !TIME! [Log ERROR] Fail, some dump files exist >> %LogFile%
	echo !DATE! !TIME! [Log ERROR] Fail, some dump files exist > Fail.tag
) else (
	echo !DATE! !TIME! [Log TRACE] Pass, no any dump file exists 
	echo !DATE! !TIME! [Log TRACE] Pass, no any dump file exists  >> %LogFile%
	echo !DATE! !TIME! [Log TRACE] Pass, no any dump file exists  > Pass.tag
)

:END
echo %DATE% %TIME% [Log LEAVE]  ============ %~dpnx0 ============
echo %DATE% %TIME% [Log LEAVE]  ============ %~dpnx0 ============ >> %LogFile%
echo.>>%LogFile%
popd
SETLOCAL DisableDelayedExpansion