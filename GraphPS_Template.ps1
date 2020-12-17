# $clientId, $clientSecret, $tenantName、および各実行メソッド (GET, POST) 内の $URL, $postBody を編集ください

############################### ここから テンプレ ###############################
# Input Parameters  
$clientId = "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"        #アプリケーションID
$clientSecret = "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"      #クライアント シークレット
$tenantName = "XXXXXXXXXX.onmicrosoft.com"                  #テナント名

$tokenBody = @{
    Grant_Type    = "client_credentials"
    Scope         = "https://graph.microsoft.com/.default"
    Client_Id     = $clientId
    Client_Secret = $clientSecret
}
$tokenResponse = Invoke-RestMethod -Uri "https://login.microsoftonline.com/$TenantName/oauth2/v2.0/token" -Method POST -Body $tokenBody
$tokenResponse
############################### ここまで テンプレ ###############################

############################### ここから GET メソッド ###############################
# Get Method
$URL = "https://graph.microsoft.com/v1.0/users"

$result = Invoke-RestMethod -Headers @{Authorization = "Bearer $($tokenResponse.access_token)"} -Uri $URL -Method Get
$result
############################### ここまで GET メソッド ###############################

############################### ここから POST メソッド ###############################
# POST Method
$URL = "https://graph.microsoft.com/v1.0/groups"

$postBody = @'
{
    "description": "Self help community for library",
    "displayName": "Library Assist",
    "groupTypes": [
      "Unified"
    ],
    "mailEnabled": true,
    "mailNickname": "library",
    "securityEnabled": false
}
'@

$result = Invoke-RestMethod -Headers @{Authorization = "Bearer $($tokenResponse.access_token)"} -Uri $URL -Method POST -Body $postBody -ContentType 'application/json'
$result
############################### ここまで POST メソッド ###############################