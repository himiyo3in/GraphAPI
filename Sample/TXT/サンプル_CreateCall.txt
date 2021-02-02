# 変更箇所 1, 2 をお客様環境に合わせて設定ください

###### 変更箇所 1 ######
# ※ お客様環境で作成されておりますアプリケーションに合わせて、clientId, clientSecret, tenantName の部分を置き換えてご利用ください

$clientId = "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"        #アプリケーションID
$clientSecret = "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"      #クライアント シークレット
$tenantName = "XXXXXXXXXX.onmicrosoft.com"                  #テナント名
#######################

###### 変更箇所 2 ######
# ※ $postBody 内の callbackUri, displayName, id, tenantId 部分をお客様環境のテナント情報、対象ユーザー情報に置き換えてご利用ください

$postBody = @'
{
   "@odata.type": "#microsoft.graph.call",
   "callbackUri": "＜＜＜＜＜ Callback URL ＞＞＞＞＞",
   "targets": [
     {
       "@odata.type": "#microsoft.graph.invitationParticipantInfo",
       "identity": {
         "@odata.type": "#microsoft.graph.identitySet",
         "user": {
           "@odata.type": "#microsoft.graph.identity",
           "displayName": "＜＜＜＜＜ ユーザーの表示名 ＞＞＞＞＞",
           "id": "＜＜＜＜＜ ユーザーの ObjectId ＞＞＞＞＞"
         }
       }
     }
   ],
   "requestedModalities": [
     "audio"
   ],
   "mediaConfig": {
     "@odata.type": "#microsoft.graph.serviceHostedMediaConfig"
   },
   "tenantId": "＜＜＜＜＜ テナント Id ＞＞＞＞＞"
}
'@
#######################


########## ここから変更不要 ##########
$filename = "outfile-1225Script.txt"

$tokenBody = @{
    Grant_Type    = "client_credentials"
    Scope         = "https://graph.microsoft.com/.default"
    Client_Id     = $clientId
    Client_Secret = $clientSecret
}

$URL = "https://graph.microsoft.com/v1.0/communications/calls"

# PostBody 出力
"<<< PostBody >>>" | Out-File $filename
$postBody | Out-File -Append $filename

# Access Token 取得
$getToken = Invoke-WebRequest -Uri "https://login.microsoftonline.com/$TenantName/oauth2/v2.0/token" -Method POST -Body $tokenBody
$tokenResponse = ConvertFrom-Json $getToken

"<<< tokenResponse >>>" | Out-File -Append $filename
$tokenResponse | Out-File -Append $filename
"<<< tokenResponse.access_token >>>" | Out-File -Append $filename
$tokenResponse.access_token | Out-File -Append $filename

# 
" " | Out-File -Append $filename

# API 実行
try {
   $result = Invoke-WebRequest -Headers @{Authorization = "Bearer $($tokenResponse.access_token)"} -Uri $URL -Method POST -Body $postBody -ContentType 'application/json'

   "<<< result.RawContent >>>" | Out-File -Append $filename
   $result.RawContent | Out-File -Append $filename

} catch {
   "<<< Exception >>>" | Out-File -Append $filename
   $_.Exception | Out-File -Append $filename
   $_.Exception.Response | Out-File -Append $filename
}
########## ここまで変更不要 ##########