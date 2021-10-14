@echo off
:: setup GOROOT, GOCACHE, GOENV and GOPATH
:: TODO: switch to writing ./config/goenv file in manifest and only set GOENV here
set "GOROOT=%~dp0\..\app"
set "GOCACHE=%~dp0\..\cache"
set "GOENV=%~dp0\..\config\goenv"
if defined GOPATH (
	set "GOPATH=%GOPATH%;%~dp0\..\data\packages"
) else (
	set "GOPATH=%~dp0\..\data\packages"
)
"%~dp0\..\app\bin\go.exe" %*