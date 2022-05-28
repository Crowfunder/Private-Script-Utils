@echo off
:: by Crowfunder
:: my gh: https://github.com/Crowfunder
:: KnightLauncher gh: https://github.com/lucas-allegri/KnightLauncher
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

SET regkeys[1]="HKEY_LOCAL_MACHINE\Software\JavaSoft"
SET regkeys[2]="HKEY_LOCAL_MACHINE\Software\WOW6432Node\JavaSoft"

setlocal enabledelayedexpansion
FOR /L %%i in (1,1,2) do (
    REG ADD !regkeys[%%i]! >nul 2>&1!
    IF !errorlevel! EQU 1 (
        ECHO FAILURE: !regkeys[%%i]!
        ECHO Extracting the error...
        ECHO --------------------------------
        REG ADD !regkeys[%%i]!
        ECHO --------------------------------
        ECHO Please send the following error.
        PAUSE
        ECHO,
    )
)
