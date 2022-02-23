

function OutputFR ([String] $AUMIDFilePath, $NowCount ) {
    $AUMIDContent = Get-Content $AUMIDFilePath	
    $APPID = $AUMIDContent[0]
    $FRTask = $AUMIDContent[1]
	ECHO "[PS] Got APPID=[$APPID], FirstRunTask=[$FRTask]"
    "<SquareOrDesktopTile$AUMIDCount><AppIdOrPath>$APPID</AppIdOrPath><FirstRunTask>$FRTask</FirstRunTask></SquareOrDesktopTile$AUMIDCount>" | Out-File $FirstRunTaskXML -append -encoding utf8
}
$FirstRunTaskXML = $args[0]
$AUMIDFilePath = ".\FirstRunTask\*"
$Header = "<?xml version=""1.0"" encoding=""utf-8""?><StartTiles><SquareTiles>"
$Header | Out-File -FilePath $FirstRunTaskXML -Encoding utf8
$AUMIDCount = 0
Get-ChildItem $AUMIDFilePath -File -Include *.txt
Get-ChildItem $AUMIDFilePath -File -Include *.txt | ForEach-Object {
    $AUMIDCount += 1
    ECHO "[PS] Now AUMID file is $_.FullName, Count is $AUMIDCount"
    OutputFR -AUMIDFilePath $_.FullName -NowCount $AUMIDCount
}
$Footer = "</SquareTiles></StartTiles>"
$Footer | Out-File -FilePath $FirstRunTaskXML -Append -Encoding utf8

# $AUMIDContent = Get-Content $AUMIDFilePath
# $AUMIDContent[0], $AUMIDContent[1]
# $AUMIDCount = Get-ChildItem $AUMIDFilePath -Recurse -File -Include *.txt | Measure-Object | %{$_.Count}
#"$computer, $Speed, $Regcheck" | out-file -filepath C:\OEM\test.xml -append -width 200