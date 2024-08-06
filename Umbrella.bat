@echo off
setlocal

REM Check if the script is running with administrator privileges

NET SESSION >NUL 2>NUL
if %ERRORLEVEL% EQU 0 (
    echo Running with administrator privileges.
) else (
    echo This script requires administrator privileges. Please run as an administrator.
    pause
    goto :EOF
)


:MainMenu
cls
echo   1. Check service status
echo   2. Start the service
echo   3. Stop the service
echo   4. Quit
echo.


choice /C 1234 /M "Enter your choice: "
if %errorlevel% equ 1 (
    goto CheckStatus
) else if %errorlevel% equ 2 (
    goto StartService
) else if %errorlevel% equ 3 (
    goto StopService
) else if %errorlevel% equ 4 (
    goto EndScript
)


:CheckStatus
echo.
echo Checking CSC_VpnAgent service status...
sc query csc_vpnagent | find "STATE" | find /i "RUNNING" > nul
if %errorlevel% equ 0 (
    echo CSC_VpnAgent service is currently running.
) else (
    echo CSC_VpnAgent service is currently not running.
)
pause
goto MainMenu




:StartService
echo.
echo Starting CSC_VpnAgent service... holdup
sc start csc_vpnagent
timeout /t 5 > nul
sc query csc_vpnagent | find "STATE" | find /i "RUNNING" > nul
if %errorlevel% equ 0 (
    echo CSC_VpnAgent service started successfully.
) else (
    echo Failed to start CSC_VpnAgent service.
)
pause
goto MainMenu

:StopService
echo.
echo Stopping CSC_VpnAgent service... holdup
sc stop csc_vpnagent
timeout /t 5 > nul
sc query csc_vpnagent | find "STATE" | find /i "RUNNING" > nul
if %errorlevel% neq 0 (
    echo CSC_VpnAgent service stopped successfully.
) else (
    echo Failed to stop CSC_VpnAgent service.
)
pause
goto MainMenu

:EndScript
echo.
echo Exiting the VPN Service Control script...
timeout /t 2 > nul
goto :EOF
