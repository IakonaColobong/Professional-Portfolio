@echo off
SETLOCAL EnableDelayedExpansion
pushd "%~dp0"

set LogFile=CheckGCMtags.log

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

if exist C:\OEM\Preload\InstalledApps (
	for %%j in (NA, SS, TB, MF) do (
		if exist C:\OEM\Preload\InstalledApps\%%j (
			for /f %%k in ('dir /b C:\OEM\Preload\InstalledApps\%%j\*.tag') do (
				powershell -executionpolicy bypass -File CheckFileEmpty.ps1 C:\OEM\Preload\InstalledApps\%%j\%%k | find /i "File is not blank"
				if !errorlevel! equ 0 (
					echo !DATE! !TIME! [Log TRACE] C:\OEM\Preload\InstalledApps\%%j\%%k has non-empty contents
					echo !DATE! !TIME! [Log TRACE] C:\OEM\Preload\InstalledApps\%%j\%%k has non-empty contents >> %LogFile%
				) else (
					echo !DATE! !TIME! [Log ERROR] Fail, C:\OEM\Preload\InstalledApps\%%j\%%k has empty contents
					echo !DATE! !TIME! [Log ERROR] Fail, C:\OEM\Preload\InstalledApps\%%j\%%k has empty contents >> %LogFile%
					echo !DATE! !TIME! [Log ERROR] Fail, C:\OEM\Preload\InstalledApps\%%j\%%k has empty contents >> EmptyTagList.txt
				)
			)
		)
	)
	if exist EmptyTagList.txt (
		echo !DATE! !TIME! [Log ERROR] Fail, some tags has empty contents
		echo !DATE! !TIME! [Log ERROR] Fail, some tags has empty contents >> %LogFile%
		echo !DATE! !TIME! [Log ERROR] Fail, some tags has empty contents > Fail.tag
	) else (
		echo !DATE! !TIME! [Log TRACE] Pass, all tags have non-empty contents
		echo !DATE! !TIME! [Log TRACE] Pass, all tags have non-empty contents >> %LogFile%
		echo !DATE! !TIME! [Log TRACE] Pass, all tags have non-empty contents > Pass.tag
	)
) else (
	echo !DATE! !TIME! [Log TRACE] Pass, C:\OEM\Preload\InstalledApps not exists, no need to check GCM tags  
	echo !DATE! !TIME! [Log TRACE] Pass, C:\OEM\Preload\InstalledApps not exists, no need to check GCM tags >> %LogFile%
	echo !DATE! !TIME! [Log TRACE] Pass, C:\OEM\Preload\InstalledApps not exists, no need to check GCM tags > Pass.tag
)

:END
echo %DATE% %TIME% [Log LEAVE]  ============ %~dpnx0 ============
echo %DATE% %TIME% [Log LEAVE]  ============ %~dpnx0 ============ >> %LogFile%
echo.>>%LogFile%
popd
SETLOCAL DisableDelayedExpansion