#!/usr/bin/env pwsh
$body=$input
$contentType="Content-Type: text/plain`n`n"
return "$contentType$body"