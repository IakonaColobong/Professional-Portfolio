Option Explicit
Dim objWMIService, colItems, objItem
Dim exitcode : exitcode = 0

Set objWMIService = GetObject("winmgmts:\\.\root\SecurityCenter2")

Set colItems = objWMIService.ExecQuery("Select * From AntiVirusProduct")
Wscript.Echo "Got AntiVirus amount: " & colItems.count
exitcode = colItems.count
For Each objItem in colItems
	WScript.Echo "========================================================"
	WScript.Echo "displayName:" & objItem.displayName
	WScript.Echo "instanceGuid:" & objItem.instanceGuid
	WScript.Echo "pathToSignedProductExe:" & objItem.pathToSignedProductExe
	WScript.Echo "pathToSignedReportingExe:" & objItem.pathToSignedReportingExe
	WScript.Echo "productState:" & objItem.productState
	WScript.Echo
Next
Wscript.Quit(exitcode)