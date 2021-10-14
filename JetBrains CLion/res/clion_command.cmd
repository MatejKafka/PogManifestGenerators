@echo off

SET "PACKAGE_DIR=%~dp0\.."

SET   "CLION_PROPERTIES=%PACKAGE_DIR%\config\idea.properties"
SET "CLION_VM_OPTIONS=%PACKAGE_DIR%\config\clion64.exe.vmoptions"
SET "CLION64_VM_OPTIONS=%PACKAGE_DIR%\config\clion64.exe.vmoptions"

"%PACKAGE_DIR%\app\bin\clion64.exe" %*