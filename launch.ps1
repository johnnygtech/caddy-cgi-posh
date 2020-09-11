$relserverbin="./caddy-cgi.exe"
$serverbin = $(get-item $relserverbin).fullname

$relcaddyfile = "./Caddyfile"
$caddyfile = $(get-item $relcaddyfile).fullname

#specify a caddy file
#start-job -scriptblock {set-location $(get-item $args[0]).directory; & $args[0] start $args[1]} -argumentlist $serverbin,$caddyfile

#start-job -scriptblock {set-location $(get-item $args[0]).directory; & $args[0] start} -argumentlist $serverbin

& $serverbin start

iwr http://localhost:9002/test

#$config = $(get-content -raw ./config.json)
#Invoke-WebRequest -Method post -Body $config -uri http://localhost:2019/load -header @{"Content-Type"="application/json"} -UseBasicParsing