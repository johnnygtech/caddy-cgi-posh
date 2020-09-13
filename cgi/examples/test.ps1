#!/usr/bin/env pwsh
$output += "Content-Type: text/plain`n`n"
$output += "Hello world"
#$PSDefaultParameterValues['Out-File:Encoding'] = 'utf8'
write-output $output
#Get-date