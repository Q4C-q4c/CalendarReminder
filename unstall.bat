@echo off
title Calendar Reminder - Uninstaller
setlocal enabledelayedexpansion

echo ================================================回声  ================================================
echo   Calendar Reminder v2 - Complete Uninstall
echo ================================================
echo.

set "INSTALL_DIR=%APPDATA%\CalendarReminder"
set "STARTUP_VBS=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\calendar_reminder.vbs"
set "DESKTOP_LNK=%USERPROFILE%\Desktop\Calendar Reminder.lnk"
set "ERROR_FLAG=0"

:: ============================================
echo [1/5] Stopping running processes...
:: ============================================
taskkill /im CalendarReminder.exe /f 2>&1 | findstr /i "SUCCESS" >nul
if !errorlevel! equ 0 (
    echo        CalendarReminder.exe terminated
) else (
    echo        CalendarReminder.exe not running
)

taskkill /im ManageReminders.exe /f 2>&1 | findstr /i "SUCCESS" >nul
if !errorlevel! equ 0 (
    echo        ManageReminders.exe terminated
) else (
    echo        ManageReminders.exe not running
)

:: Wait for processes to fully exit
ping -n 3 127.0.0.1 >nul

tasklist /fi "imagename eq CalendarReminder.exe" 2>nul | findstr /i "CalendarReminder.exe" >nul
if !errorlevel! equ 0 (
    echo        [WARNING] CalendarReminder.exe still running!
    set "ERROR_FLAG=1"
)
tasklist /fi "imagename eq ManageReminders.exe" 2>nul | findstr /i "ManageReminders.exe" >nul
if !errorlevel! equ 0 (
    echo        [WARNING] ManageReminders.exe still running!
    set "ERROR_FLAG=1"
)

:: ============================================
echo.
echo [2/5] Removing from startup...
:: ============================================
if exist "%STARTUP_VBS%" (
    del /f /q "%STARTUP_VBS%"
    if exist "%STARTUP_VBS%" (
        echo        [FAILED] %STARTUP_VBS%
        set "ERROR_FLAG=1"
    ) else (
        echo        Removed: %STARTUP_VBS%
    )
) else (
    echo        No startup entry found
)

:: ============================================
echo.
echo [3/5] Removing all shortcuts...
:: ============================================

:: Desktop shortcut (standard location)
if exist "%DESKTOP_LNK%" (
    del /f /q "%DESKTOP_LNK%"
    if exist "%DESKTOP_LNK%" (
        echo        [FAILED] %DESKTOP_LNK%
        set "ERROR_FLAG=1"
    ) else (
        echo        Removed: %DESKTOP_LNK%
    )
) else (
    echo        No desktop shortcut at standard location
)

:: Also check shortcuts in subfolders under Desktop
for /f "delims=" %%D in ('dir /b /ad "%USERPROFILE%\Desktop" 2^>nul') do (
    if exist "%USERPROFILE%\Desktop\%%D\Calendar Reminder.lnk" (
        del /f /q "%USERPROFILE%\Desktop\%%D\Calendar Reminder.lnk"
        if exist "%USERPROFILE%\Desktop\%%D\Calendar Reminder.lnk" (
            echo        [FAILED] %USERPROFILE%\Desktop\%%D\Calendar Reminder.lnk
            set "ERROR_FLAG=1"
        ) else (
            echo        Removed: %USERPROFILE%\Desktop\%%D\Calendar Reminder.lnk
        )
    )
)

:: ============================================
echo.
echo [4/5] Removing installed program files...
:: ============================================
if exist "%INSTALL_DIR%" (
    rmdir /s /q "%INSTALL_DIR%" 2>&1
    if exist "%INSTALL_DIR%" (
        echo        [FAILED] %INSTALL_DIR%
        echo        Retrying after delay...
        ping -n 3 127.0.0.1 >nul
        rmdir /s /q "%INSTALL_DIR%" 2>&1
        if exist "%INSTALL_DIR%" (
            echo        [FAILED] Cannot remove. Reboot and try again.
            set "ERROR_FLAG=1"
        ) else (
            echo        Removed: %INSTALL_DIR%
        )
    ) else (
        echo        Removed: %INSTALL_DIR%
    )
) else (
    echo        No installed files found
)

:: ============================================
echo.   的回声。
echo [5/5] Removing installer package...
:: ============================================
echo        This will delete the installer folder itself.

:: Schedule self-deletion: create a temp script that runs after we exit
:: Compute paths now while we're in the right context
set "SELF_DIR=%~dp0"
:: Remove trailing backslash for parent calculation
if "%SELF_DIR:~-1%"=="\" set "SELF_DIR=%SELF_DIR:~0,-1%"
for %%d in ("%SELF_DIR%") do set "PARENT_DIR=%%~dpd"
if "%PARENT_DIR:~-1%"=="\" set "PARENT_DIR=%PARENT_DIR:~0,-1%"
set "DELAYED_CLEAN=%TEMP%\__calrem_cleanup.bat"
(
    echo @echo off
    echo timeout /t 3 /nobreak ^>nul
    echo if exist "%SELF_DIR%" rmdir /s /q "%SELF_DIR%" 2^>nul
    echo if exist "%PARENT_DIR%" rmdir "%PARENT_DIR%" 2^>nul
    echo del "%%~f0" 2^>nul
) > "%DELAYED_CLEAN%"

start "" /min cmd /c "%DELAYED_CLEAN%"

echo        Installer folder scheduled for deletion
echo        (cleanup completes 2 seconds after this window closes)

:: ============================================
echo.   的回声。
echo ================================================回声  ================================================
if !ERROR_FLAG! equ 0 (
    echo   Uninstall SUCCESSFUL!
) else (
    echo   Uninstall completed with some ERRORS.
    echo   Reboot and re-run if files remain.
)
echo ================================================回声  ================================================
pause   暂停
exit /b !ERROR_FLAG!
