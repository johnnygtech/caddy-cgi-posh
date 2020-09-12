$output += "Content-Type: text/plain`n`n"
$output += "Hello world`n`n"
#$PSDefaultParameterValues['Out-File:Encoding'] = 'utf8'
write-output $output
#Get-date