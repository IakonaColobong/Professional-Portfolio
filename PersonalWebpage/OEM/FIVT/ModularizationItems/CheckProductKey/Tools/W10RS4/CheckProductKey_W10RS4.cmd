@echo off
SETLOCAL EnableDelayedExpansion
pushd "%~dp0"

echo.>>%LogFile%
echo %DATE% %TIME% [Log START]  ============ %~dpnx0 ============
echo %DATE% %TIME% [Log START]  ============ %~dpnx0 ============ >> %LogFile%

if exist *.tag del /s /q *.tag
if exist *.log del /s /q *.log

echo %DATE% %TIME% [Log TRACE] This is Windows10 RS4, check OA3
echo %DATE% %TIME% [Log TRACE] This is Windows10 RS4, check OA3 >> %LogFile%

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
	type oa3tool_result.log | find /i "ProfessionalEducation"		
	if !errorlevel! equ 0 (
		if exist C:\OEM\Preload\Command\POP01???65*.ini (
			echo !DATE! !TIME! [Log ERROR] Fail, OS is PREDU edition but image is W10PR64 image
			echo !DATE! !TIME! [Log ERROR] Fail, OS is PREDU edition but image is W10PR64 image >> %LogFile%
			echo !DATE! !TIME! [Log ERROR] Fail, OS is PREDU edition but image is W10PR64 image > Fail.tag
			type oa3tool_result.log >> Fail.tag
			goto END
		)
		if exist C:\OEM\Preload\Command\POP01???66*.ini (
			echo !DATE! !TIME! [Log ERROR] Fail, OS is PREDU edition but image is W10PR32 image
			echo !DATE! !TIME! [Log ERROR] Fail, OS is PREDU edition but image is W10PR32 image >> %LogFile%
			echo !DATE! !TIME! [Log ERROR] Fail, OS is PREDU edition but image is W10PR32 image > Fail.tag
			type oa3tool_result.log >> Fail.tag
			goto END
		)		
	) else (
		if exist C:\OEM\Preload\Command\POP01???6R*.ini (
			echo !DATE! !TIME! [Log ERROR] Fail, OS is PR edition but image is W10PREDU64 image
			echo !DATE! !TIME! [Log ERROR] Fail, OS is PR edition but image is W10PREDU64 image >> %LogFile%
			echo !DATE! !TIME! [Log ERROR] Fail, OS is PR edition but image is W10PREDU64 image > Fail.tag
			type oa3tool_result.log >> Fail.tag
			goto END
		)
		if exist C:\OEM\Preload\Command\POP01???6T*.ini (
			echo !DATE! !TIME! [Log ERROR] Fail, OS is PR edition but image is W10PREDU32 image
			echo !DATE! !TIME! [Log ERROR] Fail, OS is PR edition but image is W10PREDU32 image >> %LogFile%
			echo !DATE! !TIME! [Log ERROR] Fail, OS is PR edition but image is W10PREDU32 image > Fail.tag
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