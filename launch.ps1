
switch([environment]::OSVersion.Platform)
{
    "Unix" 
        {
            $relserverbin="./bin/caddy-cgi"
            $relcaddyfile = "Caddyfile-Linux-Minimalistic"
        }

    "Win32NT"
        {
            $relserverbin = "./bin/caddy-cgi.exe"
            $relcaddyfile = "Caddyfile-Windows-Minimalistic"
        }
    default
        {
            Write-Error "$_ Not Implemented"
            return
        }
}


$serverbin = $(get-item $relserverbin).fullname
$caddyfile = $(get-item $relcaddyfile).fullname

#start the server with specified caddyfile for os
& $serverbin start --config $caddyfile

Write-host "waiting for server to start before running tests"
Start-sleep -seconds 3
./tests.ps1

Write-host "Run '& `$serverbin stop' to stop the server "
#& $serverbin stop
# run as background job.  (kinda does this on its own so likely overkill?)
#specify a caddy file
#start-job -scriptblock {set-location $(get-item $args[0]).directory; & $args[0] start $args[1]} -argumentlist $serverbin,$caddyfile
#default caddyfile
#start-job -scriptblock {set-location $(get-item $args[0]).directory; & $args[0] start} -argumentlist $serverbin

#$config = $(get-content -raw ./config.json)
#Invoke-WebRequest -Method post -Body $config -uri http://localhost:2019/load -header @{"Content-Type"="application/json"} -UseBasicParsing