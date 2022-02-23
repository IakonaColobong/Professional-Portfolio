
@echo off
pushd "%~dp0"
REM To copy Acer auto BOM zip to C:\OEM\FIVT folder, the zip file will be used for FIVT tool later in UserAlaunch                                   
if not exist C:\OEM\AcerLogs\ md C:\OEM\AcerLogs
REM W10 without hidden
if exist C:\TempHidden\SCD\patch\*.zip copy /y C:\TempHidden\SCD\patch\*.zip C:\OEM\FIVT\ >> C:\OEM\AcerLogs\SCD_WinPE.log 2>&1
if exist C:\TempHidden\SCD\patch\*.zip del /f /q C:\TempHidden\SCD\patch\*.zip >> C:\OEM\AcerLogs\SCD_WinPE.log 2>&1

echo ================================== FIVT copy BOM.zip =================================
REM W10 with hidden
CScript /nologo _listUsingFixedDiskDriveLetters.vbs > vols.log
for /f "delims=" %%K in (vols.log) do (
	if exist %%K\D2D_WIN10\SCD\*.* echo %%K\D2D_WIN10\SCD\* found >> C:\OEM\AcerLogs\SCD_WinPE.log
	if exist %%K\D2D_WIN10\SCD\patch\*.zip copy /y %%K\D2D_WIN10\SCD\patch\*.zip C:\OEM\FIVT\ >> C:\OEM\AcerLogs\SCD_WinPE.log 2>&1
	if exist %%K\D2D_WIN10\SCD\patch\*.zip del /f /q %%K\D2D_WIN10\SCD\patch\*.zip >> C:\OEM\AcerLogs\SCD_WinPE.log 2>&1
)

echo ================================== End ==================================
popd