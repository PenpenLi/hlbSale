@echo off
set DIR=%~dp0
echo "Updating client sql configs"

set SOURCE_PATH=%DIR%\create_sql\
set DESC_PATH=%DIR%\..\..\..\sanguo_mobile_2_server\trunk\app\db\create_static
del /a /f /s /q %DESC_PATH%\*.sql

xcopy %SOURCE_PATH%\*.sql %DESC_PATH% /S /F /R /Y /E

set SOURCE_PATH=%DIR%\sql\
set DESC_PATH=%DIR%\..\..\..\sanguo_mobile_2_server\trunk\app\db\data_static
del /a /f /s /q %DESC_PATH%\*.sql

xcopy %SOURCE_PATH%\*.sql %DESC_PATH% /S /F /R /Y /E

set SOURCE_PATH=%DIR%\update_sql\
set DESC_PATH=%DIR%\..\..\..\sanguo_mobile_2_server\trunk\app\db\update_static
del /a /f /s /q %DESC_PATH%\*.sql

xcopy %SOURCE_PATH%\*.sql %DESC_PATH% /S /F /R /Y /E

pause
