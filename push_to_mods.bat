@echo off
echo "Copying mods to Zomboid Mods folder..."
echo %cd%
xcopy /s /e "%cd%\\mods" "C:\\Users\\%USERNAME%\\Zomboid\\mods" 