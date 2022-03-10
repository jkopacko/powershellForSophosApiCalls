 #enter your Client ID from Central
$clientid = "<###>"

#enter your Client Secret from Central
$clientsecret = "<###>"

 #uri to authenticate with Central
$authuri = "https://id.sophos.com/api/v2/oauth2/token"

#uri to get tenant ID
$whoami_uri = "https://api.central.sophos.com/whoami/v1"

#this is the full body of the authentication request
$authbod = @{
 "grant_type" = 'client_credentials'
 "scope" = 'token'
 "client_id" = $clientid
 "client_secret" = $clientsecret
} 

#this will send your bearer token request
$auth = Invoke-RestMethod -uri $authuri -Method Post -Body $authbod -ContentType application/x-www-form-urlencoded

#this will extract your bearer token for later use
$bearer = $auth.access_token

#this stores the token in a readable variable 
$headers = @{Authorization="Bearer $bearer"}

#this will send your whoami request for tenant identification
$whoami = Invoke-RestMethod -uri $whoami_uri -Method Get -Headers $headers 

#this formats your tenant ID for later use
$tenantID = $whoami.id

#uri to list out machines 
$deviceList = $whoami.apiHosts.dataRegion + "/endpoint/v1/endpoints"

#this sends a request to return all endpoints 
$getDeviceList = Invoke-RestMethod -uri $deviceList -Headers $header

#this converts your device list into a readable list
$convertGetDeviceList = $getDeviceList.items | Select-Object -Property id

#uri to trigger scan
$scanURL = $whoami.apiHosts.dataRegion + "/endpoint/v1/endpoints/" + $endpointID + "/scans"

#trigger the scan
ForEach ($endpointID in $convertGetDeviceList)
{
$jsonauthbod = $authbod | ConvertTo-Json
$param = @{
    Method = "Post"
    ContentType = "application/json"
    Uri = $scanURL
    Body = {}
    Headers = $headers
    }
Invoke-RestMethod @param
}  
