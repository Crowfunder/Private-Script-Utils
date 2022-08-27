@echo off
:: by Crowfunder
:: my gh: https://github.com/Crowfunder
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:: Set Constant Vars
:: I have no idea how to insert a var into cutting from string.
SET regkeys[1]="HKEY_CURRENT_USER\SOFTWARE\Grey Havens\Spiral Knights"
SET regkeys[2]="HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Valve\Steam"
SET separator=--------------------------------------------------------------------------------
SET download_url="https://lucasallegri.b-cdn.net/knightlauncher/v1/jvm/windows/jvm_pack.zip"
SET file_name=jvm.zip

:: gamepathfailsafe gets triggered once the script finds a suitable SK path.
:: Later on, the script checks if it was triggered. 
:: If it was not - user is notified and prompted to manually enter the SK folder path.
SET /A gamepathfailsafe=0

:: Check if the script is used inside the SK folder. 
:: If that's the case we skip whole game path detection.
IF EXIST rsrc IF EXIST scenes IF EXIST code\projectx-pcode.jar ( 
    SET gamepath="%cd%"
    SET /A gamepathfailsafe=1
    GOTO Install 
    )

:: Check if SK could've been installed anywhere. 
:: If not, prompt the user to manually enter the SK folder path and skip detection.
:: Simply, per every "RegKey Not Found" error, the script increments the noflag counter.
:: It gets handled in manner:
:: noflag = 0   User has to choose whether to install for Steam or for standalone.
:: noflag = 1   Check which installation is present.
:: noflag = 2   Prompt user to manually enter the SK folder path and skip detection.
SET /A noflag=0
setlocal enabledelayedexpansion
FOR /L %%i in (1,1,2) do (
    REG QUERY !regkeys[%%i]! >nul 2>&1!
    IF !errorlevel! EQU 1 (
        SET /A noflag=!noflag! + 1
    )
)
:NoflagLoop
IF !noflag! EQU 0 (
    ECHO Where would you like your Java patched? Pick a number.
    ECHO 1 Steam
    ECHO 2 Standalone
    SET /P "installchoice=Your choice: "
    IF "!installchoice!" EQU "1" (
        GOTO SteamPath
    )
    IF "!installchoice!" EQU "2" (

        rem
    )
    IF "!installchoice!" NEQ "1" IF "!installchoice!" NEQ "2" (
        ECHO Wrong choice! Choose 1 or 2.
        GOTO NoflagLoop
    )
)
IF !noflag! EQU 2 (
    GOTO Install
)

:: Check if it's standalone, if not, skip to SteamPath.
REG QUERY %regkeys[1]% >nul 2>&1
IF %errorlevel% EQU 1 (
    SETLOCAL disabledelayedexpansion
    GOTO SteamPath
) ELSE (
    FOR /F "usebackq tokens=3*" %%A IN (`REG QUERY !regkeys[1]! /v INSTALL_DIR_REG_KEY`) DO (
        SET gamepath="%%A %%B"
        IF EXIST !gamepath! ( SET /A gamepathfailsafe=1 )
    )
    SETLOCAL disabledelayedexpansion
    GOTO Install
)


:: Getting Steam Folder Path. We check if SK is installed in default Steam folder.
:: Otherwise we parse libraryfolders.vdf file and check every other folder.
:SteamPath
FOR /F "usebackq tokens=3*" %%A IN (`REG QUERY %regkeys[2]% /v InstallPath`) DO (
    IF "%%B" EQU "" ( SET appdir=%%A) ELSE (
        SET appdir=%%A %%B
        )
    )

IF EXIST "%appdir%\steamapps\common\Spiral Knights" (
    SET gamepath="%appdir%\steamapps\common\Spiral Knights"
    SET /A gamepathfailsafe=1
    GOTO Install
    )
SET listfile="%appdir%\steamapps\libraryfolders.vdf"


:: If user has more than 9 steam library folders the script will commit die.
:: I have no idea how to handle that.
SET /A i=0
SETLOCAL enabledelayedexpansion
FOR /F "tokens=* skip=4 usebackq" %%a in (%listfile%) do (
    IF /I "%%a" NEQ "}" IF /I "%%a" NEQ "" ( 
        SET str="%%a"
        SET str=!str:~7,-1!
        SET /A i+=1
        SET pathlist[!i!]=!str!
      )
)

:: We check every steam dir
SET /A Filesx=!i!
FOR /L %%i in (1,1,!Filesx!) do (
    IF EXIST "!pathlist[%%i]!\steamapps\common\Spiral Knights" (
        SET gamepath="!pathlist[%%i]!\steamapps\common\Spiral Knights"
    )
) 
SETLOCAL disabledelayedexpansion

SET /A gamepathfailsafe=1

:Install
IF %gamepathfailsafe% EQU 0 (
    ECHO Unable to find Spiral Knights' folder.
    SET /P gamepath=Run the script inside it or please enter its path:   
) 
IF NOT EXIST %gamepath%\rsrc ( 
	IF NOT EXIST %gamepath%\scenes (
		IF NOT EXIST %gamepath%\code\projectx-pcode.jar (
    		SET /A gamepathfailsafe=0
    	)	
    )		
)

%gamepath:~1,2%
CD "%gamepath%"
ECHO Downloading...
curl.exe -sSL %download_url% -o %file_name%

ECHO Backing up java_vm...
REN java_vm java_vm_unpatched

ECHO Unpacking new java_vm...
tar -xf %file_name%
DEL %file_name%

ECHO Done!
