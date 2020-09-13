$greenCheck = @{
    Object = [Char]8730
    ForegroundColor = 'Green'
    NoNewLine = $true
    }

$expected="Hello world"

if($($(Invoke-WebRequest http://localhost:9002/examples/test | select -ExpandProperty content) -match $expected)){write-host @greencheck}
if($($(Invoke-WebRequest http://localhost:9002/examples/test.ps1 | select -ExpandProperty content) -match $expected)){write-host @greencheck}

if($($(Invoke-WebRequest "http://localhost:9002/examples/echo?test=hello world" | select -ExpandProperty content) -match $expected)){write-host @greencheck}
if($($(Invoke-WebRequest http://localhost:9002/examples/echo.ps1 -method POST -body "Hello World" | select -ExpandProperty content) -match $expected)){write-host @greencheck}

if($(Invoke-RestMethod http://localhost:9002/examples/getenv | convertto-json -outvariable test)){write-host @greencheck}