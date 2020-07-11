:loop
a.exe | findstr Advertisement > temp
set /p VAR=<temp
if "%VAR%" NEQ "" ( C:\Users\storm\Downloads\nircmd\nircmd.exe muteappvolume spotify.exe 1) else ( C:\Users\storm\Downloads\nircmd\nircmd.exe muteappvolume spotify.exe 0)
set "VAR="
del temp
goto loop