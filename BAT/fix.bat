@echo off
cd /d "%~dp0"
cd ..
set rootpath=%cd%
 
REM This script is used to fix illegal characters in batches
echo ************* DON'T FORGET TO CONVERT PS1 DB TO ANSI *************

REM PS1
"%rootpath%\BAT\Busybox" sed -i "2,$s/!/^!/g; 2,$s/ :/:/g; 2,$s/ :/:/g; 2,$s/:/ -/g; 2,$s/?//g; 2,$s/*//g; 2,$s/\///g" "%rootpath%\BAT\TitlesDB_PS1_English.txt"

pause