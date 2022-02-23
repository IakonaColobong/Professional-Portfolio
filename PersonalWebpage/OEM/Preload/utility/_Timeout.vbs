Option Explicit

'function args
Private arg_c
Private arg_v1 'seconds to timeout

'Get arg
arg_c=WScript.Arguments.Length
WScript.Echo "arg_c=" & arg_c
arg_v1=WScript.Arguments.Item(0)
WScript.Echo "arg_v1=" & arg_v1

WScript.Echo "Waiting for " & CDbl(arg_v1) & "secs"
WScript.Sleep CDbl(arg_v1)*1000
WScript.Echo "Timeout finish"

