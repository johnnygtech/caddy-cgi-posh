#!/usr/bin/env pwsh

$contentType="Content-Type: text/plain`n`n"
$body=""

$body += "Query Strings = $($env:QUERY_STRING -split "&")`n`n"
$body += "Post Body = $($input)"


return "$contentType$body"