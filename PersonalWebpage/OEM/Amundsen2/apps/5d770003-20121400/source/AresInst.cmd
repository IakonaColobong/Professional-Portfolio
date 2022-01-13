pushd %~dp0
start /w msiexec.exe /i SetupHermes_3.3.19180.100_signed.msi /qn
SCHTASKS /Run /TN "Oem\AcerJumpstartTask"
popd
