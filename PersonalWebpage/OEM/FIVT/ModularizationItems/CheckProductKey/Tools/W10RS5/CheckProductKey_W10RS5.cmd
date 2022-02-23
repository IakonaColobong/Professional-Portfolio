@echo off
SETLOCAL EnableDelayedExpansion
pushd "%~dp0"

echo.>>%LogFile%
echo %DATE% %TIME% [Log START]  ============ %~dpnx0 ============
echo %DATE% %TIME% [Log START]  ============ %~dpnx0 ============ >> %LogFile%

if exist *.tag del /s /q *.tag
if exist *.log del /s /q *.log

echo %DATE% %TIME% [Log TRACE] This is Windows10 RS5, check OA3
echo %DATE% %TIME% [Log TRACE] This is Windows10 RS5, check OA3 >> %LogFile%

CheckOA3_%processor_architecture%.dat > oa3tool_result.log
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

echo.>> oa3tool_result.log
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
	type oa3tool_result.log | find /i "Edition of the product key" | find /i "Professional in S mode"
	if !errorlevel! equ 0 (
		if not exist C:\OEM\Preload\Command\POP01???73*.ini if not exist C:\OEM\Preload\Command\POP01???74*.ini (
			echo !DATE! !TIME! [Log ERROR] Fail, BIOS key is PRS edition but image is not W10PRS image
			echo !DATE! !TIME! [Log ERROR] Fail, BIOS key is PRS edition but image is not W10PRS image >> %LogFile%
			echo !DATE! !TIME! [Log ERROR] Fail, BIOS key is PRS edition but image is not W10PRS image > Fail.tag
			type oa3tool_result.log >> Fail.tag
			goto END
		)
	) 
	type oa3tool_result.log | find /i "Edition of the product key" | find /i "ProfessionalEducation in S mode"
	if !errorlevel! equ 0 (
		if not exist C:\OEM\Preload\Command\POP01???79*.ini if not exist C:\OEM\Preload\Command\POP01???80*.ini (
			echo !DATE! !TIME! [Log ERROR] Fail, BIOS key is PREDUS edition but image is not W10SPREDU image
			echo !DATE! !TIME! [Log ERROR] Fail, BIOS key is PREDUS edition but image is not W10SPREDU image >> %LogFile%
			echo !DATE! !TIME! [Log ERROR] Fail, BIOS key is PREDUS edition but image is not W10SPREDU image > Fail.tag
			type oa3tool_result.log >> Fail.tag
			goto END
		)
	)
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