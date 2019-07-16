@echo off
plugins\wget.exe "https://github.com/IWickGames/DataVault/archive/master.zip"
plugins\7za.exe x "master.zip"
move /y "DataVault-master\DataVault\DataVault.bat" ""
rd /s /q "DataVault-master"
del /q /f "master.zip"
del /q /f "plugins\.wget-hsts"
start "" "DataVault.bat"
exit