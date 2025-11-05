@echo off
:: File name (make sure IxpSettings.json is in the same folder as this script)
set "source_file=%~dp0IxpSettings.json"

:: Path to Roblox ClientSettings folder in Local
set "destination_folder=%USERPROFILE%\AppData\Local\Roblox\ClientSettings"

:: Create the folder if it doesn't exist
if not exist "%destination_folder%" (
    mkdir "%destination_folder%"
)

:: Delete the old IxpSettings.json if it exists
if exist "%destination_folder%\IxpSettings.json" (
    del "%destination_folder%\IxpSettings.json"
)

:: Copy the new file
copy "%source_file%" "%destination_folder%"

echo IxpSettings.json has been replaced in %destination_folder%
pause
