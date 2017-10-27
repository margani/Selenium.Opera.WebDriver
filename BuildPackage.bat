@echo off
pushd %~dp0

echo Downloading %fname%...
powershell -noprof -exec unrestricted -c ".\buildTools\download-driver.ps1"
echo.
:SKIP_DOWNLOAD

echo Packaging...
mkdir -p .\dist
.\buildTools\NuGet.exe pack .\src\Selenium.Opera.WebDriver.nuspec -Out .\dist