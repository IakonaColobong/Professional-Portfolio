
@ECHO OFF
ECHO.
ECHO %DATE% %TIME%[Log START]  ============ [SUB]%~dpnx0 ============
pushd "%~dp0"
set chars=D E F G H I J K L M N O P Q R S T U V W X Y Z
CScript /nologo _listUsingDriveLetters.vbs > vols.log
type vols.log

for %%K IN (%chars%) DO (
	call :check_and_set %%K
)
ECHO %DATE% %TIME%[Log TRACE]  Valid letter are [%VALID_LETTER_1%][%VALID_LETTER_2%][%VALID_LETTER_3%]

:END
popd
ECHO %DATE% %TIME%[Log LEAVE]  ============ [SUB]%~dpnx0 ============
ECHO.
goto :EOF


:check_and_set
find /I "%1:" "vols.log"
if /I "%errorlevel%" EQU "0" (
	exit /b 0
)
if /I "%VALID_LETTER_1%" EQU "" (
	set VALID_LETTER_1=%1:
	exit /b 0
)
if /I "%VALID_LETTER_2%" EQU "" (
	set VALID_LETTER_2=%1:
	exit /b 0
)
if /I "%VALID_LETTER_3%" EQU "" (
	set VALID_LETTER_3=%1:
	exit /b 0
)
exit /b 0

:EOF