@echo off
chcp 65001 >nul 2>&1
title DKWDRV Batch Game Installer By GDX

REM ##################################
REM Game Installer for DKWDRV BY GDX
REM 15/04/2024
REM ##################################

setlocal EnableDelayedExpansion

echo\
echo Do you want to use database titles^?
CHOICE /C YN
echo\
if !errorlevel!==1 (set usedb=yes) else (set usedb=no)

echo\
echo Do you want to change the default directory^?
echo ^(Useful if your games are on another hard drive or path^)
CHOICE /C YN
echo\
if !errorlevel!==1 (
echo Example: E:\
set /p "HDDPATH=Enter the path where yours Games located:"
)

echo\
echo Type your USB Drive letter. Example: F:\
set /p "HDDPATHOUTPUT=Enter the path:"
if "!HDDPATHOUTPUT!"=="" set "CustomPath="

if not defined HDDPATH set HDDPATH=%~dp0__PUT_GAME_HERE
if not defined HDDPATHOUTPUT set HDDPATHOUTPUT=%~dp0
if not exist "%~dp0TMP" md "%~dp0TMP"

cd /d "!HDDPATH!"
set /a gamecount=0
for %%f in (*.cue *.zip *.7z *.rar) do (
set /a gamecount+=1

    setlocal DisableDelayedExpansion
    set filename=%%f
    set fname=%%~nf
	set dbtitle=
    setlocal EnableDelayedExpansion

	if "!filename!"=="!fname!.zip" set compressed=zip
	if "!filename!"=="!fname!.ZIP" set compressed=ZIP
	if "!filename!"=="!fname!.7z" set compressed=7z
	if "!filename!"=="!fname!.7Z" set compressed=7Z
	if "!filename!"=="!fname!.rar" set compressed=rar
	if "!filename!"=="!fname!.RAR" set compressed=RAR
	
    echo\
	echo\
	echo !gamecount! - !filename!
	
	if not exist "!HDDPATHOUTPUT!\DKWDRV\BIN\!fname!" md "!HDDPATHOUTPUT!\DKWDRV\BIN\!fname!"
	
	if "!filename!"=="!fname!.!compressed!" (
	"%~dp0BAT\7-Zip\7z" x -bso0 "!HDDPATH!\!fname!.!compressed!" -o"!HDDPATH!" -r -y
	dir /b /a-d "!HDDPATH!\*.cue" > "%~dp0TMP\GamesUnzip.txt" & set /P filename=<"%~dp0TMP\GamesUnzip.txt" 
	set DelExtracted=yes
	)

	REM Merge Multi-Tracks
	"%~dp0BAT\binmerge" "!HDDPATH!\!filename!" "!filename:~0,-4!" -o "!HDDPATHOUTPUT!\DKWDRV\BIN\!filename:~0,-4!" | findstr "Merging ERROR"

	REM Get Gameid
	"%~dp0BAT\UPSX_SID" "!HDDPATHOUTPUT!\DKWDRV\BIN\!fname!\!fname!.bin" > "%~dp0TMP\gameid.txt" & set /p gameid=<"%~dp0TMP\gameid.txt"
	
	REM Get Title
	if !usedb!==yes for /f "tokens=1*" %%A in ('findstr !gameid! "%~dp0BAT\TitlesDB_PS1_English.txt"' ) do set dbtitle=%%B
	
	if defined dbtitle (ren "!HDDPATHOUTPUT!\DKWDRV\BIN\!filename:~0,-4!" "!dbtitle! [!gameid!]") else (ren "!HDDPATHOUTPUT!\DKWDRV\BIN\!filename:~0,-4!" "!filename:~0,-4! [!gameid!]")

	if !DelExtracted!==yes del "!HDDPATH!\!filename:~0,-4! (Track *).bin" >nul 2>&1 & del "!HDDPATH!\!filename:~0,-4!.cue" >nul 2>&1 & del "!HDDPATH!\!filename:~0,-4!.bin" >nul 2>&1
	endlocal
endlocal
)

cd /d "%~dp0" & rmdir /Q/S "%~dp0TMP" >nul 2>&1

echo\
echo\
echo Github: https://github.com/GDX-X
echo Twitter: https://twitter.com/GDX_SM
echo ----------------------------------------------------
echo Completed...
echo\
echo\
pause