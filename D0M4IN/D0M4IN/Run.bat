@echo off
setlocal ENABLEDELAYEDEXPANSION

title D0M4IN

:: ===== PATH SETUP =====
set "json_file=%~dp0IxpSettings.json"
set "destination_folder=%USERPROFILE%\AppData\Local\Roblox\ClientSettings"
set "backup_folder=%~dp0backups"
if not exist "%backup_folder%" mkdir "%backup_folder%"

:: ===== COLOR CYCLE SETUP =====
set colors[0]=1
set colors[1]=2
set colors[2]=3
set colors[3]=4
set colors[4]=5
set colors[5]=6
set colors[6]=7
set colors[7]=8
set colors[8]=9
set colors[9]=A
set colorCount=10

:MENU
:: Flash logo with set colors and loading dots
for /L %%i in (0,1,%colorCount%-1) do (
    color 0!colors[%%i]!
    cls
    echo =============================
    echo           D0M4IN
    echo =============================
    echo.

    set /a dots=%%i %% 4
    set "loading=."
    if !dots! geq 1 set "loading=.."
    if !dots! geq 2 set "loading=..."
    if !dots! geq 3 set "loading=...."

    echo Starting !loading!
    timeout /t 1 >nul
)

:: Reset color and show menu
color 0F
cls
echo =============================
echo           D0M4IN
echo =============================
echo.

echo   1) Run
echo   2) Credits
echo   3) Disco Mode
echo   4) Edit Custom Flags
echo   5) Exit
echo.

choice /c 12345 /n /m "Select an option: "
set choice=%errorlevel%

if %choice%==1 goto RUN
if %choice%==2 goto CREDITS
if %choice%==3 goto DISCO
if %choice%==4 goto EDITFLAGS
if %choice%==5 exit

goto MENU

:RUN
cls
echo Backing up current IxpSettings.json...
for /f "tokens=1-4 delims=/: " %%a in ('echo %date% %time%') do (
    set backup_ts=%%a%%b%%c_%%d
)
if exist "%json_file%" (
    copy "%json_file%" "%backup_folder%\IxpSettings_backup_!backup_ts!.json" >nul
)
if not exist "%destination_folder%" (
    mkdir "%destination_folder%"
)
copy "%json_file%" "%destination_folder%\IxpSettings.json" >nul
for /l %%i in (5,-1,1) do (
    cls
    echo Injecting... %%i
    timeout /t 1 >nul
)
cls
color 0A
echo ✅ Operation Successful!
echo File installed to:
echo %destination_folder%
echo.
pause
color 0F
goto MENU

:CREDITS
cls
color 0B
echo ====== CREDITS ======
echo Lead Developer: BevoED
echo Script Support: GPT-5
echo.
pause
color 0F
goto MENU

:DISCO
for /l %%x in (1,1,20) do (
    set /a col=!random! %% 14 + 1
    color 0!col!
    echo DISCO MODE ACTIVE
    timeout /t 1 >nul
    cls
)
color 0F
goto MENU

:EDITFLAGS
cls
color 0E
echo Enter your custom flags line by line in the format FlagName=Value
echo When done, type END on a new line.
set "temp_json=%backup_folder%\IxpSettings_temp.json"
if exist "%temp_json%" del "%temp_json%"
(echo {) >"%temp_json%"
for /f "skip=1 delims=" %%a in ('type "%json_file%"') do (
    set line=%%a
    if not "!line!"=="}" (
        >>"%temp_json%" echo !line!
    )
)
set firstCustom=true
:FLAGINPUT
set /p line=""
if /i "%line%"=="END" goto FLAGSDONE
if not "%line%"=="" (
    if !firstCustom!==true (
        set firstCustom=false
    ) else (
        >>"%temp_json%" echo ,
    )
    call :SplitKV "!line!"
)
goto FLAGINPUT

:SplitKV
set "input=%~1"
for /f "tokens=1,* delims==" %%A in ("%input%") do (
    set "key=%%A"
    set "value=%%B"
    >>"%temp_json%" echo    "!key!": "!value!"
)
goto :eof

:FLAGSDONE
>>"%temp_json%" echo }
move /y "%temp_json%" "%json_file%" >nul
cls
echo ✅ Custom flags merged with original JSON.
echo Run option will apply them.
pause
color 0F
goto MENU

endlocal