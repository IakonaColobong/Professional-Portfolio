
@Echo off
ECHO.
ECHO %DATE% %TIME%[Log START]  ============ [SUB]%~dpnx0 ============
pushd "%~dp0"

SET Sysprepxml=%~1
ECHO %DATE% %TIME%[Log TRACE]  powershell -ExecutionPolicy ByPass -command "%~dp0_ChangeWPAsConceptD.ps1 \"%Sysprepxml%\""
powershell -ExecutionPolicy ByPass -command "%~dp0_ChangeWPAsConceptD.ps1 \"%Sysprepxml%\""

:END
popd
ECHO %DATE% %TIME%[Log LEAVE]  ============ [SUB]%~dpnx0 ============
ECHO.