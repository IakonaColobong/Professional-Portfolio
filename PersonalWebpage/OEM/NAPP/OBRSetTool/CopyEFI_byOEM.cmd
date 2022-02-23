mkdir R:\EFI\OEM 
XCOPY /c /e /f /y /h R:\EFI\Microsoft\* R:\EFI\OEM\
Del /Q /A:H R:\EFI\OEM\Boot\BCD
call C:\OEM\NAPP\OBRSetTool\modifybcdtoWinRE.cmd R: W: en-US >> C:\OEM\NAPP\OBRSetTool\Log\modifybcdLog.log
