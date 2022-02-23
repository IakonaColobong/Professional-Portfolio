# Get system physical memory in MB 
 
# $mem = Get-WmiObject -Class Win32_ComputerSystem 
# $mem.TotalPhysicalMemory/1mb

[int]((get-wmiobject win32_physicalmemory | measure-object capacity -sum).sum/1mb);
