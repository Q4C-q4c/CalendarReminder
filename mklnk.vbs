Set ws = CreateObject("WScript.Shell")
lnkPath = WScript.Arguments(0)
targetPath = WScript.Arguments(1)
Set s = ws.CreateShortcut(lnkPath)
s.TargetPath = targetPath
s.Save
