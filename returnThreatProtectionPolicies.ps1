##########################
####
# Author: @jkopacko - 02/2023
# Version: 1.0
# Comments: this is an active project
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

##
Invoke-RestMethod -Method Get -Headers $header ($($apiRegion)+ "/endpoint/v1/policies?policyType=threat-protection&page=1&pageSize=50") 
