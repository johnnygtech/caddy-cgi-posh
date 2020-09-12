$greenCheck = @{
    Object = [Char]8730
    ForegroundColor = 'Green'
    NoNewLine = $true
    }

$expected="Hello world"

if($($(Invoke-WebRequest http://localhost:9002/test | select -ExpandProperty content) -match $expected)){write-host @greencheck}
if($($(Invoke-WebRequest http://localhost:9002/test.ps1 | select -ExpandProperty content) -match $expected)){write-host @greencheck}

if($($(Invoke-WebRequest "http://localhost:9002/echo?test=hello world" | select -ExpandProperty content) -match $expected)){write-host @greencheck}
if($($(Invoke-WebRequest http://localhost:9002/echo.ps1 -method POST -body "Hello World" | select -ExpandProperty content) -match $expected)){write-host @greencheck}

if($(Invoke-RestMethod http://localhost:9002/getenv | convertto-json -outvariable test)){write-host @greencheck}