Set oShell = CreateObject ("Wscript.Shell") 
Dim strArgs
strArgs = "cmd /c execute.bat"
oShell.Run strArgs, 0, false
