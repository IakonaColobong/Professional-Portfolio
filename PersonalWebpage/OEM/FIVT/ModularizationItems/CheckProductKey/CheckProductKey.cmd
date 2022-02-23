@echo off
SETLOCAL EnableDelayedExpansion
pushd "%~dp0"

set LogFile="%~dp0"CheckProductKey.log

echo.>>%LogFile%
echo %DATE% %TIME% [Log START]  ============ %~dpnx0 ============
echo %DATE% %TIME% [Log START]  ============ %~dpnx0 ============ >> %LogFile%

if exist *.tag del /s /q *.tag
if exist DISMLog.log del /s /q DISMLog.log

if not exist "C:\OEM\Preload\Command\POP*.ini" (
	echo !DATE! !TIME! [Log TRACE] Not Acer Windows image, skip check
	echo !DATE! !TIME! [Log TRACE] Not Acer Windows image, skip check >> %LogFile%
	goto END
)

:CHECK_OS_VER_THEN_USE
echo %DATE% %TIME% [Log TRACE] Check OS version to see which rule need to be used
echo %DATE% %TIME% [Log TRACE] Check OS version to see which rule need to be used  >> %LogFile%

set OSType=None
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

if %OSver% equ 61 (
	echo !DATE! !TIME! [Log TRACE] This is Windows7  
	echo !DATE! !TIME! [Log TRACE] This is Windows7 >> %LogFile%
	set OSType=W7
	goto CHECK_PRODUCTKEY_BY_OSTYPE
) 
if %OSver% EQU 100 (
	echo !DATE! !TIME! [Log TRACE] This is Windows10, check OS build number
	echo !DATE! !TIME! [Log TRACE] This is Windows10, check OS build number >> %LogFile%
	
	reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v CurrentBuildNumber >> %LogFile%
	for /f "skip=2 tokens=3 delims= " %%v in ('reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v CurrentBuildNumber') do set OSCurrentBuild=%%v
	
	echo !DATE! !TIME! [Log TRACE]  OSCurrentBuild=[!OSCurrentBuild!]
	echo !DATE! !TIME! [Log TRACE]  OSCurrentBuild=[!OSCurrentBuild!] >> %LogFile%
	if !OSCurrentBuild! EQU 17134 (	
		set OSType=W10RS4
		goto CHECK_PRODUCTKEY_BY_OSTYPE
	)
	if !OSCurrentBuild! EQU 17763 (	
		set OSType=W10RS5
		goto CHECK_PRODUCTKEY_BY_OSTYPE
	)
	if !OSCurrentBuild! EQU 18362 (	
		set OSType=W1019H1
		goto CHECK_PRODUCTKEY_BY_OSTYPE
	)
	if !OSCurrentBuild! EQU 18363 (	
		set OSType=W1019H2
		goto CHECK_PRODUCTKEY_BY_OSTYPE
	)
	if !OSCurrentBuild! EQU 19041 (	
		set OSType=W1020H1H2
		goto CHECK_PRODUCTKEY_BY_OSTYPE
	)
	if !OSCurrentBuild! EQU 19042 (	
		set OSType=W1020H1H2
		goto CHECK_PRODUCTKEY_BY_OSTYPE
	)
)

echo %DATE% %TIME% [Log ERROR] Fail, unspecified OS
echo %DATE% %TIME% [Log ERROR] Fail, unspecified OS >> %LogFile%
echo %DATE% %TIME% [Log ERROR] Fail, unspecified OS > Fail.tag
goto END

:CHECK_PRODUCTKEY_BY_OSTYPE
echo %DATE% %TIME% [Log TRACE]  OSType=[%OSType%]
echo %DATE% %TIME% [Log TRACE]  OSType=[%OSType%] >> %LogFile%

call Tools\%OSType%\CheckProductKey_%OSType%.cmd
if exist Tools\%OSType%\Pass.tag (
	echo !DATE! !TIME! [Log TRACE] Pass, product key for %OSType% is valid
	echo !DATE! !TIME! [Log TRACE] Pass, product key for %OSType% is valid >> %LogFile%
	echo !DATE! !TIME! [Log TRACE] Pass, product key for %OSType% is valid > Pass.tag
	goto END
) else (
	echo !DATE! !TIME! [Log ERROR] Fail, product key for %OSType% is invalid
	echo !DATE! !TIME! [Log ERROR] Fail, product key for %OSType% is invalid >> %LogFile%
	echo !DATE! !TIME! [Log ERROR] Fail, product key for %OSType% is invalid > Fail.tag
	goto END
)

:END
echo %DATE% %TIME% [Log LEAVE]  ============ %~dpnx0 ============
echo %DATE% %TIME% [Log LEAVE]  ============ %~dpnx0 ============ >> %LogFile%
echo.>> %LogFile%
popd
SETLOCAL DisableDelayedExpansion