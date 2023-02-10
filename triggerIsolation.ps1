##########################
####
# Author: @jkopacko - 2023
# Version: 1.01
# Comments: this logic stores a list of IDs of endpoints with bad or suspicious health, v1 only isolates a single ID that is manually enter in line 42. In v1.1, I will add in the for-each logic to trigger on the list(s) of endpoints. In v1.2, I will salt/secure the storage.
####
#########################

## Your credentials (MUST SALT LATER)
$clientID = "<ID>"
$clientSecret = "<SECRET>"

## This will authenticate to Sophos API 
$tokenReply = Invoke-RestMethod -Method Post -ContentType "application/x-www-form-urlencoded" -Body "grant_type=client_credentials&client_id=$clientID&client_secret=$clientSecret&scope=token" -uri https://id.sophos.com/api/v2/oauth2/token
$bearerToken = $tokenReply.access_token
$header = @{Authorization="Bearer $($tokenReply.access_token)"}

## This will return your tenant ID
$whoami_resp = Invoke-RestMethod -Method Get -Headers $header https://api.central.sophos.com/whoami/v1
$tenantID = $whoami_resp.id
## This will extract your Central API region
$apiRegion = $whoami_resp.apiHosts.dataRegion

## Get all endpoints within the tenant with bad status
$endpointBad = Invoke-RestMethod -Method Get -Headers $header ($($apiRegion)+"/endpoint/v1/endpoints?healthStatus=bad")

## Extract bad endpoint IDs into a list
$endpointBadList = $endpointBad.items | Select-Object -Property id

## Get all endpoints within the tenant with suspicious status
$endpointSusp = Invoke-RestMethod -Method Get -Headers $header ($($apiRegion)+"/endpoint/v1/endpoints?healthStatus=suspicious")

## Extract suspicious endpoint IDs into a list
$endpointSuspList = $endpointSusp.items | Select-Object -Property id

## Trigger isolation
$isoTriggerBody = @{
    "enabled" = 'true'
    "comment" = 'auto iso test'
} | ConvertTo-Json

$isoTriggerUri = ($($apiRegion)+"/endpoint/v1/endpoints/")
$isoTriggerBad = Invoke-RestMethod -Method Patch -Headers $header -Body $isoTriggerBody -ContentType "application/json" -uri ($($isoTriggerUri) + "<singleID>" + "/isolation")

