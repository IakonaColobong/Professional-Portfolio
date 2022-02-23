if not exist "C:\ScratchDir" mkdir "C:\ScratchDir" 
Dism /Apply-Image /ImageFile:"C:\TempHidden\RCD\Images\GRCD20200508125020PA003.swm" /SWMFile:"C:\TempHidden\RCD\Images\*.swm" /ApplyDir:C:\ /Index:1 /LogPath:"C:\OEM\NAPP\NAPP2P_DismApplyOSImage.log" /LogLevel:4 /ConfirmTrustedFile /CheckIntegrity /Verify /ScratchDir:"C:\ScratchDir" 
if %errorlevel% neq 0 exit /b %errorlevel% 
rd /s /q "C:\ScratchDir" 
if exist "C:\ScratchDir" attrib +h "C:\ScratchDir" 
