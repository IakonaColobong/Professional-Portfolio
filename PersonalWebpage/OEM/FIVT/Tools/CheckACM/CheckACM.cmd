@echo off
SETLOCAL EnableDelayedExpansion
pushd "%~dp0"

set LogFile=CheckACM.log

echo.>>%LogFile%
echo %DATE% %TIME% [Log START]  ============ %~dpnx0 ============
echo %DATE% %TIME% [Log START]  ============ %~dpnx0 ============ >> %LogFile%

if exist *.tag del /s /q *.tag

if not exist "C:\OEM\Preload\Command\POP*.ini" (
	echo !DATE! !TIME! [Log TRACE] Not Acer Windows image, skip check
	echo !DATE! !TIME! [Log TRACE] Not Acer Windows image, skip check >> %LogFile%
	goto END
)

echo %DATE% %TIME% [Log TRACE] Check ImageType
echo %DATE% %TIME% [Log TRACE] Check ImageType >> %LogFile%
set ImageType=NB
for /f "tokens=3" %%a in ('reg query "HKLM\Software\OEM\Metadata" /v Sys') do set KeyName=%%a
echo %DATE% %TIME% [Log TRACE] KeyName is %KeyName%
echo %DATE% %TIME% [Log TRACE] KeyName is %KeyName% >> %LogFile%
if %KeyName% equ DTP set ImageType=DT
echo %DATE% %TIME% [Log TRACE] This is %ImageType% image
echo %DATE% %TIME% [Log TRACE] This is %ImageType% image >> %LogFile%

if %ImageType% equ NB (
	echo !DATE! !TIME! [Log TRACE] Pass, no need to check ACM for NB image
	echo !DATE! !TIME! [Log TRACE] Pass, no need to check ACM for NB image >> %LogFile%
	echo !DATE! !TIME! [Log TRACE] Pass, no need to check ACM for NB image > Pass.tag
	goto END
)

if not exist CurrentExtraAP.txt (
	echo !DATE! !TIME! [Log ERROR] Fail, cannot find CurrentExtraAP.txt
	echo !DATE! !TIME! [Log ERROR] Fail, cannot find CurrentExtraAP.txt >> %LogFile%
	echo !DATE! !TIME! [Log ERROR] Fail, cannot find CurrentExtraAP.txt > Fail.tag
	goto END
) else (
	echo !DATE! !TIME! [Log TRACE] Current ExtraAP is
	echo !DATE! !TIME! [Log TRACE] Current ExtraAP is >> %LogFile%
	type CurrentExtraAP.txt
	echo.
	type CurrentExtraAP.txt >> %LogFile%
	echo.>>%LogFile%
)

set ExtraAPisACM=False
for /f "delims=" %%a in (ExtraAP_ACM_List.txt) do (
	echo !DATE! !TIME![Log TRACE] find /i "%%a" CurrentExtraAP.txt
	echo !DATE! !TIME![Log TRACE] find /i "%%a" CurrentExtraAP.txt >> %LogFile%
	find /i "%%a" CurrentExtraAP.txt >> %LogFile% 2>&1
	if !errorlevel! equ 0 (
		set ExtraAPisACM=True
		goto :CHECK_ACM_EXISTENCE
	)
)

:CHECK_ACM_EXISTENCE
if %ExtraAPisACM% equ True (
	echo !DATE! !TIME! [Log TRACE] ExtraAP contains ACM, ACM should exist
	echo !DATE! !TIME! [Log TRACE] ExtraAP contains ACM, ACM should exist >> %LogFile%
	if exist "%ProgramFiles(x86)%\Acer\Acer Classroom Manager" (
		echo !DATE! !TIME! [Log TRACE] Pass, ACM should exist and it exists
		echo !DATE! !TIME! [Log TRACE] Pass, ACM should exist and it exists >> %LogFile%
		echo !DATE! !TIME! [Log TRACE] Pass, ACM should exist and it exists > Pass.tag
	) else (
		echo !DATE! !TIME! [Log ERROR] Fail, ACM should exist but it doesn't exist
		echo !DATE! !TIME! [Log ERROR] Fail, ACM should exist but it doesn't exist >> %LogFile%
		echo !DATE! !TIME! [Log ERROR] Fail, ACM should exist but it doesn't exist > Fail.tag
	)
) else (
	echo !DATE! !TIME! [Log TRACE] ExtraAP doesn't contain ACM, ACM should not exist
	echo !DATE! !TIME! [Log TRACE] ExtraAP doesn't contain ACM, ACM should not exist >> %LogFile%
	if exist "%ProgramFiles(x86)%\Acer\Acer Classroom Manager" (
		echo !DATE! !TIME! [Log ERROR] Fail, ACM should not exist but it exists
		echo !DATE! !TIME! [Log ERROR] Fail, ACM should not exist but it exists >> %LogFile%
		echo !DATE! !TIME! [Log ERROR] Fail, ACM should not exist but it exists > Fail.tag
	) else (
		echo !DATE! !TIME! [Log TRACE] Pass, ACM should not exist and it doesn't exist
		echo !DATE! !TIME! [Log TRACE] Pass, ACM should not exist and it doesn't exist >> %LogFile%
		echo !DATE! !TIME! [Log TRACE] Pass, ACM should not exist and it doesn't exist > Pass.tag
	)
)

:END
echo %DATE% %TIME% [Log LEAVE]  ============ %~dpnx0 ============
echo %DATE% %TIME% [Log LEAVE]  ============ %~dpnx0 ============ >> %LogFile%
echo.>>%LogFile%
popd
SETLOCAL DisableDelayedExpansion
