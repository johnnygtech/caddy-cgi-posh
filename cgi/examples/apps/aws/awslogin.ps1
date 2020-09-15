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
        <h1>AWS Login</h1>
        <p>AWS Login is a powershell handler for posh-caddy that accepts aws cli input parameters and generates a profile uniqe to those credentials</p>
        <p>It returns a guid and a secret which must be used together as authorization header to call other aws endpoints</p>

    </body>
</html>
" 



return "$default"