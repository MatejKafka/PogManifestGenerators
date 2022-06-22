@echo off
setlocal

set "package_root=%~dp0"
:: get parent dir
for %%a in ("%package_root:~0,-1%") do set "package_root=%%~dpa"

"%package_root%\app\bin\nimble.exe" "--nimbleDir:%package_root%\data\nimble" %*

endlocal