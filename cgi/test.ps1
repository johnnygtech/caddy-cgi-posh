#!C:\WINDOWS\System32\WindowsPowerShell\v1.0\powershell.exe -File
$output += "Content-Type: text/plain`n`n"
$output += "Hello world"
#$PSDefaultParameterValues['Out-File:Encoding'] = 'utf8'
write-output $output
#Get-date