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

$contentType="Content-Type: application/json`n`n"

$default="Content-Type: text/html`n`n
<html>
    <body>
        <h1>Profile</h1>
        <p>Profile is an api endpoint to manage a powershell profile behind the Posh-Caddy Server Stack </p>
    </body>
</html>
"

#handle request methods
switch($env:REQUEST_METHOD)
{
    "GET"
    {
        if($(Test-Path $Profile))
        {
            $profilePath = Get-Item $Profile | select -ExpandProperty FullName # | out-null
            $profileContent = Get-Content $Profile # | out-null
            return "$contentType$(ConvertTo-json @{"Status"=200;"Path"="$profilepath";"Content"="$profilecontent"})"
            #return "$contentType$(ConvertTo-json @{"Status"=204;"message"="no content"})"
            #return $default
        }
        else
        {
            return "$contentType$(ConvertTo-json @{"Status"=204;"message"="no content"})"
        }
    }
    "PUT"
    {
        $PostDataHashTable=$(ConvertFrom-Json $input) | ConvertTo-HashTable
        if((-not $([string]::isnullorempty($postDataHashTable.Profile))))
        {
            set-content -value $PostDataHashTable.Profile -path $profile
            if($?)
            {
                return "$contentType$(ConvertTo-json @{"Status"=201;"message"="profile created successfully"})"
            }
            else
            {
                return "$contentType$(ConvertTo-json @{"Status"=500;"message"="An error occurred creating profile"})"
            }
        }
        else
        {
            return "$contentType$(ConvertTo-json @{"Status"=400;"message"="bad request"})"
        }
    }
    "DELETE"
    {
        Remove-Item $profile
        if($?)
        {
            return "$contentType$(ConvertTo-json @{"Status"=201;"message"="profile created successfully"})"
        }
        else
        {
            return "$contentType$(ConvertTo-json @{"Status"=500;"message"="An error occurred creating profile"})"
        }
    }
    "PATCH"
    {
        $PostDataHashTable=$(ConvertFrom-Json $input) | ConvertTo-HashTable
        if((-not $([string]::isnullorempty($postDataHashTable.ProfilePatch))))
        {
            Add-content -value $PostDataHashTable.ProfilePatch -path $profile
            if($?)
            {
                return "$contentType$(ConvertTo-json @{"Status"=201;"message"="profile appended successfully"})"
            }
            else
            {
                return "$contentType$(ConvertTo-json @{"Status"=500;"message"="An error occurred appending profile"})"
            }
        }
        else
        {
            return "$contentType$(ConvertTo-json @{"Status"=400;"message"="bad request"})"
        }
    }
    default { return "$contentType$(Convertto-json @{"responsecode"="501";"response"="method not immplemented: $env:REQUEST_METHOD"} )" }

}