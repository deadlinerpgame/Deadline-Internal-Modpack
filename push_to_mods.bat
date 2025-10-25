@echo off
echo "Copying changed / diff files to Zomboid Mods folder..."
echo %cd%
xcopy "%cd%\\mods" "C:\\Users\\%USERNAME%\\Zomboid\\mods" /S /E /Y /D