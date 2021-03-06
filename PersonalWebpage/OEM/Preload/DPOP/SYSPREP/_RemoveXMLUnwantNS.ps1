$FN=$args[0]
$TEMP=(get-date -uformat %YY%mM%dDH%HM%MS%SR) + (get-random -maximum 100)
Write-Output "[PS Log] Backup sysprep.xml as $FN.$TEMP"
Copy-Item $FN "$FN.$TEMP"
Write-Output "[PS Log] replace [ xmlns=`"`"] as blank"
(get-content $FN -Encoding UTF8) | foreach-object {$_ -replace " xmlns=`"`"", ""} | set-content $FN -Encoding UTF8