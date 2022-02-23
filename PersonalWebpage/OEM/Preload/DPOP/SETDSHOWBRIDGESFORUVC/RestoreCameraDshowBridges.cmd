
ECHO %DATE% %TIME%[Log START]  ============ %~dpnx0 ============>>C:\OEM\AcerLogs\RestoreCameraDshowBridgesByPBR.log 2>&1 

ECHO %DATE% %TIME%[Log TRACE]  REG ADD "HKLM\SYSTEM\CurrentControlSet\Enum\USB\VID_04F2&PID_B6E5&MI_00\6&99DAB2A&0&0000\Device Parameters" /v EnableDshowRedirection /t REG_DWORD /d "00000001" /f>>C:\OEM\AcerLogs\RestoreCameraDshowBridgesByPBR.log 2>&1 
REG ADD "HKLM\SYSTEM\CurrentControlSet\Enum\USB\VID_04F2&PID_B6E5&MI_00\6&99DAB2A&0&0000\Device Parameters" /v EnableDshowRedirection /t REG_DWORD /d "00000001" /f>>C:\OEM\AcerLogs\RestoreCameraDshowBridgesByPBR.log 2>&1 

ECHO %DATE% %TIME%[Log LEAVE]  ============ %~dpnx0 ============>>C:\OEM\AcerLogs\RestoreCameraDshowBridgesByPBR.log 2>&1 
