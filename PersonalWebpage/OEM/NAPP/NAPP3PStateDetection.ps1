$OSDrive=$args[0]
# $OSDrive\windows\Setup\State.ini
$strState = ((Select-String -Path $OSDrive\Windows\Setup\State\State.ini -Pattern ImageState=).Line -split "=")[1]
Write-Host "[PS] Got the windows Setup State is $strState`r`n"
IF ($strState -ne "IMAGE_STATE_SPECIALIZE_RESEAL_TO_OOBE") {
    For ($i=0; $i -lt 3; $i++) {
        (New-Object -ComObject Wscript.Shell).Popup("ERROR! Windows Setup State not IMAGE_STATE_SPECIALIZE_RESEAL_TO_OOBE",0,"Windows Setup State Detection",0x10)
    }
} ELSE {
    Write-Host "[PS] windows Setup State Detection is PASS.`r`n"
}