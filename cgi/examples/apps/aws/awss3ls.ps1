#!/usr/bin/env pwsh
#if(-not $(get-module pshtml -erroraction silentlycontinue)){Install-module pshtml -scope currentuser}
import-module pshtml
$contentType = "Content-Type: text/html`n`n"
$content= html {
    head {
        #Write-PSHTMLAsset -Type Script -Name BootStrap #this doesn't put the assets in the local folder?  hmm come back to it later.
    }
    body {
        h1 "aws s3 command execution example"
        p "The results of the command will show up below... todo... figure out how to show errors if one occurs"
        div {
           $($data = aws s3 ls ); p { if($?){write-output $($data | ConvertTo-PSHTMLTable)}else{write-output "failed to load aws data"} }
        }
    }
}
return "$ContentType$Content"