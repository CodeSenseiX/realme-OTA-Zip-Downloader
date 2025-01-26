:: Define the bold CSX with the new logo
set "C1=   _________            .___       _________               _________      .______  ___  "
set "C2=  \_   ___ \  ____   __| _/____  /   _____/ ____   ____  /   _____/ ____ |__\   \/  /  "
set "C3= /    \  \/ /  _ \ / __ |/ __ \ \_____  \_/ __ \ /    \ \_____  \_/ __ \|  |\     /    "
set "C4= \     \___(  <_> ) /_/ \  ___/ /        \  ___/|   |  \/        \  ___/|  |/     \   "
set "C5=  \______  /\____/\____ |\___  >_______  /\___  >___|  /_______  /\___  >__/___/\  \  "
set "C6=         \/            \/    \/        \/     \/     \/        \/     \/         \_/   "

:: Slide the text
for /l %%i in (10,-1,0) do (
    cls
    echo  ^> ^> ^> ^> ^> ^> ^> ^> 
    echo.
    echo.
    echo.
    echo.
    echo.
    echo.
    echo.
    echo.
    echo.
    echo.
    echo                 !C1:~%%i!
    echo                 !C2:~%%i!
    echo                 !C3:~%%i!
    echo                 !C4:~%%i!
    echo                 !C5:~%%i!
    echo                 !C6:~%%i!
    ping 127.0.0.1 -n 1 -w 200 >nul
)

echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo					                               ^< ^< ^< ^< ^< ^< ^< ^<
