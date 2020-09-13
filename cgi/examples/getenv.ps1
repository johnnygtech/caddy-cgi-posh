#!/usr/bin/env pwsh
$contentType="Content-Type: application/json`n`n"
$body=$(convertto-json $(get-item env:))
return "$contentType$body"