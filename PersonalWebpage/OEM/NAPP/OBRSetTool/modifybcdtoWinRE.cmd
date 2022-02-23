bcdedit /createstore %1\EFI\OEM\Boot\BCD 
 
bcdedit /store %1\EFI\OEM\Boot\BCD /create {bootmgr} /d "Windows Boot Manager" 
bcdedit /store %1\EFI\OEM\Boot\BCD /set {bootmgr} device partition=%1 
bcdedit /store %1\EFI\OEM\Boot\BCD /set {bootmgr} locale %3 
bcdedit /store %1\EFI\OEM\Boot\BCD /set {bootmgr} integrityservices Enable 
 
bcdedit /store %1\EFI\OEM\Boot\BCD /create {11111111-1111-1111-1111-111111111111} /d "Windows Recovery" /device 
bcdedit /store %1\EFI\OEM\Boot\BCD /set {11111111-1111-1111-1111-111111111111} ramdisksdidevice partition=%2 
bcdedit /store %1\EFI\OEM\Boot\BCD /set {11111111-1111-1111-1111-111111111111} ramdisksdipath \Recovery\WindowsRE\boot.sdi 
 
bcdedit /store %1\EFI\OEM\Boot\BCD /create {22222222-2222-2222-2222-222222222222} /d "Windows Recovery Environment" /application osloader 
bcdedit /store %1\EFI\OEM\Boot\BCD /set {bootmgr} default {22222222-2222-2222-2222-222222222222} 
bcdedit /store %1\EFI\OEM\Boot\BCD /set {bootmgr} displayorder {22222222-2222-2222-2222-222222222222} 
 
bcdedit /store %1\EFI\OEM\Boot\BCD /set {default} device ramdisk=[%2]\Recovery\WindowsRE\winre.wim,{11111111-1111-1111-1111-111111111111} 
bcdedit /store %1\EFI\OEM\Boot\BCD /set {default} path \Windows\System32\winload.efi 
bcdedit /store %1\EFI\OEM\Boot\BCD /set {default} locale %3
bcdedit /store %1\EFI\OEM\Boot\BCD /set {default} displaymessage "Recovery" 
bcdedit /store %1\EFI\OEM\Boot\BCD /set {default} osdevice ramdisk=[%2]\Recovery\WindowsRE\winre.wim,{11111111-1111-1111-1111-111111111111} 
bcdedit /store %1\EFI\OEM\Boot\BCD /set {default} systemroot \Windows 
bcdedit /store %1\EFI\OEM\Boot\BCD /set {default} nx OptIn
bcdedit /store %1\EFI\OEM\Boot\BCD /set {default} bootmenupolicy Standard 
bcdedit /store %1\EFI\OEM\Boot\BCD /set {default} winpe Yes
