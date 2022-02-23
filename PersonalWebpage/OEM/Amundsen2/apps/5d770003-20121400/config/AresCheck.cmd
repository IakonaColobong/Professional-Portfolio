pushd %~dp0
if exist "C:\ProgramData\Microsoft\Windows\Start Menu\Acer\Acer Jumpstart.lnk" (
    echo installed=true> AresCheck.inf
) else (
    echo installed=false> AresCheck.inf
)
popd
