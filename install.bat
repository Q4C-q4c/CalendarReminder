@echo off
title Calendar Reminder - Installer标题日历提醒-安装程序

echo ================================================回声  ================================================
echo   Calendar Reminder v2 - Installecho日历提醒v2 -安装
echo ================================================回声  ================================================
echo.   的回声。

set "INSTALL_DIR=%APPDATA%\CalendarReminder"s   年代et "INSTALL_DIR=%APPDATA%\CalendarReminder"

echo [1/3] Installing files...echo[1/3]安装文件…

if exist "%INSTALL_DIR%" rmdir /s /q "%INSTALL_DIR%" 2>nulif存在“ %INSTALL_DIR% ” rmdir /s   年代 /q " %INSTALL_DIR% " 2 " gt;nul
mkdir "%INSTALL_DIR%"   mkdir "%INSTALL_DIR%"

robocopy "%~dp0CalendarReminder" "%INSTALL_DIR%\CalendarReminder" /E /NP /NFL /NDL /NJH /NJSrobocopy“%~dp0CalendarReminder”“%INSTALL_DIR%\CalendarReminder”/E /NP /NFL /NDL /NJH /NJS
robocopy "%~dp0ManageReminders" "%INSTALL_DIR%\ManageReminders" /E /NP /NFL /NDL /NJH /NJSrobocopy“%~dp0ManageReminders   年代”%INSTALL_DIR%\ManageReminders   年代“/E /NP /NFL /NDL /NJH /NJS
copy /Y "%~dp0reminders.json" "%INSTALL_DIR%\" >nulcopy /Y "%~dp0reminders   年代.js   年代on" "%INSTALL_DIR%\" >nul
echo        Installed to: %INSTALL_DIR%echo安装到：%INSTALL_DIR%

echo.   的回声。
echo [2/3] Adding to startup...echo[2/3]添加到启动…
copy /Y "%~dp0startup.vbs" "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\calendar_reminder.vbs" >nulcopy /Y "%~dp0s   年代tartup.vbs   年代" "；%APPDATA%\Micros   年代oft\Windows   年代\开始菜单\程序\S   年代tartup\ calendar_reminders   年代 .vbs   年代"
echo        Startup configured

echo.   的回声。
echo [3/3] Creating desktop shortcut...echo[3/3]创建桌面快捷方式…
set "LNK=%USERPROFILE%\Desktop\Calendar Reminder.lnk"s   年代et "；LNK=%USERPROFILE%\Des   年代ktop\Calendar提醒。LNK "；
set "TARGET=%INSTALL_DIR%\ManageReminders\ManageReminders.exe"拍摄" TARGET = % INSTALL_DIR % ManageReminders   年代喝ManageReminders   年代.exe"
cscript //Nologo "%~dp0mklnk.vbs" "%LNK%" "%TARGET%" >nul 2>&1cs   年代cript //Nologo "%~dp0mklnk.vbs   年代" "%LNK%" "%TARGET%" >nul 2>&1
echo        Desktop shortcut created创建桌面快捷方式

echo.   的回声。
echo ================================================回声  ================================================
echo   Install complete!   安装完成！
echo.   的回声。
echo   Auto-start on boot: ENABLED
echo   Desktop shortcut: Calendar Reminder桌面快捷方式：日历提醒
echo.   的回声。
echo   To uninstall, run: uninstall.batecho执行：unins   年代tall.bat命令卸载
echo ================================================回声  ================================================
pause   暂停
exit /b 0   出口/b 0
