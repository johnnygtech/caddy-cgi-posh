# Caddy-Cgi-Posh  
A work in progress experimental implementation of Caddy-Cgi to serve and execution PowerShell scripts.

### Caddy getting started  
https://caddyserver.com/docs/getting-started

### Caddy version in use in project  
download the CGI version of caddy from: https://caddyserver.com/download

## Caution: Experimental
This project is very much Experimental/PoC/Testing and should NOT be used for any production or even internet facing systems at the moment.

### Approach  
1) now that were able to get POST and Query string parameters into powershell scripts were basically able to start building systems
2) Build out a dockerfile to test packaging the scripts/server functions into a deployable package.
3) Publish the baseline capability for use in other projects either via docker file and/or downloadable package + config
4) Implement ci/cd pipeline for testing and above publishing capabilities

### Wish list  
1) CGI bin permissions and Data folder quarantine (windows and linux / design stage)
2) GUI Support - PSHTML implementation? (WIP)
3) Authentication support/plugin (caddy? other?)
4) Relative cgi file paths in caddyfile (for windows)

## Getting started
Run the Launch.ps1 file which will use the Caddyfile and custom caddy-cgi.exe/bin to start a server on localhost:9054

### General Notes
The ps1 scripts must return the Content-Type: <> header in the return text, so its clear that some sort of "layer" will be necessary
to act as the script broker that ensures the proper headers and w/e are returned base on content type. Or each script itself must return its own data.

This might end up being a neat powershell module use case?

### Notes about OS implementation
I want this solution to work on all OS's with .net core access, but specifically required are Windows/Ubuntu/OSX since I use these on a daily basis.

In theory though the only requirements for any OS to run this solution are 
1) a caddy build with cgi add on for whatever os/arch you want
2) a powershell implementation for your os/arch

#### Windows Shebang
#!C:\WINDOWS\System32\WindowsPowerShell\v1.0\powershell.exe -File
Although it should be noted this doesn't work yet when defined in the scripts,
it DOES work when defined before the script in the Caddyfile as seen in Caddyfile-Backup-WindowShebang

#### Ubuntu Shebang
#!/usr/bin/env pwsh

#### OSX Shebang
todo: Probably same as Ubuntu?