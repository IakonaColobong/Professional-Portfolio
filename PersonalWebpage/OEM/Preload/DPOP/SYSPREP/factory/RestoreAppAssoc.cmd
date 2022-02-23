
@ECHO OFF
Echo.
ECHO %DATE% %TIME%[Log START]  ============ [SUB]%~dpnx0 ============
:START

ECHO %DATE% %TIME%[Log TRACE]  DISM /Online /English /Export-DefaultAppAssociations:%OSDrive%\OEM\PBR_AppAsso_BeforeImport.xml
DISM /Image:%OSDrive%\ /English /Export-DefaultAppAssociations:%OSDrive%\OEM\PBR_AppAsso_BeforeImport.xml
ECHO %DATE% %TIME%[Log TRACE]  DISM /Online /English /Import-DefaultAppAssociations:"%~dp0AppAssocWithFTP.xml"
DISM /Image:%OSDrive%\ /English /Import-DefaultAppAssociations:"%~dp0AppAssocWithFTP.xml"
ECHO %DATE% %TIME%[Log TRACE]  DISM /Online /English /Export-DefaultAppAssociations:%OSDrive%\OEM\PBR_AppAsso_BeforeImport.xml
DISM /Image:%OSDrive%\ /English /Export-DefaultAppAssociations:%OSDrive%\OEM\PBR_AppAsso_BeforeImport.xml




ECHO %DATE% %TIME%[Log LEAVE]  ============ [SUB]%~dpnx0 ============
ECHO.