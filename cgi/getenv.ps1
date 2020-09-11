$contentType="Content-Type: text/plain`n`n"
$body=$(convertto-json $(get-item env:))
return "$contentType$body"