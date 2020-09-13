#!/usr/bin/env pwsh

#use this function if psversion -lt 6?
function ConvertTo-Hashtable
{
#http://stackoverflow.com/questions/22002748/hashtables-from-convertfrom-json-have-different-type-from-powershells-built-in-h
    param (
        [Parameter(ValueFromPipeline)]
        $InputObject
    )
    process
    {
        if ($null -eq $InputObject) { return $null }
        if ($InputObject -is [System.Collections.IEnumerable] -and $InputObject -isnot [string])
        {
            $collection = @(
                foreach ($object in $InputObject) { ConvertTo-Hashtable $object }
            )
            Write-Output -NoEnumerate $collection
        }
        elseif ($InputObject -is [psobject])
        {
            $hash = @{}
            foreach ($property in $InputObject.PSObject.Properties)
            {
                $hash[$property.name] = ConvertTo-Hashtable $property.Value
            }
            $hash
        }
        else
        {
            $InputObject
        }
    }
}

$default="Content-Type: text/html`n`n
<html>
    <body>
        <h1>Splatter</h1>
        <p>Splatter is a powershell handler for posh-caddy that combines http query string or post data to form and execute a powershell command and return the results</p>
        <a href=`"http://localhost:9002/apps/splatter?command=get-date`">Example: Get-Date</a>
    </body>
</html>
"     

#handle request methods
switch($env:REQUEST_METHOD)
{
    "GET"
        {
            Write-verbose "Method is GET: Check query string"
            if(-not $([string]::isnullorempty($env:QUERY_STRING))) #user gave us something to do
            {
                #force content type, this is a decision to always return json
                $contentType="Content-Type: application/json`n`n"

                #split
                $queryStringSplit=$($env:QUERY_STRING -split "&")
                $queryStringHashTable=@{} #hash table to easily handle paramters
                $command=$null
                $queryStringSplit | %{ #build hash table
                    $entry = $_ -split "=" 
                    if($entry[0] -eq "command"){$command = $entry[1]}else #look for command entry and don't add it to hashtablea
                    {$queryStringHashTable.Add($entry[0],$($entry[1]))} #hash table is for splatting!
                }
                if(-not $command)
                {
                    return "$contentType$(Convertto-json @{"responsecode"="404";"reponse"="command not provided"})"
                }
                else
                {
                    Write-Verbose "Executing Command: $Command `r`n"
                    return "$contentType$(convertto-json $(& $command @queryStringHashTable))"
                }
            }
            else  #return standard splash page
            {
                return $default
            }
        }
    "POST"
        {
            #force content type, this is a decision to always return json
            $contentType="Content-Type: application/json`n`n"
            $fullinput=$input
                
            $PostDataHashTable=$(ConvertFrom-Json $fullinput) | ConvertTo-HashTable
            $command=$null

            #Extract COmmand
            $command = $PostDataHashTable."command"
            if(-not $command)
            {
                return "$contentType$(Convertto-json @{"responsecode"="404";"reponse"="command not provided: $command";"postdata"=$PostDataHashTable})"
            }
            else
            {
                $PostDataHashTable.remove("command");
                return "$contentType$(convertto-json $(& $command @PostDataHashTable))"
            }

            return Convertto-json @{"responsecode"="404";"reponse"="command execution failed"}

        }
    default { return Convertto-json @{"responsecode"="404";"reponse"="method not found: $env:REQUEST_METHOD"} }
}

