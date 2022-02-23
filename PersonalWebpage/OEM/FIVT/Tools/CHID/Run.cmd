@echo off
SETLOCAL EnableDelayedExpansion
pushd "%~dp0"

set LogFile="%~dp0"CHID.log

echo.>>%LogFile%
echo %DATE% %TIME% [Log START]  ============ %~dpnx0 ============
echo %DATE% %TIME% [Log START]  ============ %~dpnx0 ============ >> %LogFile%

if exist *.tag del /s /q *.tag
if exist *.log del /s /q *.log

if not exist "C:\OEM\Preload\Command\POP*.ini" (
    echo !DATE! !TIME! [Log TRACE] Not Acer Windows image, skip check
    echo !DATE! !TIME! [Log TRACE] Not Acer Windows image, skip check >> %LogFile%
    goto END
)

echo %DATE% %TIME% [Log TRACE] find CPU type from "C:\OEM\Preload\Command\PAP\PAP*.ini"
echo %DATE% %TIME% [Log TRACE] find CPU type from "C:\OEM\Preload\Command\PAP\PAP*.ini" >> %LogFile%
find /i "CPU=" "C:\OEM\Preload\Command\PAP\PAP*.ini" > C:\OEM\FIVT\Tools\CHID\CPUInfo.txt
for /f "tokens=2 delims==" %%f in (C:\OEM\FIVT\Tools\CHID\CPUInfo.txt) do (
    set CPU_Type=%%f
    echo CPU Type=[!CPU_Type!]
    echo CPU Type=[!CPU_Type!] >> %LogFile%
)

:CHECK_CHID_BY_Processor_architecture

echo %DATE% %TIME% [Log TRACE] Processor_architecture is [!CPU_Type!] 
echo %DATE% %TIME% [Log TRACE] Processor_architecture is [!CPU_Type!] >> %LogFile%
echo %DATE% %TIME% [Log TRACE] "call !CPU_Type!\computerhardwareids.exe
echo %DATE% %TIME% [Log TRACE] "call !CPU_Type!\computerhardwareids.exe > ComputerHardwareIDs.txt" >> %LogFile% 
call !CPU_Type!\computerhardwareids.exe > ComputerHardwareIDs.txt 2>&1

goto END


:END
echo %DATE% %TIME% [Log LEAVE]  ============ %~dpnx0 ============
echo %DATE% %TIME% [Log LEAVE]  ============ %~dpnx0 ============ >> %LogFile%
echo.>> %LogFile%
popd
SETLOCAL DisableDelayedExpansion