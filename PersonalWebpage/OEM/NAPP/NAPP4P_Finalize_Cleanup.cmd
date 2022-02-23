
Echo.
ECHO %DATE% %TIME%[Log START]  ============ [SUB]%~dpnx0 ============


ECHO %DATE% %TIME%[Log TRACE]  RD /S /Q C:\OEM\Preload\utility\7za
RD /S /Q C:\OEM\Preload\utility\7za
ECHO %DATE% %TIME%[Log TRACE]  RD /S /Q C:\OEM\Preload\utility\DISM
RD /S /Q C:\OEM\Preload\utility\DISM
ECHO %DATE% %TIME%[Log TRACE]  RD /S /Q C:\OEM\Preload\utility\AlaunchXWatchDog
RD /S /Q C:\OEM\Preload\utility\AlaunchXWatchDog
ECHO %DATE% %TIME%[Log TRACE]  RD /S /Q C:\OEM\Preload\utility\RebootWatchDog
RD /S /Q C:\OEM\Preload\utility\RebootWatchDog


ECHO %DATE% %TIME%[Log LEAVE]  ============ [SUB]%~dpnx0 ============
ECHO.