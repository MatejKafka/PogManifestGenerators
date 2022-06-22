@echo off

SET "PACKAGE_DIR=%~dp0\.."

SET "RIDER_PROPERTIES=%PACKAGE_DIR%\config\idea.properties"
SET "RIDER_VM_OPTIONS=%PACKAGE_DIR%\config\rider64.exe.vmoptions"

"%PACKAGE_DIR%\app\bin\rider64.exe" %*
