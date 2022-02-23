function Get-FreeSpace {
  #Create an hashtable variable 
  [hashtable]$Return = @{}

  $filter = "DriveType=3 And Label='Recovery'"
  $Return.freespace = (gwmi Win32_Volume -Filter $filter | select FreeSpace).freespace
  $Return.capacity = (gwmi Win32_Volume -Filter $filter | select Capacity).capacity
  return $Return
}
$scriptDir = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
$GetfreeSpace = Get-FreeSpace
Write-Host ("  Capacity:" + $GetfreeSpace.capacity + " bytes (" + $GetfreeSpace.capacity/1024/1024 + " MB)`r")
Write-Host ("Free Space:" + $GetfreeSpace.freespace + " bytes (" + $GetfreeSpace.freespace/1024/1024 + " MB)`r")

if ($GetfreeSpace.capacity -le '524288000') {
    if ($GetfreeSpace.freespace -le '52428800') {
        Write-Host "[Error] The free space of Recovery partition is less than or equal to spec 50 MB`r"
		Add-Content $scriptDir"\WinREFreeSpaceNotMeetSpec.tag" "[Error] The free space of Recovery partition is less than or equal to spec 50 MB"
    } else {
        Write-Host "[~500] WinRE Free Space checking is PASS`r"
    }
} elseif ($GetfreeSpace.capacity -gt '524288000' -and $GetfreeSpace.capacity -le '1073741824') {
    if ($GetfreeSpace.freespace -le '335544320') {
        Write-Host "[Error] The free space of Recovery partition is less than or equal to spec 320 MB`r"
		Add-Content $scriptDir"\WinREFreeSpaceNotMeetSpec.tag" "[Error] The free space of Recovery partition is less than or equal to spec 320 MB"
    } else {
        Write-Host "[500-1024] WinRE Free Space checking is PASS`r"
    }
} elseif ($GetfreeSpace.capacity -gt '1073741824') {
    if ($GetfreeSpace.freespace -le '1073741824') {
        Write-Host "[Error] The free space of Recovery partition is less than or equal to spec 1024 MB`r"
		Add-Content $scriptDir"\WinREFreeSpaceNotMeetSpec.tag" "[Error] The free space of Recovery partition is less than or equal to spec 1024 MB"
    } else {
        Write-Host "[1024~] WinRE Free Space checking is PASS`r"
    }
} else {
    Write-Host "No match case for detection.`r"
}
