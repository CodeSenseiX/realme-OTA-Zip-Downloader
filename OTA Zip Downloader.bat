@echo off
setlocal enabledelayedexpansion
REM Loading Terminal Value
    call :InitializeTerminalValue

REM Cal(); For Greeting
    call :Personalized_Greeting

:: Main Menu Options
:MainMenu
call :Header "Main Menu" %pg%
echo.
echo    1. Download OTA Package
ping 127.0.0.1 -n 1 -w 200 >nul
echo.
echo    2. Get Help
ping 127.0.0.1 -n 1 -w 200 >nul
echo.
echo    3. About OTA Zip Downloader
ping 127.0.0.1 -n 1 -w 200 >nul
echo.
echo    4. Quit
ping 127.0.0.1 -n 1 -w 200 >nul
echo.
set /p "choice=Select an option (1-4): "
if "%choice%" == "1" goto DownloadMenu
if "%choice%" == "2" goto GetHelp
if "%choice%" == "3" goto About
if "%choice%" == "4" goto Quit
call :Error_Handling MainMenu

:: Download Menu Options
:DownloadMenu
call :Header "Download OTA Package" %pg%
echo.
echo    1. I Already Have A Link
ping 127.0.0.1 -n 1 -w 200 >nul
echo.
echo    2. Generate A Custom Link and Download
ping 127.0.0.1 -n 1 -w 200 >nul
echo.
echo    3. Select From Predefined List(Realme12p+)
ping 127.0.0.1 -n 1 -w 200 >nul
echo.
echo    4. Go Back
ping 127.0.0.1 -n 1 -w 200 >nul
echo.
set /p "choice=Select an option (1-4): "
if "%choice%" == "1" goto DownloadWithLink
if "%choice%" == "2" goto GenerateCustomLinkAndDownload
if "%choice%" == "3" goto PredefinedList
if "%choice%" == "4" goto MainMenu

call :Error_Handling DownloadMenu

:DownloadWithLink
call :Header "Download With Link" %pg%
echo.
set /p "user_url=Enter the URL to download the file: "
if "%user_url%"=="" ( 
    echo Invalid URL. Please try again.
    ping 127.0.0.1 -n 1 -w 200 >nul
echo.
    timeout /t 2 >nul
    goto DownloadMenu
)
    ping 127.0.0.1 -n 1 -w 200 >nul
echo.
set /p "user_name=Enter the desired name for the file (without extension): "
if "%user_name%"=="" (
    echo Invalid file name. Please try again.
    ping 127.0.0.1 -n 1 -w 200 >nul
echo.
    timeout /t 2 >nul
    goto DownloadMenu
)
curl "%user_url%" --output "%user_name%.zip"
if errorlevel 1 (
        ping 127.0.0.1 -n 1 -w 200 >nul
echo.
    echo Download failed. Check your internet connection or URL.
    timeout /t 2 >nul
    goto DownloadMenu
)
echo.
echo File "%user_name%.zip" has been downloaded successfully.
timeout /t 1 >nul
ping 127.0.0.1 -n 1 -w 200 >nul
echo.
echo Opening File Location
start.
timeout /t 1 >nul
goto MainMenu

:GenerateCustomLinkAndDownload
call :Header "Generate and Download OTA Link" %pg%
echo.
    ping 127.0.0.1 -n 1 -w 200 >nul
echo.
set /p "device_model=Enter your device model number (e.g., RMX3840): "
if "%device_model%"=="" (
    echo Invalid device model. Please try again.
    timeout /t 2 >nul
    goto GenerateCustomLinkAndDownload

)
    ping 127.0.0.1 -n 1 -w 200 >nul
echo.
set /p "os_version=Enter your OS version (e.g., 11.A.00): "
if "%os_version%"=="" (
    ping 127.0.0.1 -n 1 -w 200 >nul
echo.
    echo Invalid OS version. Please try again.

    timeout /t 2 >nul
    goto GenerateCustomLinkAndDownload
)
    ping 127.0.0.1 -n 1 -w 200 >nul
echo.
set /p "build_number=Enter your build number (e.g., RMX3840NV1B): "
if "%build_number%"=="" (
    ping 127.0.0.1 -n 1 -w 200 >nul
echo.
    echo Invalid build number. Please try again.

    timeout /t 2 >nul
    goto GenerateCustomLinkAndDownload
)
    ping 127.0.0.1 -n 1 -w 200 >nul
echo.
set /p "region_code=Enter your region code (e.g., 5): "
if "%region_code%"=="" (
    ping 127.0.0.1 -n 1 -w 200 >nul
echo.
    echo Invalid region code. Please try again.
    timeout /t 2 >nul
    goto GenerateCustomLinkAndDownload
)
    ping 127.0.0.1 -n 1 -w 200 >nul
echo.
set /p "revision=Enter your revision code (e.g., -r 3): "
if "%revision%"=="" (
    ping 127.0.0.1 -n 1 -w 200 >nul
echo.
    echo Invalid revision code. Please try again.
    timeout /t 2 >nul
    goto GenerateCustomLinkAndDownload
)
    ping 127.0.0.1 -n 1 -w 200 >nul
echo.
set "command=%tool_path% %device_model% %build_number%_%os_version%_0000_000000000000 %region_code% 01010001 %revision%"
call :Link_Generation_Engine "%command%"

:Link_Generation_Engine
:: Generate JSON using OTAFinder.exe
set command=%~1
echo Running OTAFinder with command: %~1
echo.

%command% > temp.json

if %errorlevel% neq 0 (
    ping 127.0.0.1 -n 1 -w 200 >nul
echo.
    echo Failed to generate JSON output.
    pause
    del temp.json >nul 2>&1
    goto DownloadMenu
)

:: Extract manual URL from JSON
set "rawurl="
for /f "tokens=3 delims=:," %%A in ('findstr /i "\"manualUrl\"" temp.json') do (
    set rawurl=%%A
)
set rawurl=%rawurl:~1%
set extracted_url=https://%rawurl:~0,-1%
ping 127.0.0.1 -n 1 -w 200 >nul
echo.
echo Extracted URL: %extracted_url%

:: Download the extracted URL
ping 127.0.0.1 -n 1 -w 200 >nul
echo.
set /p "user_name=Enter the desired name for the file (without extension): "
curl "%extracted_url%" --output "%user_name%.zip"
if %errorlevel% neq 0 (
    ping 127.0.0.1 -n 1 -w 200 >nul
echo.
    echo Download failed. Please check the URL or try again.
    del temp.json >nul 2>&1
    pause
    goto DownloadMenu
)
ping 127.0.0.1 -n 1 -w 200 >nul
echo.
echo File "%user_name%.zip" has been downloaded successfully.

:: Clean up temporary files
del temp.json >nul 2>&1
pause
goto MainMenu

:PredefinedList
call :Header "Select Predefined OTA Package" %pg%
ping 127.0.0.1 -n 1 -w 200 >nul
echo.
ping 127.0.0.1 -n 1 -w 200 >nul
echo  Android 14                     Android 15
ping 127.0.0.1 -n 1 -w 200 >nul
echo  --------------                 --------------
ping 127.0.0.1 -n 1 -w 200 >nul
echo  1. RMX3840 TR                  15. RMX3840 TR
ping 127.0.0.1 -n 1 -w 200 >nul
echo  2. RMX3840 RU                  16. RMX3840 RU
echo  3. RMX3840 MEA                 17. RMX3840 MEA
ping 127.0.0.1 -n 1 -w 200 >nul
echo  4. RMX3840 SA                  18. RMX3840 SA
echo  5. RMX3840 IN                  19. RMX3840 IN
echo  6. RMX3840 EU                  20. RMX3840 EU
ping 127.0.0.1 -n 1 -w 200 >nul
echo  7. RMX3840 TH                  21. RMX3840 TH
echo  8. RMX3840 LATAM               22. RMX3840 LATAM
echo  9. RMX3840 BR                  23. RMX3840 BR
ping 127.0.0.1 -n 1 -w 200 >nul
echo 10. RMX3840 PH                  24. RMX3840 PH
echo 11. RMX3840 TW                  25. RMX3840 TW
ping 127.0.0.1 -n 1 -w 200 >nul
echo 12. RMX3840 ID                  26. RMX3840 ID
echo 13. RMX3840 MY                  27. RMX3840 MY
ping 127.0.0.1 -n 1 -w 200 >nul
echo 14. RMX3841 CN                  28. RMX3841 CN
echo.
echo ==============================================================================
ping 127.0.0.1 -n 1 -w 200 >nul
echo.
set /p "choice=Enter your choice (1-28): "
if "%choice%"=="" (
    ping 127.0.0.1 -n 1 -w 200 >nul
    echo Invalid choice. Please try again.
    timeout /t 2 >nul
    goto PredefinedList
)
call :MapPredefinedChoice %choice%
if "%predefined_link%"=="" (
    ping 127.0.0.1 -n 1 -w 200 >nul
    echo Invalid predefined choice. Please try again.
    timeout /t 2 >nul
    goto PredefinedList
)

:: Pass predefined link to the download engine
call :Link_Generation_Engine "%predefined_link%"
goto MainMenu


:GetHelp
call :Header "Get Help" %pg%
echo.
echo Who would you like to contact?
echo.
echo    1. Contact @parth_sancheti
ping 127.0.0.1 -n 1 -w 200 >nul
echo.
echo    2. Contact @CodeSenseiX
ping 127.0.0.1 -n 1 -w 200 >nul
echo.
echo    3. Need Help Regarding device info
ping 127.0.0.1 -n 1 -w 200 >nul
echo.
echo    4. Go Back
ping 127.0.0.1 -n 1 -w 200 >nul
echo.
set /p "choice=Select an option (1-3): "
if "%choice%" == "1" start https://t.me/parth_sancheti & goto MainMenu
if "%choice%" == "2" start https://t.me/CodeSenseiX & goto MainMenu
if "%choice%" == "3" start https://t.me/RealmeInfoBot & goto MainMenu
if "%choice%" == "4" goto MainMenu

call :Error_Handling GetHelp

:About
call :Header "About OTA Zip Downloader" %pg%
echo.
echo.                                                         
echo.                                  
echo  Tool Name   : OTA Zip Downloader
echo.                                         
echo  Version     : %version%
echo.                                                     
echo  Maintainers : %maintainers%
echo.                                                 
echo  Description : A tool to download OTA firmware packages dynamically from     
echo                 BBK servers.                                                 
echo.                                                                             
echo.
pause
goto MainMenu

:Quit
cls
call :Spacer 10
echo                  "------------------------------------------"
echo                  "|                                        |"
ping 127.0.0.1 -n 1 -w 200 >nul
echo                  "| Thank You For Using OTA Zip Downloader |"
echo                  "|        Have A Great Day Ahead!          |"
echo                  "|                                        |"
ping 127.0.0.1 -n 1 -w 200 >nul
echo                  "-----------------------------------------"
call :Spacer 6
timeout /t 2 >nul
exit

:Header
cls
set "border_line=-----------------------------------------------------------------------------"

:: Print the top border
echo %border_line%
echo.

:: Center-align the "Good Morning - Main Menu"
call :CenterText "%~2 - %~1"

:: Center-align the "Created By" section
call :CenterText "Created By: @Parth_Sancheti, @CodeSenseiX"

echo.
:: Print the bottom border
echo %border_line%
ping 127.0.0.1 -n 1 -w 200 >nul
goto :EOF

:CenterText
:: Parameters:
:: %1 - Text to center
set "text=%~1"
set /a "console_width=80"
set /a "text_length=0"

:: Calculate the length of the text
for /l %%i in (0,1,4095) do (
    if "!text:~%%i,1!"=="" (
        set /a "text_length=%%i"
        goto :done_length
    )
)
:done_length

:: Calculate padding
set /a "padding=(console_width - text_length) / 2"

:: Generate spaces for padding
set "spaces="
for /l %%i in (1,1,%padding%) do set "spaces=!spaces! "

:: Print centered text
echo !spaces!!text!
goto :EOF




:Spacer
set i=0
set n=%~1
:SpacerLoop
if !i! lss %n% (
echo.
set /a i+=1
goto SpacerLoop
)
goto :EOF

:Error_Handling
call :Header "Error Handling" %pg%
echo Please ensure you've selected a valid option.
echo Redirecting...
timeout /t 1 >nul
goto %1

:MapPredefinedChoice
set "predefined_link="

if "%~1"=="1" set "predefined_link=%tool_path% RMX3840TR RMX3840NV51_11.A.00_0000_000000000000 5 01010001 -r 0"
if "%~1"=="2" set "predefined_link=%tool_path% RMX3840RU RMX3840NV37_11.A.00_0000_000000000000 5 00110111 -r 3"
if "%~1"=="3" set "predefined_link=%tool_path% RMX3840MEA RMX3840NV76_11.A.00_0000_000000000000 5 01110110 -r 2"
if "%~1"=="4" set "predefined_link=%tool_path% RMX3840SA RMX3840NV83_11.A.00_0000_000000000000 5 10000011 -r 3"
if "%~1"=="5" set "predefined_link=%tool_path% RMX3840IN RMX3840NV1B_11.A.00_0000_000000000000 5 00011011 -r 3"
if "%~1"=="6" set "predefined_link=%tool_path% RMX3840EU RMX3840NV44_11.A.00_0000_000000000000 5 01000100 -r 2"
if "%~1"=="7" set "predefined_link=%tool_path% RMX3840TH RMX3840NV39_11.A.00_0000_000000000000 5 00111001 -r 3"
if "%~1"=="8" set "predefined_link=%tool_path% RMX3840LATAM RMX3840NV9A_11.A.00_0000_000000000000 5 10011010 -r 3"
if "%~1"=="9" set "predefined_link=%tool_path% RMX3840BR RMX3840NV9E_11.A.00_0000_000000000000 5 10011110 -r 3"
if "%~1"=="10" set "predefined_link=%tool_path% RMX3840PH RMX3840NV3E_11.A.00_0000_000000000000 5 10011110 -r 2"
if "%~1"=="11" set "predefined_link=%tool_path% RMX3840TW RMX3840NV1A_11.A.00_0000_000000000000 5 10011110 -r 2"
if "%~1"=="12" set "predefined_link=%tool_path% RMX3840ID RMX3840NV33_11.A.00_0000_000000000000 5 10011110 -r 2"
if "%~1"=="13" set "predefined_link=%tool_path% RMX3840MY RMX3840NV38_11.A.00_0000_000000000000 5 10011110 -r 2"
if "%~1"=="14" set "predefined_link=%tool_path% RMX3841CN RMX3841_11.A.01_001_202409291749 5 -r 1"
if "%~1"=="15" set "predefined_link=%tool_path% RMX3840TR RMX3840NV51_11.C.00_0000_000000000000 5 01010001 -r 0"
if "%~1"=="16" set "predefined_link=%tool_path% RMX3840RU RMX3840NV37_11.C.00_0000_000000000000 5 00110111 -r 3"
if "%~1"=="17" set "predefined_link=%tool_path% RMX3840MEA RMX3840NVA6_11.C.00_0000_000000000000 5 10100110 -r 3"
if "%~1"=="18" set "predefined_link=%tool_path% RMX3840SA RMX3840NV83_11.C.00_0000_000000000000 5 10000011 -r 3"
if "%~1"=="19" set "predefined_link=%tool_path% RMX3840IN RMX3840NV1B_11.C.00_0000_000000000000 5 00011011 -r 3"
if "%~1"=="20" set "predefined_link=%tool_path% RMX3840EU RMX3840NV44_11.C.00_0000_000000000000 5 01000100 -r 2"
if "%~1"=="21" set "predefined_link=%tool_path% RMX3840TH RMX3840NV39_11.C.00_0000_000000000000 5 00111001 -r 3"
if "%~1"=="22" set "predefined_link=%tool_path% RMX3840LATAM RMX3840NV9A_11.C.00_0000_000000000000 5 10011010 -r 3"
if "%~1"=="23" set "predefined_link=%tool_path% RMX3840BR RMX3840NV9E_11.C.00_0000_000000000000 5 10011110 -r 3"
if "%~1"=="24" set "predefined_link=%tool_path% RMX3840PH RMX3840NV3E_11.C.00_0000_000000000000 5 10011110 -r 2"
if "%~1"=="25" set "predefined_link=%tool_path% RMX3840TW RMX3840NV1A_11.C.00_0000_000000000000 5 10011110 -r 2"
if "%~1"=="26" set "predefined_link=%tool_path% RMX3840ID RMX3840NV33_11.C.00_0000_000000000000 5 10011110 -r 2"
if "%~1"=="27" set "predefined_link=%tool_path% RMX3840MY RMX3840NV38_11.C.00_0000_000000000000 5 10011110 -r 2"
if "%~1"=="28" set "predefined_link=%tool_path% RMX3841CN RMX3841NV97_11.C.00_000_000000000000 5 -s -r 1"

goto :EOF

:GetHelp
call :Header "Get Help" %pg%
echo.
echo Who would you like to contact?
echo.
echo    1. Contact @parth_sancheti
ping 127.0.0.1 -n 1 -w 200 >nul
echo.
echo    2. Contact @CodeSenseiX
ping 127.0.0.1 -n 1 -w 200 >nul
echo.
echo    3. Go Back
ping 127.0.0.1 -n 1 -w 200 >nul
echo.
set /p "choice=Select an option (1-3): "
if "%choice%" == "1" start https://t.me/parth_sancheti & goto MainMenu
if "%choice%" == "2" start https://t.me/CodeSenseiX & goto MainMenu
if "%choice%" == "3" goto MainMenu

call :Error_Handling GetHelp

:About
call :Header "About OTA Zip Downloader" %pg%
echo.
echo.                                                        
echo.                                  
echo  Tool Name   : OTA Zip Downloader
echo.                                        
echo  Version     : %version%
echo.                                                     
echo  Maintainers : %maintainers%
echo.                                                 
echo  Description : A tool to download OTA firmware packages dynamically from     
echo                 BBK servers.                                                 
echo.                                                                             
echo.
pause
goto MainMenu


REM Display Units

:Quit
cls
call :Spacer 11
echo                    "------------------------------------------"
echo                    "|                                        |"
ping 127.0.0.1 -n 1 -w 200 >nul
echo                    "| Thank You For Using OTA Zip Downloader |"
echo                    "|        Have A Great Day Ahead!          |"
echo                    "|                                        |"
ping 127.0.0.1 -n 1 -w 200 >nul
echo                    "-----------------------------------------"
call :Spacer 8
timeout /t 2 >nul
exit

REM Bit Codes
    :LoadConfigurationFile
    set Config="%~dp0\Bin\config.txt"
        for /f "tokens=1* delims==" %%a in (%Config%) do (
        set "%%a=%%b"
    )
    goto :EOF

    :Spacer
set i=0
set n=%~1
:SpacerLoop
if !i! lss %n% (
echo.
set /a i+=1
goto SpacerLoop
)
goto :EOF

:Error_Handling
call :Header "Error Handling" %pg%
echo Please ensure you've selected a valid option.
echo Redirecting...
timeout /t 1 >nul
cls
goto %1


:InitializeTerminalValue
reg add HKEY_CURRENT_USER\Console /v VirtualTerminalLevel /t REG_DWORD /d 1 /f >nul

mode con: cols=80 lines=30
color E
set maintainers=@parth_sancheti;@CodeSenseiX
set version=v5.5
title OTA Zip Downloader
call "%~dp0Bin\logo.bat"
set tool_path="%~dp0Bin\OTAFinder.exe"
start "" "%~dp0Bin\greeting_Speak.vbs"
timeout /t 2 >nul
goto :EOF

:Personalized_Greeting
        for /f "tokens=1-2 delims=: " %%a in ('echo %time%') do (
        set hour=%%a
        set minute=%%b
    )
    if %hour% lss 12 (
        set pg="Good Morning!"
    ) else if %hour% lss 17 (
        set pg="Good Afternoon!"
    ) else (
        set pg="Good Evening!"
    )
goto :EOF

