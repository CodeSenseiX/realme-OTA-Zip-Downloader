@echo off
setlocal enabledelayedexpansion

:: Set color for background and text
color 0A

REM Loading Terminal Value
    call :InitializeTerminalValue

REM Personalized Greeting
    call :Personalized_Greeting

:MainMenu
call :Header "Main Menu" %pg%
echo.

echo    1. Download OTA Package
ping 127.0.0.1 -n 1 -w 100 >nul
echo.
echo    2. Get Help
ping 127.0.0.1 -n 1 -w 100 >nul
echo.
echo    3. About OTA Zip Downloader
ping 127.0.0.1 -n 1 -w 100 >nul
echo.
echo    4. Quit
ping 127.0.0.1 -n 1 -w 100 >nul
echo.

set /p "choice=Select an option (1-4): "
if "%choice%" == "1" goto DownloadMenu
if "%choice%" == "2" goto GetHelp
if "%choice%" == "3" goto About
if "%choice%" == "4" goto Quit
call :Error_Handling MainMenu

:DownloadMenu
echo "In Download Menu"  :: Debugging line
call :Header "Download OTA Package" %pg%
echo.

:: Prompt for user input
echo    1. I Already Have A Link
ping 127.0.0.1 -n 1 -w 100 >nul
echo.
echo    2. Enter Device Model and Download
ping 127.0.0.1 -n 1 -w 100 >nul
echo.
echo    3. Select From Predefined List(Realme12Pro+)
ping 127.0.0.1 -n 1 -w 100 >nul
echo.
echo    4. Download Chinese FULL OTA
ping 127.0.0.1 -n 1 -w 100 >nul
echo.
echo    5. Go Back
echo.

set /p "choice=Select an option (1-5): "

if "%choice%" == "1" goto IAlreadyHaveALink
if "%choice%" == "2" goto GenerateCustomLinkAndDownload
if "%choice%" == "3" goto PredefinedList
if "%choice%" == "4" goto DownloadChineseOTA
if "%choice%" == "5" goto MainMenu

call :Error_Handling DownloadMenu

:: Download with Link
:IAlreadyHaveALink
call :Header "Download With Link" %pg%
echo.
set /p "user_url=Enter the URL to download the file: "
if "%user_url%"=="" ( 
    echo Invalid URL. Please try again.
    ping 127.0.0.1 -n 1 -w 100 >nul
    timeout /t 2 >nul
    goto DownloadMenu
)
echo.
set /p "file_name=Enter the desired name for the file (without extension): "
if "%file_name%"=="" (
    echo Invalid file name. Please try again.
    ping 127.0.0.1 -n 1 -w 100 >nul
    timeout /t 2 >nul
    goto DownloadMenu
)

:: Get the user's Downloads folder using environment variables
set "downloads_folder=%USERPROFILE%\Downloads"

:: Ensure the path exists
if not exist "%downloads_folder%" (
    echo [Error] Unable to locate the Downloads folder. Using current directory instead.
    set "downloads_folder=%CD%"
)

:: Construct the OTA download path inside the Windows Downloads folder
set "download_path=%downloads_folder%\%file_name%.zip"
echo.

:: Download the extracted URL using curl and handle errors
:: Check if a partial download exists
if exist "%download_path%" (
    echo Resuming previous download...
    curl -C - --progress-bar -o "%download_path%" "%extracted_url%"
) else (
    echo Starting new download...
    curl -C - --progress-bar -o "%download_path%" "%extracted_url%"
)

if errorlevel 1 (
    echo Download failed. Check your internet connection or URL.
    pause
    goto DownloadMenu
)
echo.
echo File "%download_path%.zip" has been downloaded successfully.
timeout /t 1 >nul
goto MainMenu

set custom_choice=
set predefined_link=

rem Get user input for custom choice
set /p custom_choice="Enter custom choice (or leave blank for predefined): "

rem If no custom choice, set predefined link
IF "%custom_choice%"=="" (
    set predefined_link=http://example.com
    echo Using predefined link: %predefined_link%
) ELSE (
    echo Using custom choice: %custom_choice%
)

rem Check if both are set (conflict check)
IF NOT "%custom_choice%"=="" IF NOT "%predefined_link%"=="" (
    echo ERROR: Both custom_choice and predefined_link are set. Please select only one.
    exit /b
)

rem Continue with the script
echo Script continuing...

:GenerateCustomLinkAndDownload
call :Header "Generate and Download OTA Link" %pg%
echo.
ping 127.0.0.1 -n 1 -w 200 >nul
echo.
:: Device Codename Prompt
set /p "product_model=Enter your device codename number (e.g., RMX3840): "
if "%product_model%"=="" (
    echo Invalid device codename. Please try again.
    timeout /t 2 >nul
    goto GenerateCustomLinkAndDownload
)
ping 127.0.0.1 -n 1 -w 200 >nul
echo.

:: OTA Version Prompt with Selection
echo Select the OTA version for your device:
echo 1. 11.A.00 (Android 12, 13, 14)
echo 2. 11.C.00 (Android 15)
echo 3. Enter OTA Version Manually
echo.
set /p "ota_version_choice=Enter your choice (1, 2, or 3): "
echo.
if "%ota_version_choice%"=="1" (
    set "ota_version=11.A.00"
) else if "%ota_version_choice%"=="2" (
    set "ota_version=11.C.00"
) else if "%ota_version_choice%"=="3" (
    set /p "ota_version=Enter the OS version manually (e.g., 11.A.00): "
    if "%ota_version%"=="" (
        echo Invalid OS version. Please try again.
        timeout /t 2 >nul
        goto GenerateCustomLinkAndDownload
    )
) else (
    echo Invalid choice. Please try again.
    timeout /t 2 >nul
    goto GenerateCustomLinkAndDownload
)

:: Realmeui Version Prompt 
set /p "realmeui_version=Enter your realmeui version (e.g., 1, 2, 3, 4, 5, 6): "

:: Check if the user entered version 6 and change it to 5
if "%realmeui_version%"=="6" (
    set "realmeui_version=5"
)

:: Validate the entered realmeui version
if "%realmeui_version%"=="" (
    echo Invalid rui version. Please try again.
    timeout /t 2 >nul
    goto GenerateCustomLinkAndDownload
)

:: Optionally, you could add further validation to ensure a valid number between 1 and 5 (or 6, which will automatically be changed to 5).
ping 127.0.0.1 -n 1 -w 200 >nul
echo.

:: Country Selection for Custom Link
call :Header "Choose Country" %pg%
echo.
echo  1.   Turkey (TR)
echo  2.   Russia (RU)
echo  3.   Middle East and Africa (MEA)
echo  4.   Saudi Arabia (SA)
echo  5.   India (IN)
echo  6.   European Union (EU)
echo  7.   Thailand (TH)
echo  8.   Latin America (LATAM)
echo  9.   Brazil (BR)
echo 10.   Philippines (PH)
echo 11.   Taiwan (TW)
echo 12.   Indonesia (ID)
echo 13.   Malaysia (MY)
echo.
set /p "custom_choice=Select a country to download for (1-13): "
echo.
goto :MapCustomChoice

:: Ensure that only one of the links (custom_link or predefined_link) is set at a time
:MapCustomChoice
set "command="
set "custom_link="
if defined custom_link (
    echo Clearing previous custom link...
    set "custom_link="
)

:: Clear the predefined_link to avoid conflict
set predefined_link=

:: Check if predefined_link is defined, if it is, warn the user and go to DownloadMenu
if defined predefined_link (
    echo A predefined link has already been selected. You cannot set a custom link now.
    timeout /t 2 >nul
    goto DownloadMenu
)

:: Now proceed with setting the custom link if predefined_link is not defined
:: Add your custom link logic here...

:: Generate custom link based on the country choice and device parameters
if "%custom_choice%"=="1" set "custom_link=%tool_path% %product_model%TR %product_model%NV51_%ota_version%_000_000000000000 %realmeui_version% 01010001 -r 0"
if "%custom_choice%"=="2" set "custom_link=%tool_path% %product_model%RU %product_model%NV37_%ota_version%_000_000000000000 %realmeui_version% 00110111 -r 3"
if "%custom_choice%"=="3" set "custom_link=%tool_path% %product_model% %product_model%NVA6_%ota_version%_000_000000000000 %realmeui_version% 01110110 -r 3"
if "%custom_choice%"=="4" set "custom_link=%tool_path% %product_model% %product_model%NV83_%ota_version%_000_000000000000 %realmeui_version% 10000011 -r 3"
if "%custom_choice%"=="5" set "custom_link=%tool_path% %product_model%IN %product_model%NV1B_%ota_version%_000_000000000000 %realmeui_version% 00011011 -r 3"
if "%custom_choice%"=="6" set "custom_link=%tool_path% %product_model%EEA %product_model%NV44_%ota_version%_000_000000000000 %realmeui_version% 01000100 -r 2"
if "%custom_choice%"=="7" set "custom_link=%tool_path% %product_model% %product_model%NV39_%ota_version%_000_000000000000 %realmeui_version% 00111001 -r 3"
if "%custom_choice%"=="8" set "custom_link=%tool_path% %product_model% %product_model%NV9A_%ota_version%_000_000000000000 %realmeui_version% 10011010 -r 3"
if "%custom_choice%"=="9" set "custom_link=%tool_path% %product_model% %product_model%NV9E_%ota_version%_000_000000000000 %realmeui_version% 10011110 -r 3"
if "%custom_choice%"=="10" set "custom_link=%tool_path% %product_model% %product_model%NV3E_%ota_version%_000_000000000000 %realmeui_version% 10011110 -r 2"
if "%custom_choice%"=="11" set "custom_link=%tool_path% %product_model% %product_model%NV1A_%ota_version%_000_000000000000 %realmeui_version% 10011110 -r 2"
if "%custom_choice%"=="12" set "custom_link=%tool_path% %product_model% %product_model%NV33_%ota_version%_000_000000000000 %realmeui_version% 10011110 -r 2"
if "%custom_choice%"=="13" set "custom_link=%tool_path% %product_model% %product_model%NV38_%ota_version%_000_000000000000 %realmeui_version% 10011110 -r 2"

:: Only allow one link to be generated at a time
if defined custom_link (
    call :Link_Generation_Engine "%custom_link%"
    goto :EOF
)

:: Continue with predefined link selection if no custom link was set
goto :MapPredefinedChoice

:MapPredefinedChoice
set "predefined_link="

:: Clear custom_link if predefined is selected
if defined custom_link (
    echo A custom link has already been selected. Clearing it now...
    set "custom_link="  :: Clears the custom_link variable
    timeout /t 2 >nul
    goto DownloadMenu
)

:: Map predefined choices to respective links
if "%~1"=="1" set "predefined_link=%tool_path% RMX3840TR RMX3840NV51_11.A.00_000_000000000000 5 01010001 -r 0"
if "%~1"=="2" set "predefined_link=%tool_path% RMX3840RU RMX3840NV37_11.A.00_000_000000000000 5 00110111 -r 3"
if "%~1"=="3" set "predefined_link=%tool_path% RMX3840 RMX3840NVA6_11.A.00_000_000000000000 5 01110110 -r 2"
if "%~1"=="4" set "predefined_link=%tool_path% RMX3840 RMX3840NV83_11.A.00_000_000000000000 5 10000011 -r 3"
if "%~1"=="5" set "predefined_link=%tool_path% RMX3840IN RMX3840NV1B_11.A.00_000_000000000000 5 00011011 -r 3"
if "%~1"=="6" set "predefined_link=%tool_path% RMX3840EEA RMX3840NV44_11.A.00_000_000000000000 5 01000100 -r 2"
if "%~1"=="7" set "predefined_link=%tool_path% RMX3840 RMX3840NV39_11.A.00_0000_000000000000 5 00111001 -r 3"
if "%~1"=="8" set "predefined_link=%tool_path% RMX3840 RMX3840NV9A_11.A.00_000_000000000000 5 10011010 -r 3"
if "%~1"=="9" set "predefined_link=%tool_path% RMX3840 RMX3840NV9E_11.A.00_000_000000000000 5 10011110 -r 3"
if "%~1"=="10" set "predefined_link=%tool_path% RMX3840 RMX3840NV3E_11.A.00_000_000000000000 5 10011110 -r 2"
if "%~1"=="11" set "predefined_link=%tool_path% RMX3840 RMX3840NV1A_11.A.00_000_000000000000 5 10011110 -r 2"
if "%~1"=="12" set "predefined_link=%tool_path% RMX3840 RMX3840NV33_11.A.00_000_000000000000 5 10011110 -r 2"
if "%~1"=="13" set "predefined_link=%tool_path% RMX3840 RMX3840NV38_11.A.00_000_000000000000 5 10011110 -r 2"
if "%~1"=="14" set "predefined_link=%tool_path% RMX3840TR RMX3840NV51_11.C.00_000_000000000000 5 01010001 -r 0"
if "%~1"=="15" set "predefined_link=%tool_path% RMX3840RU RMX3840NV37_11.C.00_000_000000000000 5 00110111 -r 3"
if "%~1"=="16" set "predefined_link=%tool_path% RMX3840 RMX3840NVA6_11.C.00_000_000000000000 5 10100110 -r 3"
if "%~1"=="17" set "predefined_link=%tool_path% RMX3840 RMX3840NV83_11.C.00_000_000000000000 5 10000011 -r 3"
if "%~1"=="18" set "predefined_link=%tool_path% RMX3840IN RMX3840NV1B_11.C.00_000_000000000000 5 00011011 -r 3"
if "%~1"=="19" set "predefined_link=%tool_path% RMX3840EEA RMX3840NV44_11.C.00_000_000000000000 5 01000100 -r 2"
if "%~1"=="20" set "predefined_link=%tool_path% RMX3840 RMX3840NV39_11.C.00_000_000000000000 5 00111001 -r 3"
if "%~1"=="21" set "predefined_link=%tool_path% RMX3840 RMX3840NV9A_11.C.00_000_000000000000 5 10011010 -r 3"
if "%~1"=="22" set "predefined_link=%tool_path% RMX3840 RMX3840NV9E_11.C.00_000_000000000000 5 10011110 -r 3"
if "%~1"=="23" set "predefined_link=%tool_path% RMX3840 RMX3840NV3E_11.C.00_000_000000000000 5 10011110 -r 2"
if "%~1"=="24" set "predefined_link=%tool_path% RMX3840 RMX3840NV1A_11.C.00_000_000000000000 5 10011110 -r 2"
if "%~1"=="25" set "predefined_link=%tool_path% RMX3840 RMX3840NV33_11.C.00_000_000000000000 5 10011110 -r 2"
if "%~1"=="26" set "predefined_link=%tool_path% RMX3840 RMX3840NV38_11.C.00_000_000000000000 5 10011110 -r 2"

:: Pass predefined link to the download engine
call :Link_Generation_Engine "%predefined_link%"
goto :EOF

:: ========================================
:: Function: Link_Generation_Engine
:: Description: Executes OTAFinder, processes JSON output, and handles the download.
:: ========================================

:Link_Generation_Engine
:: Generate JSON using OTAFinder.exe
set command=%~1

:: Execute OTAFinder and generate JSON output
    %command% > temp.json

:: Check for execution errors and handle accordingly
if %errorlevel% neq 0 (
    echo Failed to generate JSON output.
    pause
    del temp.json >nul 2>&1
    goto DownloadMenu
)

:: ========================================
:: Extract Manual URL from the generated JSON
:: ========================================
set "rawurl="
for /f "tokens=3 delims=:," %%A in ('findstr /i "\"manualUrl\"" temp.json') do (
    set rawurl=%%A
)

:: Clean up the URL by removing extra characters
set "rawurl=%rawurl:~1%"
set "extracted_url=https://%rawurl:~0,-1%"

echo Extracted URL: %extracted_url%

:: ========================================
:: Extract Asset ID (aid) from the generated JSON
:: ========================================
set "aid="
for /f "tokens=2 delims=:," %%A in ('findstr /i "\"aid\"" temp.json') do (
    set aid=%%A
)

:: Clean up the aid value by removing any quotes or extra spaces
set "aid=%aid:"=%"
set "aid=%aid: =%"

:: If aid is not found, set it to empty
if not defined aid (
    set "aid="
)

echo Asset ID: %aid%

:: ========================================
:: Extract Version Name from the generated JSON
:: ========================================
set "version_name="
for /f "tokens=2 delims=:," %%A in ('findstr /i "\"versionName\"" temp.json') do (
    set version_name=%%A
)

:: Clean up version_name (remove leading/trailing spaces or quotes)
set "version_name=%version_name:~1%"
set "version_name=%version_name:~0,-1%"

:: If version_name is not found, set it to empty
if not defined version_name (
    set "version_name="
)

echo Version Name: %version_name%
echo.

:: Get the user's Downloads folder using environment variables
set "downloads_folder=%USERPROFILE%\Downloads"

:: Ensure the path exists
if not exist "%downloads_folder%" (
    echo [Error] Unable to locate the Downloads folder. Using current directory instead.
    set "downloads_folder=%CD%"
)

:: Construct the OTA download path inside the Windows Downloads folder
set "download_path=%downloads_folder%\%aid%.zip"


:: Download the extracted URL using curl and handle errors
:: Check if a partial download exists
if exist "%download_path%" (
    echo Resuming previous download...
    curl -C - --progress-bar -o "%download_path%" "%extracted_url%"
) else (
    echo Starting new download...
    curl -C - --progress-bar -o "%download_path%" "%extracted_url%"
)

if %errorlevel% neq 0 (
    echo Download failed. Please check the URL or try again.
    del temp.json >nul 2>&1
    pause
    goto DownloadMenu
)

:: Successfully downloaded file
echo Download complete. File saved as "%download_path%"

:: Clean up temp file after operation
del temp.json >nul 2>&1

:: Proceed to next operation
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
echo  1. RMX3840 TR                  14. RMX3840 TR
ping 127.0.0.1 -n 1 -w 200 >nul
echo  2. RMX3840 RU                  15. RMX3840 RU
echo  3. RMX3840 MEA                 16. RMX3840 MEA
ping 127.0.0.1 -n 1 -w 200 >nul
echo  4. RMX3840 SA                  17. RMX3840 SA
echo  5. RMX3840 IN                  18. RMX3840 IN
echo  6. RMX3840 EU                  19. RMX3840 EU
ping 127.0.0.1 -n 1 -w 200 >nul
echo  7. RMX3840 TH                  20. RMX3840 TH
echo  8. RMX3840 LATAM               21. RMX3840 LATAM
echo  9. RMX3840 BR                  22. RMX3840 BR
ping 127.0.0.1 -n 1 -w 200 >nul
echo 10. RMX3840 PH                  23. RMX3840 PH
echo 11. RMX3840 TW                  24. RMX3840 TW
ping 127.0.0.1 -n 1 -w 200 >nul
echo 12. RMX3840 ID                  25. RMX3840 ID
echo 13. RMX3840 MY                  26. RMX3840 MY
ping 127.0.0.1 -n 1 -w 200 >nul
echo.
echo ==============================================================================
ping 127.0.0.1 -n 1 -w 200 >nul
echo.
set /p "choice=Enter your choice (1-26): "
echo.
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

:DownloadChineseOTA
call :Header "Download Chinese OTA"
echo You have selected to download the Chinese FULL OTA.
echo.

:: Prompt for device codename
set /p "product_model=Enter your device codename (e.g., RMX3841): "
if "%product_model%"=="" (
    echo [Error] Invalid device codename. Please try again.
    timeout /t 2 >nul
    goto DownloadChineseOTA
)
echo.

:: OTA Version Selection
echo Select the OTA version for your device:
echo 1. 11.A.00 (Android 12, 13, 14)
echo 2. 11.C.00 (Android 15)
echo 3. Enter OTA Version Manually
echo.
set /p "ota_version_choice=Enter your choice (1, 2, or 3): "
echo.

:: Determine OTA Version
if "%ota_version_choice%"=="1" (
    set "ota_version=11.A.00"
) else if "%ota_version_choice%"=="2" (
    set "ota_version=11.C.00"
) else if "%ota_version_choice%"=="3" (
    set /p "ota_version=Enter the OS version manually (e.g., 11.A.00): "
    if "%ota_version%"=="" (
        echo [Error] Invalid OS version. Please try again.
        timeout /t 2 >nul
        goto DownloadChineseOTA
    )
) else (
    echo [Error] Invalid choice. Please select 1, 2, or 3.
    timeout /t 2 >nul
    goto DownloadChineseOTA
)

:: Realme UI Version Prompt
set /p "realmeui_version=Enter your Realme UI version (e.g., 1, 2, 3, 4, 5, 6): "
if "%realmeui_version%"=="6" set "realmeui_version=5"  :: Convert 6 to 5 automatically

:: Validate Realme UI version
if "%realmeui_version%"=="" (
    echo [Error] Invalid Realme UI version. Please try again.
    timeout /t 2 >nul
    goto DownloadChineseOTA
)
echo.

:: Construct the command to generate JSON
set "china_link=%tool_path% %product_model% %product_model%NV97_%ota_version%_000_000000000000 %realmeui_version% -v0 -r 1 -d china.json"

:: Run the command silently
%china_link% >nul 2>&1

:: Simulate processing time
timeout /t 7 >nul

:: Check if the JSON file was created
if not exist china.json (
    echo [Error] Failed to create china.json. Please check the command parameters.
    pause
    goto DownloadMenu
)

:: ===================== Properly Extract & Clean URL =====================
set "china_url="
for /f "tokens=3 delims=:," %%A in ('findstr /i "\"manualUrl\"" china.json') do (
    set "china_url=%%A"
)

:: Trim spaces and remove extra characters
set "china_url=%china_url: =%"
set "china_url=%china_url:~1,-1%"

:: Ensure the extracted URL starts correctly with "https://"
if not "%china_url:~0,8%"=="https://" (
    set "china_url=https://%china_url%"
)

:: Remove extra forward slashes if present in "https:///"
set "china_url=%china_url:https:///=https://%"

:: Validate extracted URL
if "%china_url%"=="" (
    echo [Error] Failed to extract the OTA download URL. Please try again.
    del china.json >nul 2>&1
    pause
    goto DownloadMenu
)

echo Extracted Download URL: %china_url%
echo.
:: ===================== Extract Asset ID (aid) for NV97_11.X Only =======================
set "aid="

:: Loop through JSON and extract only `aid` values containing "NV97_11."
for /f "tokens=2 delims=:," %%A in ('findstr /i "\"aid\"" china.json') do (
    set "temp_aid=%%A"
    set "temp_aid=!temp_aid:"=!"  :: Remove quotes
    set "temp_aid=!temp_aid: =!"  :: Remove spaces

    :: Check if extracted aid contains "NV97_11."
    echo !temp_aid! | findstr /I "NV97_11." >nul
    if not errorlevel 1 (
        for /f "tokens=2 delims=_" %%B in ("!temp_aid!") do (
            set "aid=NV97_%%B"
        )
    )
)

:: If aid is still empty, notify the user
if not defined aid (
    echo [Error] No matching Asset ID found for NV97_11.X.
    set "aid=Not Found"
)

echo Extracted Asset ID: %aid%

:: ===================== Extract versionName =====================
set "version_name="
for /f "tokens=2 delims=:," %%A in ('findstr /i "\"versionName\"" china.json') do (
    set "version_name=%%A"
)

:: Cleanup version name
set "version_name=%version_name:"=%"
set "version_name=%version_name: =%"

:: Default version name if extraction fails
if not defined version_name (
    set "version_name=Unknown_Version"
)

:: Show extracted version name
echo OTA Version Name: %version_name%
echo.

:: Get the user's Downloads folder using environment variables
set "downloads_folder=%USERPROFILE%\Downloads"

:: Ensure the path exists
if not exist "%downloads_folder%" (
    echo [Error] Unable to locate the Downloads folder. Using current directory instead.
    set "downloads_folder=%CD%"
)

:: Construct the OTA download path inside the Windows Downloads folder
set "ota_path=%downloads_folder%\%version_name%%aid%.zip"

:: ===================== Start OTA Download with Resume Support =====================
if exist "%ota_path%" (
    echo [INFO] Resuming previous download...
    curl -C - --progress-bar -o "%ota_path%" "%china_url%"
) else (
    echo [INFO] Starting new download...
    curl --progress-bar -o "%ota_path%" "%china_url%"
)

:: Check if download was successful
if %errorlevel% neq 0 (
    echo [Error] Download failed. Please check your internet connection or the provided URL.
    pause
    goto DownloadMenu
)

:: Confirm successful download
echo Download completed successfully. File saved in: "%ota_path%"

:: Log the download
echo [%date% %time%] Downloaded %version_name%.zip to %ota_path% from %china_url% >> download_log.txt

:: Open Downloads folder after successful download
start "" "%downloads_folder%"

:: Return to main menu
goto MainMenu


:GetHelp
call :Header "Get Help" %pg%
echo.
echo Who would you like to contact?
echo.
echo    1. Contact @CodeSenseiX
ping 127.0.0.1 -n 1 -w 200 >nul
echo.
echo    2. Contact @parth_sancheti
ping 127.0.0.1 -n 1 -w 200 >nul
echo.
echo    3. Need Help Regarding device info
ping 127.0.0.1 -n 1 -w 200 >nul
echo.
echo    4. Go Back
ping 127.0.0.1 -n 1 -w 200 >nul
echo.
set /p "choice=Select an option (1-3): "
if "%choice%" == "1" start https://t.me/CodeSenseiX & goto MainMenu
if "%choice%" == "2" start https://t.me/parth_sancheti & goto MainMenu
if "%choice%" == "3" start https://t.me/RealmeInfoBot & goto MainMenu
if "%choice%" == "4" goto MainMenu

call :Error_Handling GetHelp

:About
call :Header "About OTA Zip Downloader" %pg%                                                       
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

:: Header Function with Centered Text and Color
:Header
cls
set "border_line=-----------------------------------------------------------------------------"
:: Change to a new color for header
color 0B

:: Print the top border
echo %border_line%
echo.

:: Center-align the "Good Morning - Main Menu"
call :CenterText "%~2 - %~1"

:: Center-align the "Created By" section
call :CenterText "Created By: @CodeSenseiX"

echo.
:: Print the bottom border
echo %border_line%
ping 127.0.0.1 -n 1 -w 100 >nul
goto :EOF

:: CenterText function for proper alignment
:CenterText
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

:: Quit function with exit message
:Quit
cls
call :Spacer 10
echo                  "------------------------------------------"
echo                  "|                                        |"
ping 127.0.0.1 -n 1 -w 100 >nul
echo                  "| Thank You For Using OTA Zip Downloader |"
echo                  "|        Have A Great Day Ahead!          |"
echo                  "|                                        |"
ping 127.0.0.1 -n 1 -w 100 >nul
echo                  "-----------------------------------------"
call :Spacer 6
timeout /t 2 >nul
exit

:: Error Handling to return to main menu
:Error_Handling
call :Header "Error Handling" %pg%
echo Please ensure you've selected a valid option.
echo Redirecting...
timeout /t 1 >nul
goto %1

:: Spacer for spacing between text outputs
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
set maintainers=@CodeSenseiX
set version=v2.4
title Realme OTA Zip Downloader
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
    rem Convert hour to a 24-hour format if needed
    if %hour% lss 12 (
        set pg="Good Morning!"
    ) else if %hour% lss 17 (
        set pg="Good Afternoon!"
    ) else if %hour% lss 20 (
        set pg="Good Evening!"
    ) else (
        set pg="Good Night!"
    )
goto :EOF


