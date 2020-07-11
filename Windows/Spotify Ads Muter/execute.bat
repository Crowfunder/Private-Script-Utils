:loop
a.exe | findstr Advertisement > temp
set /p VAR=<temp
if "%VAR%" NEQ "" ( nircmd.exe muteappvolume spotify.exe 1) else ( nircmd.exe muteappvolume spotify.exe 0)
set "VAR="
del temp
goto loop
