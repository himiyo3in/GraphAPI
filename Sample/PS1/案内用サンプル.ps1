# 変更箇所 1, 2 をお客様環境に合わせて設定ください

###### 変更箇所 1 ######
$clientId = "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"        #アプリケーションID
$clientSecret = "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"      #クライアント シークレット
$tenantName = "XXXXXXXXXX.onmicrosoft.com"                  #テナント名
#######################

###### 変更箇所 2 ######
$postBody = @'
{
   "template@odata.bind":"https://graph.microsoft.com/v1.0/teamsTemplates('standard')",
   "displayName":"SampleTeam_1216",
   "description":"Sample Team’s Description",
   "members":[
      {
         "@odata.type":"#microsoft.graph.aadUserConversationMember",
         "roles":[
            "owner"
         ],
         "user@odata.bind":"https://graph.microsoft.com/v1.0/users('XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX')"
      }
   ]
}
'@
# ※ $postBody の user@odata.bind の “users” 以降の () 内の部分は、実際のユーザーID を指定ください
#######################


$tokenBody = @{
   Grant_Type    = "client_credentials"
   Scope         = "https://graph.microsoft.com/.default"
   Client_Id     = $clientId
   Client_Secret = $clientSecret
}

$URL = "https://graph.microsoft.com/v1.0/teams"


$tokenResponse = Invoke-RestMethod -Uri "https://login.microsoftonline.com/$TenantName/oauth2/v2.0/token" -Method POST -Body $tokenBody
$tokenResponse | fl | Out-File tokenresponse.txt

try {   
   $result = Invoke-RestMethod -Headers @{Authorization = "Bearer $($tokenResponse.access_token)"} -Uri $URL -Method POST -Body $postBody -ContentType 'application/json'
} catch {
   $_.Exception | Out-File exception.txt
   $_.Exception.Response | Out-File -Append exception.txt
}