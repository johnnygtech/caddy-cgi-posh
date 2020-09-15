#!/usr/bin/env pwsh
#if(-not $(get-module pshtml -erroraction silentlycontinue)){Install-module pshtml -scope currentuser}
import-module pshtml
$contentType = "Content-Type: text/html`n`n"
$content= html {
    head {
        #Write-PSHTMLAsset -Type Script -Name BootStrap #this doesn't put the assets in the local folder?  hmm come back to it later.
    }
    body {
        h1 "PSHTML"
        p {"demonstrate pshtml"}
        div {
            $( Get-Module pshtml | select -Property ModuleType, Version, Name) | ConvertTo-PSHTMLTable
        }
    }
}
return "$ContentType$Content"