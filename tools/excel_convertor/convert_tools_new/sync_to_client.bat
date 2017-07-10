@echo off
set DIR=%~dp0
echo "Updating client lua configs"

set SOURCE_PATH=%DIR%\lua\
set DESC_PATH=%DIR%\..\..\..\sanguo_mobile_2_client\trunk\sanguo_mobile_2\src\data\data\
del /a /f /s /q %DESC_PATH%\*.lua

xcopy %SOURCE_PATH%\*.lua %DESC_PATH% /S /F /R /Y /E

pause
