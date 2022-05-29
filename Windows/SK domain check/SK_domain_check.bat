@echo off
:: by Crowfunder
:: my gh: https://github.com/Crowfunder
::
:: This script's purpose is to check whether the domains utilized
:: by Spiral Knights are reachable.
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:: Some useful constants and strings
SET separator=--------------------------------------------------------------------------------

:: Domains used for overall and SK domains reachability test
SET domainsArray[1]="google.com"
SET domainsArray[2]="0.com"
SET domainsArray[3]="gamemedia2.spiralknights.com"
SET domainsArray[4]="game.spiralknights.com"
SET domainsArray[5]="spiralknights.com"

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: Perform a domain reachability test
:: In this test, the following domains should always return:
::
:: ----- google.com -----
:: Response Code: 200
:: Ping Successful
:: DNS resolution successful
::
:: ----- 0.com -----
:: Response Code: 000
:: Ping request could not find host
:: Non-existent domain
::
:: ----- "gamemedia2.spiralknights.com" -----
:: Response Code: 403
:: Ping Successful
:: DNS resolution successful
::
:: ----- "game.spiralknights.com" -----
:: Response Code: 000
:: Ping Request timed out
:: DNS resolution successful
::
:: ----- "spiralknights.com" -----
:: Response Code: 200
:: Ping Request timed out
:: DNS resolution successful
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

ECHO Domain resolution test in progress...
ECHO:
SETLOCAL EnableDelayedExpansion

FOR /F "tokens=2 delims==" %%s IN ('SET domainsArray[') DO (
    ECHO ----- %%s -----
    ECHO Response Code: 
    curl -o nul -L -s -w "%%{http_code}" --connect-timeout 6 %%s
    ECHO:
    PING %%s
    ECHO:
    nslookup %%s
    ECHO %separator%
)

ECHO:
PAUSE

