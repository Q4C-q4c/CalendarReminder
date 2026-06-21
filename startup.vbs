Dim objShell, appData, exeDir, exePath
Set   集 objShell = CreateObject("WScript.Shell"   "WScript.Shell"   "WScript.Shell")
appData = objShell.ExpandEnvironmentStrings("%APPDATA%")
exeDir = appData & "\CalendarReminder\CalendarReminder"
exePath = exeDir & "\CalendarReminder.exe"
objShell.CurrentDirectory = exeDir
objShell.Run """" & exePath & """", 0, False
