@echo off
cd /d "%~dp0"
cd ..
set rootpath=%cd%

REM PS1
"%rootpath%\BAT\Busybox" sed -i "2,$s/!/^!/g; 2,$s/ :/:/g; 2,$s/ :/:/g; 2,$s/:/ -/g; 2,$s/?//g; 2,$s/*//g; 2,$s/\///g" "%rootpath%\BAT\TitlesDB_PS1_English.txt"

pause