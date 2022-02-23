ECHO %DATE% %TIME%[Log START]  ============ [SUB]%~dpnx0 ============ >> %LogPath%
pushd "%~dp0"
:START

:CheckNumLock
REM Get System from Metadata
for /f "tokens=3 delims= " %%D in ('reg query HKLM\SOFTWARE\OEM\Metadata /v Sys ^| Find /I "Sys"') do Set Systems=%%D
if /i "%Systems%"=="DTP" goto :END
ECHO %DATE% %TIME%[Log TRACE]  Query Keyboard Number Lock Status in Audit >> %LogPath%
For /f "tokens=3 delims= " %%D in ('reg query "HKCU\Control Panel\Keyboard" /v "InitialKeyboardIndicators" ^| Find /I "InitialKeyboardIndicators"') Do Set KeybordIndicator=%%D
ECHO %DATE% %TIME%[Log TRACE]  Keybord Indicator value is %KeybordIndicator% >> %LogPath%
IF %KeybordIndicator% EQU 2 (
	ECHO !DATE! !TIME![Log TRACE]  Keyboard Number Lock Status is On, CScript.exe NumLock.vbs >> %LogPath%
	CScript.exe NumLock.vbs >> %LogPath% 2>&1
	ECHO !DATE! !TIME![Log TRACE]  After NumLock, reg query "HKCU\Control Panel\Keyboard" /v "InitialKeyboardIndicators" >> %LogPath% 2>&1
	reg query "HKCU\Control Panel\Keyboard" /v "InitialKeyboardIndicators" >> %LogPath% 2>&1
) ELSE (
	ECHO !DATE! !TIME![Log TRACE]  Keyboard Number Lock Status is Off. >>%LogPath%
)


:END
popd
ECHO %DATE% %TIME%[Log LEAVE]  ============ [SUB]%~dpnx0 ============ >> %LogPath%