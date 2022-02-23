@echo off
SETLOCAL EnableDelayedExpansion
pushd "%~dp0"

echo.>>%LogFile%
echo %DATE% %TIME% [Log START]  ============ %~dpnx0 ============
echo %DATE% %TIME% [Log START]  ============ %~dpnx0 ============ >> %LogFile%

if exist *.tag del /s /q *.tag
if exist *.log del /s /q *.log

echo %DATE% %TIME% [Log TRACE] This is Windows10 19H1, check OA3
echo %DATE% %TIME% [Log TRACE] This is Windows10 19H1, check OA3 >> %LogFile%

echo %DATE% %TIME% [Log TRACE] "%~dp0"oa3tool\%Processor_architecture%\oa3tool.exe /Validate >> %LogFile%
oa3tool\%Processor_architecture%\oa3tool.exe /Validate > oa3tool_result.log
if %errorlevel% equ 0 (
	echo !DATE! !TIME! [Log TRACE] Return code is [%errorlevel%], MSDM table validation pass
	echo !DATE! !TIME! [Log TRACE] Return code is [%errorlevel%], MSDM table validation pass >> %LogFile%
) else (
	echo !DATE! !TIME! [Log ERROR] Fail, return code is [%errorlevel%], MSDM table validation fail
	echo !DATE! !TIME! [Log ERROR] Fail, return code is [%errorlevel%], MSDM table validation fail >> %LogFile%
	echo !DATE! !TIME! [Log ERROR] Fail, return code is [%errorlevel%], MSDM table validation fail > Fail.tag
	type oa3tool_result.log >> Fail.tag
	goto END
)

rem 20191030 remove
rem dir /b ..\..\*.dat >> %LogFile% 2>&1
rem if not exist ..\..\*.dat (
rem 	echo !DATE! !TIME! [Log TRACE]  ..\..\*.dat not found, goto OA3_CHECKEDITION_ONLINE >> %LogFile%
rem 	goto OA3_CHECKEDITION_ONLINE
rem )

rem for /f "tokens=1 delims=." %%J in ('dir /b ..\..\*.dat') do echo %%J > CurrentOSType.txt
rem echo !DATE! !TIME! [Log TRACE] Type CurrentOSType.txt >> %LogFile% 2>&1
rem type CurrentOSType.txt >> %LogFile% 2>&1
rem for /f "delims=" %%l in (Skip_OSType_List.txt) do (
rem 	echo !DATE! !TIME! [Log TRACE]  find /i "%%l" CurrentOSType.txt >> %LogFile% 2>&1
rem 	find /i "%%l" CurrentOSType.txt >> %LogFile% 2>&1
rem 	if !errorlevel! equ 0 (
rem 		echo !DATE! !TIME! [Log TRACE] Pass, found specific OS, no need to check productkey
rem 		echo !DATE! !TIME! [Log TRACE] Pass, found specific OS, no need to check productkey >> %LogFile%
rem 		echo !DATE! !TIME! [Log TRACE] Pass, found specific OS, no need to check productkey > Pass.tag	
rem 		goto END
rem 	)
rem )

:OA3_CHECKEDITION_ONLINE
echo.>> oa3tool_result.log
echo %DATE% %TIME% [Log TRACE] "%~dp0"oa3tool\%Processor_architecture%\oa3tool.exe /CheckEdition /Online >> %LogFile%
oa3tool\%Processor_architecture%\oa3tool.exe /CheckEdition /Online >> oa3tool_result.log
if %errorlevel% equ 0 (
	rem type oa3tool_result.log | find /i "Edition of the product key" | find /i "ProfessionalEducation"
	rem if !errorlevel! equ 0 (
	rem		if not exist C:\OEM\Preload\Command\POP01???6R*.ini if not exist C:\OEM\Preload\Command\POP01???6T*.ini (
	rem			echo !DATE! !TIME! [Log ERROR] Fail, BIOS key is PREDU edition but image is not W10PREDU image
	rem			echo !DATE! !TIME! [Log ERROR] Fail, BIOS key is PREDU edition but image is not W10PREDU image >> %LogFile%
	rem			echo !DATE! !TIME! [Log ERROR] Fail, BIOS key is PREDU edition but image is not W10PREDU image > Fail.tag
	rem			type oa3tool_result.log >> Fail.tag
	rem			goto END
	rem		)
	rem )	
	echo !DATE! !TIME! [Log TRACE] Pass, product key matches the edition of Windows 
	echo !DATE! !TIME! [Log TRACE] Pass, product key matches the edition of Windows  >> %LogFile%
	echo !DATE! !TIME! [Log TRACE] Pass, product key matches the edition of Windows  > Pass.tag		
) else (
	echo !DATE! !TIME! [Log ERROR] Fail, oa3tool return code is not 0, product key does not match the edition of windows
	echo !DATE! !TIME! [Log ERROR] Fail, oa3tool return code is not 0, product key does not match the edition of windows >> %LogFile%
	echo !DATE! !TIME! [Log ERROR] Fail, oa3tool return code is not 0, product key does not match the edition of windows > Fail.tag
	type oa3tool_result.log >> Fail.tag
)

:END
echo %DATE% %TIME% [Log LEAVE]  ============ %~dpnx0 ============
echo %DATE% %TIME% [Log LEAVE]  ============ %~dpnx0 ============ >> %LogFile%
echo.>> %LogFile%
popd
SETLOCAL DisableDelayedExpansion