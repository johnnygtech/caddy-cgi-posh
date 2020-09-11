# Caddy-Cgi-Posh  
A work in progress experimental implementation of Caddy-Cgi to serve and execution PowerShell scripts.

### Caddy getting started  
https://caddyserver.com/docs/getting-started

### Caddy version in use in project  
download the CGI version of caddy from: https://caddyserver.com/download

### Approach  
1) now that were able to get POST and Query string parameters into powershell scripts were basically able to start building systems
2) Build out a dockerfile to test packaging the scripts/server functions into a deployable package.
3) Publish the baseline capability for use in other projects either via docker file and/or downloadable package + config
4) Implement ci/cd pipeline for testing and above publishing capabilities

### Wish list  
1) implement wildcard routing so that new scripts/endpoints can be added dynaimcally
2) GUI Support - PSHTML implementation?
3) Authentication support/plugin


### Getting started
Run the Launch.ps1 file which will use the Caddyfile and custom caddy-cgi.exe to start a server on localhost:9002