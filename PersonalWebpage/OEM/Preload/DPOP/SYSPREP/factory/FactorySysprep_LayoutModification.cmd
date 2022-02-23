@Echo off
ECHO.>>%LogPath%
ECHO %DATE% %TIME%[Log START]  ============ [SUB]%~dpnx0 ============ >> %LogPath%
pushd "%~dp0"

ECHO [%DATE% %TIME%]  find /i "GCM=Y" C:\OEM\Preload\Command\POP*.ini>>%LogPath% 2>&1
find /i "GCM=Y" C:\OEM\Preload\Command\POP*.ini>>%LogPath% 2>&1
if %ERRORLEVEL% NEQ 0 (
	ECHO !DATE! !TIME![Log TRACE]  Not GCM image, goto :SETLayoutModification >>%LogPath%
	goto :SETLayoutModification
)
ECHO %DATE% %TIME%[Log TRACE]  C:\OEM\PRELOAD\Utility\GCM\MRDCreaterX_%Processor_Architecture%.exe /SM /IMWhiteListPath:c:\OEM\preload\DPOP\GCMReadiness\IM_WhiteList.txt>> %LogPath% 2>&1
C:\OEM\PRELOAD\Utility\GCM\MRDCreaterX_%Processor_Architecture%.exe /SM /IMWhiteListPath:c:\OEM\preload\DPOP\GCMReadiness\IM_WhiteList.txt>> %LogPath% 2>&1
ECHO.>>%LogPath%
ECHO %DATE% %TIME%[Log TRACE]  C:\OEM\PRELOAD\Utility\GCM\MRDCreaterX_%Processor_Architecture%.exe /MF /IMWhiteListPath:c:\OEM\preload\DPOP\GCMReadiness\IM_WhiteList.txt>> %LogPath% 2>&1
C:\OEM\PRELOAD\Utility\GCM\MRDCreaterX_%Processor_Architecture%.exe /MF /IMWhiteListPath:c:\OEM\preload\DPOP\GCMReadiness\IM_WhiteList.txt>> %LogPath% 2>&1
ECHO.>>%LogPath%


:SETLayoutModification
SET S_PerpetualOfficeCase=FALSE
if exist C:\OEM\Preload\Command\POP?????73*.ini SET S_PerpetualOfficeCase=TRUE
if exist C:\OEM\Preload\Command\POP?????74*.ini SET S_PerpetualOfficeCase=TRUE
if exist C:\OEM\Preload\Command\POP?????79*.ini SET S_PerpetualOfficeCase=TRUE
if exist C:\OEM\Preload\Command\POP?????80*.ini SET S_PerpetualOfficeCase=TRUE
if /i "%S_PerpetualOfficeCase%" equ "TRUE" (
	ECHO !DATE! !TIME![Log TRACE]  This is [Pro S] or [EDU S] image, leave the S_PerpetualOfficeCase_TRUE.tag >>%LogPath%
	ECHO !DATE! !TIME![Log TRACE]  This is [Pro S] or [EDU S] image, leave the S_PerpetualOfficeCase_TRUE.tag >S_PerpetualOfficeCase_TRUE.tag
) else (
	ECHO !DATE! !TIME![Log TRACE]  This is not [Pro S] or [EDU S] image, continue... >>%LogPath%
)
ECHO %DATE% %TIME%[Log TRACE]  powershell.exe -noprofile -executionpolicy unrestricted -file GenerateLayoutModification.ps1 >>%LogPath% 2>&1
powershell.exe -noprofile -executionpolicy unrestricted -file GenerateLayoutModification.ps1 >>%LogPath% 2>&1
ECHO %DATE% %TIME%[Log TRACE]  dir /s /b .\PatchLayoutModification\*.cmd>>%LogPath%
dir /s /b .\PatchLayoutModification\*.cmd>>%LogPath%
for /f "delims=" %%P in ('dir /s /b .\PatchLayoutModification\*.cmd') do (
	ECHO !DATE! !TIME![Log TRACE]  call "%%P">>%LogPath% 2>&1
	call "%%P">>%LogPath% 2>&1
)
ECHO %DATE% %TIME%[Log TRACE]  Copy /y LayoutModification.xml c:\Users\Default\AppData\Local\Microsoft\Windows\Shell\LayoutModification.xml  >>%LogPath% 2>&1
Copy /y LayoutModification.xml c:\Users\Default\AppData\Local\Microsoft\Windows\Shell\LayoutModification.xml >>%LogPath% 2>&1
ECHO %DATE% %TIME%[Log TRACE]  Copy /y LayoutModification.xml C:\Recovery\OEM\RestoreOEMCustomize\LayoutModification.xml >>%LogPath% 2>&1
Copy /y LayoutModification.xml C:\Recovery\OEM\RestoreOEMCustomize\LayoutModification.xml >>%LogPath% 2>&1

:END
popd
ECHO %DATE% %TIME%[Log LEAVE]  ============ [SUB]%~dpnx0 ============ >> %LogPath%
ECHO.>>%LogPath%