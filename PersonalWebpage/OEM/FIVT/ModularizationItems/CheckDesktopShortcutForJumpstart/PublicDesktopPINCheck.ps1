
$ExeCount = 0
$URLCount = 0
$WebSiteCount = 0

$sh = New-Object -ComObject WScript.Shell
$files = Get-ChildItem "C:\Users\Public\Desktop\"

ForEach ($file in $files)
{
    Write-Output "[PS1] Now processing $file"
    $ExpCheck = $sh.CreateShortcut($file.FullName).TargetPath
    if ($ExpCheck -like "*.exe*") {$ExeCount++}
    if ($file -like "*.url*"){$URLCount++}
    if ($file -like "*.website*"){$WebSiteCount++}
}
Write-Output "[PS1] DESKTOP PIN CHECKS Got EXE:$ExeCount, URL:$URLCount, Website:$WebsiteCount"
exit ($ExeCount+$URLCount+$WebsiteCount)
