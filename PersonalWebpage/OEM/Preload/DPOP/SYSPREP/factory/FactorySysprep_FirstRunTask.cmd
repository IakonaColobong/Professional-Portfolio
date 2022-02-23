
@Echo off
ECHO.>>%LogPath%
ECHO %DATE% %TIME%[Log START]  ============ [SUB]%~dpnx0 ============ >> %LogPath%
pushd "%~dp0"
SETLOCAL EnableDelayedExpansion

if not exist .\FirstRunTask\AUMID*.txt ECHO %DATE% %TIME%[Log TRACE]  .\FirstRunTask\AUMID*.txt not found, goto :END>>%LogPath% && goto :END
ECHO %DATE% %TIME%[Log TRACE]  dir /s /b .\FirstRunTask\AUMID*.txt>>%LogPath%
dir /s /b .\FirstRunTask\AUMID*.txt>>%LogPath%

ECHO %DATE% %TIME%[Log TRACE]  powershell -executionpolicy bypass -command "%CD%\GenerateFirstRunTask.ps1 %CD%\FirstRunTask.xml">>%LogPath% 2>&1
powershell -executionpolicy bypass -command "%CD%\GenerateFirstRunTask.ps1 %CD%\FirstRunTask.xml">>%LogPath% 2>&1
ECHO %DATE% %TIME%[Log TRACE]  CScript.exe /nologo __MRD_MergeWithSysprepXML.vbs FirstRunTask.xml Sysprep.xml>>%LogPath%
CScript.exe /nologo __MRD_MergeWithSysprepXML.vbs FirstRunTask.xml Sysprep.xml>>%LogPath% 2>&1
ECHO %DATE% %TIME%[Log TRACE]  powershell -ExecutionPolicy ByPass -command "C:\OEM\Preload\DPOP\Sysprep\_RemoveXMLUnwantNS.ps1 \"Sysprep.xml\"" >> %LogPath% 2>&1
powershell -ExecutionPolicy ByPass -command "C:\OEM\Preload\DPOP\Sysprep\_RemoveXMLUnwantNS.ps1 \"Sysprep.xml\"" >> %LogPath% 2>&1

:END
ENDLOCAL DisableDelayedExpansion
popd
ECHO %DATE% %TIME%[Log LEAVE]  ============ [SUB]%~dpnx0 ============ >> %LogPath%
ECHO.>>%LogPath%