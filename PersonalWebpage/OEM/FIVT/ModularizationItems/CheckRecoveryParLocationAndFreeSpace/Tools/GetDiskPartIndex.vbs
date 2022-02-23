Dim query
Dim objWMI 
Dim diskDrives 
Dim diskDrive 
Dim partitions 
Dim partition ' will contain the drive & partition numbers
Dim logicalDisks 
Dim logicalDisk ' will contain the drive letter

Set objWMI = GetObject("winmgmts:\\.\root\cimv2")
Set diskDrives = objWMI.ExecQuery("SELECT * FROM Win32_DiskDrive") ' First get out the physical drives
For Each diskDrive In diskDrives 
    query = "ASSOCIATORS OF {Win32_DiskDrive.DeviceID='" + diskDrive.DeviceID + "'} WHERE AssocClass = Win32_DiskDriveToDiskPartition" ' link the physical drives to the partitions
    Set partitions = objWMI.ExecQuery(query) 
    For Each partition In partitions 
        query = "ASSOCIATORS OF {Win32_DiskPartition.DeviceID='" + partition.DeviceID + "'} WHERE AssocClass = Win32_LogicalDiskToPartition"  ' link the partitions to the logical disks 
        Set logicalDisks = objWMI.ExecQuery (query) 
        For Each logicalDisk In logicalDisks      
            Wscript.Echo logicalDisk.DeviceID & " - DiskIndex=" & partition.DiskIndex & " - PartitionIndex=" & partition.Index+1
        Next
    Next 
Next 