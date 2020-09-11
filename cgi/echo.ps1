$contentType="Content-Type: text/plain`n`n"
$body=""

$body += "`n`nQuery Strings = $($env:QUERY_STRING -split "&")`n`n"
$body += "Post Body = $($input)"
#return "Content-Type: text/plain`n`n $args"
return "$contentType$body"