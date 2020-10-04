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

SEt-location C:\Users\johng\OneDrive\Desktop\caddy-cgi-posh\data\

$default="Content-Type: text/html`n`n
<html>
    <body>
        <h1>AWS Login</h1>
        <h2>WIP - currently write access is either not working / permisssion denied / or poorly implemented at the moment.  This isn't working.
        <p>AWS Login is a powershell handler for posh-caddy that accepts aws cli configure parameters and generates a profile uniqe to those credentials</p>
        <p>It returns a guid and a secret which must be used together as authorization header to call other aws endpoints</p>
    </body>
</html>
" 

$contentType="Content-Type: application/json`n`n"

$ErrorList = @{
    400="$contentType$(Convertto-json @{"responsecode"="400";"response"="Bad Request"})";
}

#static splat template / required arguments list via $AwsConfigureSplat.keys
$AWSconfigureSplat=@{
    AWS_ACCESS_KEY_ID="";
    AWS_SECRET_ACCESS_KEY="";
    AWS_DEFAULT_REGION="";
}


function Test-RequiredArguments
{
    param($argumentsToTest,$requiredArguments)
    # if passed arguments don't exactly match the list of required arguments return false
    if( Compare-Object $argumentsToTest $requiredArguments )
    {
        return $false
    }
    return $true
}

function Process-Login
{
    param($currentArguments)

    $generatedProfilekey = [guid]::newGuid().Guid 
                
    #aws configure set region us-west-1 --profile testing
    $command="aws"
    
    #eventually call aws configure using aws powershell so we can splat the record....
    try{
    #try set region
        & $command configure set region $($currentArguments.region) --profile $generatedProfilekey
        & $command configure set aws_access_key_id $($currentArguments.aws_access_key_id) --profile $generatedProfilekey
        & $command configure set aws_secret_access_key $($currentArguments.aws_secret_access_key) --profile $generatedProfilekey
        get-content ~/.aws/config | Out-null #try force error
        return "$contentType$(Convertto-json @{"responsecode"="200";"response"="session created";"sessiontoken"=$generatedProfilekey})"
    }
    catch
    {
        return "$contentType$(Convertto-json @{"responsecode"="500";"response"="error occurred creating profile";"additionalinformation"=$($error[0].Errors)})"
    }

}

switch($env:REQUEST_METHOD)
{
    "GET"
    {
        Write-verbose "Method is GET: Check query string"
        if(-not $([string]::isnullorempty($env:QUERY_STRING))) #user gave us something to do
        {
            #make hashtable from querystring
            $queryStringSplit=$($env:QUERY_STRING -split "&")
            $queryStringHashTable=@{} #hash table to easily handle paramters
            $command=$null
            $queryStringSplit | %{ #build hash table
                $entry = $_ -split "=" 
                if($entry[0] -eq "command"){$command = $entry[1]}else #look for command entry and don't add it to hashtablea
                {$queryStringHashTable.Add($entry[0],$($entry[1]))} #hash table is for splatting!
            }

            $currentArguments = $queryStringHashTable
            if(Test-RequiredArguments @($currentArguments.keys) @($AWSconfigureSplat.keys) )
            {
                Process-Login $currentArguments
            }
            else
            {
                #400 error - unsupported arguments passed
                return "$contentType$(Convertto-json @{"responsecode"="422";"response"="unsupported arguments passed";"arguments"=$currentArguments})"
            }   

        }
        else
        {
            return $default
        }
    }
    "POST"
    {
        $PostDataHashTable=$(ConvertFrom-Json $input) | ConvertTo-HashTable

        $currentArguments = $PostDataHashTable
        if(Test-RequiredArguments @($currentArguments.keys) @($AWSconfigureSplat.keys) )
        {
            Process-Login $currentArguments
        }
        else
        {
            #400 error - unsupported arguments passed
            return "$contentType$(Convertto-json @{"responsecode"="422";"response"="unsupported arguments passed";"arguments"=$currentArguments})"
        } 
    }
    default { return "$contentType$(Convertto-json @{"responsecode"="404";"response"="method not supported: $env:REQUEST_METHOD"} )" }

}