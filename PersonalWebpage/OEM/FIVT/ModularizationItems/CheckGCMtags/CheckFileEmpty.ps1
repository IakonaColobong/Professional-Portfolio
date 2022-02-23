
$File = $args[0]
If (((Get-Content $File) -replace "`0","").length -eq 0) {
	Write-Host "File is blank"
} else {
	Write-Host "File is not blank"
}
