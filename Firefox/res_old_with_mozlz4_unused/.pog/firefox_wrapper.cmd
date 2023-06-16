@echo off
setlocal

SET "PACKAGE_DIR=%~dp0\.."
SET "PROFILE=%PACKAGE_DIR%\data"

:: these currently don't work
::SET "MOZ_CRASHREPORTER_DATA_DIRECTORY=%PACKAGE_DIR%\cache\crashreporter"
::SET "MOZ_CRASHREPORTER_EVENTS_DIRECTORY=%PACKAGE_DIR%\cache\events"
::SET "MOZ_CRASHREPORTER_PING_DIRECTORY=%PACKAGE_DIR%\cache\pings"

start "" "%PACKAGE_DIR%\app\firefox.exe" -profile "%PROFILE%" %*