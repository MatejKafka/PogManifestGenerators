@echo off
setlocal

set "package_root=%~dp0"
:: get parent dir
for %%a in ("%package_root:~0,-1%") do set "package_root=%%~dpa"

if [%1] == [] (
    :: if no arguments, call nim without any arguments
    "%package_root%\app\bin\nim.exe"
    exit /b %errorlevel%
)

:: get all args except for the first one, which is a nim command (e.g. `nim c`)
set _tail=%*
call set _tail=%%_tail:*%1=%%

:: add mingw to PATH
set PATH=%PATH%;%package_root%\..\mingw64\app\bin\
"%package_root%\app\bin\nim.exe" %1 --clearNimblePath "--NimblePath:%package_root%\data\nimble\pkgs" "--nimcache:%package_root%\cache" %_tail%

endlocal