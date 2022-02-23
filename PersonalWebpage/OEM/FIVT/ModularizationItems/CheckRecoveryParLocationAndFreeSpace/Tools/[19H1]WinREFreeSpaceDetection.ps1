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

if ($GetfreeSpace.freespace -le '54525952') {
	Write-Host "[Error] The free space of Recovery partition is less than or equal to spec 52MB`r"
	Add-Content $scriptDir"\WinREFreeSpaceNotMeetSpec.tag" "[Error] The free space of Recovery partition is less than or equal to spec 52 MB"
} else {
	Write-Host "WinRE Free Space checking is PASS`r"
}
