set WINPE_GUID={572bcd56-ffa7-11d9-aae0-0007e994107d}
bcdedit /createstore %1\EFI\OEM\Boot\BCD

bcdedit /store %1\EFI\OEM\Boot\BCD /create {bootmgr} /d "Acer Recovery Management" 
rem bcdedit /store %1\EFI\OEM\Boot\BCD -delete {default} /cleanup
bcdedit /store %1\EFI\OEM\Boot\BCD -set {bootmgr} device partition=%1
bcdedit /store %1\EFI\OEM\Boot\BCD -set {bootmgr} path \EFI\OEM\Boot\bootmgfw.efi
bcdedit /store %1\EFI\OEM\Boot\BCD -set {bootmgr} locale %3 
bcdedit /store %1\EFI\OEM\Boot\BCD -set {bootmgr} timeout 0
bcdedit /store %1\EFI\OEM\BOOT\BCD -create %WINPE_GUID% /d "Acer Recovery Management" -application osloader
bcdedit /store %1\EFI\OEM\BOOT\BCD -create {ramdiskoptions} /d "Acer Recovery Management"
 
bcdedit /store %1\EFI\OEM\BOOT\BCD -set %WINPE_GUID% device ramdisk=[%2]\sources\boot.wim,{ramdiskoptions}
bcdedit /store %1\EFI\OEM\BOOT\BCD -set %WINPE_GUID% path \windows\system32\winload.efi
bcdedit /store %1\EFI\OEM\Boot\BCD /set %WINPE_GUID% locale %3
bcdedit /store %1\EFI\OEM\BOOT\BCD -set %WINPE_GUID% osdevice ramdisk=[%2]\sources\boot.wim,{ramdiskoptions} 
bcdedit /store %1\EFI\OEM\BOOT\BCD -set %WINPE_GUID% systemroot \windows
bcdedit /store %1\EFI\OEM\BOOT\BCD -set %WINPE_GUID% winpe yes
bcdedit /store %1\EFI\OEM\BOOT\BCD -set %WINPE_GUID% nx optin
bcdedit /store %1\EFI\OEM\BOOT\BCD -set %WINPE_GUID% detecthal yes
bcdedit /store %1\EFI\OEM\BOOT\BCD -displayorder %WINPE_GUID% -addfirst
 
bcdedit /store %1\EFI\OEM\BOOT\BCD -set {ramdiskoptions} ramdisksdidevice partition=%2
bcdedit /store %1\EFI\OEM\BOOT\BCD -set {ramdiskoptions} ramdisksdipath \boot\boot.sdi

bcdedit /store %1\EFI\OEM\BOOT\BCD /default %WINPE_GUID%
