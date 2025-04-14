param(
    [Parameter(Mandatory = $False)]
    [String]
    $cx1url = "https://ast.checkmarx.net",

    [Parameter(Mandatory = $False)]
    [String]
    $iamurl = "https://iam.checkmarx.net",

    [Parameter(Mandatory = $False)]
    [String]
    $client = "cxone-postman",

    [Parameter(Mandatory = $False)]
    [String]
    $clientsecret = "MUeHxvW0bh5aaaf0G6kkKomM9a2S4GyF",

    [Parameter(Mandatory = $False)]
    [String]
    $tenant = "cx_ast_cec_na_test_nellis_david",

    [Parameter(Mandatory = $False)]
    [String]
    $apikey = "eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICJOSFRCaFR4NTA0c2hkeWllYTB4Q3ZQckRJM2p4Vy04ekJFMG1BYl9xcVQ4In0.eyJleHAiOjE3MTUzNzEyMjYsImlhdCI6MTcxNTM2OTQyNiwianRpIjoiZjlhZjE1MTktZWY2OC00NzY3LWFlZGItNjk4MTAxMWFhYzkwIiwiaXNzIjoiaHR0cHM6Ly9pYW0uY2hlY2ttYXJ4Lm5ldC9hdXRoL3JlYWxtcy9jeF9hc3RfY2VjX25hX3Rlc3RfbmVsbGlzX2RhdmlkIiwiYXVkIjpbInJlYWxtLW1hbmFnZW1lbnQiLCJhc3QtYXBwIiwiYWNjb3VudCJdLCJzdWIiOiJiYzZkMzAwZi0wMTIzLTQ0ODItODBhMC05ZjgzMGVjZDk1YTAiLCJ0eXAiOiJCZWFyZXIiLCJhenAiOiJjeG9uZS1wb3N0bWFuIiwiYWNyIjoiMSIsInJlc291cmNlX2FjY2VzcyI6eyJyZWFsbS1tYW5hZ2VtZW50Ijp7InJvbGVzIjpbInZpZXctaWRlbnRpdHktcHJvdmlkZXJzIiwidmlldy1yZWFsbSIsIm1hbmFnZS1pZGVudGl0eS1wcm92aWRlcnMiLCJpbXBlcnNvbmF0aW9uIiwicmVhbG0tYWRtaW4iLCJjcmVhdGUtY2xpZW50IiwibWFuYWdlLXVzZXJzIiwicXVlcnktcmVhbG1zIiwidW1hX3Byb3RlY3Rpb24iLCJtYW5hZ2Uta2V5cyIsInZpZXctYXV0aG9yaXphdGlvbiIsInF1ZXJ5LWNsaWVudHMiLCJxdWVyeS11c2VycyIsIm1hbmFnZS1ldmVudHMiLCJtYW5hZ2UtcmVhbG0iLCJ2aWV3LWV2ZW50cyIsInZpZXctdXNlcnMiLCJ2aWV3LWNsaWVudHMiLCJtYW5hZ2UtYXV0aG9yaXphdGlvbiIsIm1hbmFnZS1ncm91cHMiLCJtYW5hZ2UtY2xpZW50cyIsInF1ZXJ5LWdyb3VwcyJdfSwiYWNjb3VudCI6eyJyb2xlcyI6WyJtYW5hZ2UtYWNjb3VudCIsIm1hbmFnZS1hY2NvdW50LWxpbmtzIiwidmlldy1wcm9maWxlIl19fSwic2NvcGUiOiJlbWFpbCByb2xlcyBpYW0tYXBpIGFzdC1hcGkgcHJvZmlsZSBncm91cHMiLCJ0ZW5hbnRfaWQiOiJpYW0uY2hlY2ttYXJ4Lm5ldDo6NmExYzlkMTQtOTc4YS00NzE3LWIwNmMtZGNkMmVkZmZiMTdiIiwidGVuYW50X25hbWUiOiJjeF9hc3RfY2VjX25hX3Rlc3RfbmVsbGlzX2RhdmlkIiwiY2xpZW50SG9zdCI6IjQ0LjIxOS4xMy4xNjAiLCJlbWFpbF92ZXJpZmllZCI6ZmFsc2UsInJvbGVzIjpbIm1hbmFnZS11c2VycyIsIm9mZmxpbmVfYWNjZXNzIiwibWFuYWdlLWtleXMiLCJtYW5hZ2UtZ3JvdXBzIiwidW1hX2F1dGhvcml6YXRpb24iLCJpYW0tYWRtaW4iLCJ1c2VyIiwibWFuYWdlLWNsaWVudHMiLCJkZWZhdWx0LXJvbGVzLWN4X2FzdF9jZWNfbmFfdGVzdF9uZWxsaXNfZGF2aWQiXSwiZXVsYS1hY2NlcHRlZCI6dHJ1ZSwiZ3JvdXBzIjpbXSwiZ3JvdXBzTmFtZXMiOltdLCJjYi11cmwiOiJodHRwczovL2RhdmlkbmVsbGlzLmNvZGViYXNoaW5nLmNvbSIsInByZWZlcnJlZF91c2VybmFtZSI6InNlcnZpY2UtYWNjb3VudC1jeG9uZS1wb3N0bWFuIiwiY2xpZW50QWRkcmVzcyI6IjQ0LjIxOS4xMy4xNjAiLCJjbGllbnRfaWQiOiJjeG9uZS1wb3N0bWFuIiwiYXN0LWJhc2UtdXJsIjoiaHR0cHM6Ly9hc3QuY2hlY2ttYXJ4Lm5ldCIsInNmLWlkIjoiMDAxM3owMDAwMkx6Y3ZBQUFSIiwicm9sZXNfYXN0IjpbImNyZWF0ZS1wcm9qZWN0IiwiYW5hbHl0aWNzLXNjYW4tZGFzaGJvYXJkLXZpZXciLCJkZWxldGUtd2ViaG9vayIsImRlbGV0ZS1hcHBsaWNhdGlvbiIsInVwZGF0ZS1wcm9qZWN0LWlmLWluLWdyb3VwIiwiZGVsZXRlLXNjYW4taWYtaW4tZ3JvdXAiLCJkYXN0LWFkbWluIiwiZGFzdC1kZWxldGUtc2NhbiIsImNyZWF0ZS13ZWJob29rIiwiYW5hbHl0aWNzLWV4ZWN1dGl2ZS1vdmVydmlldy12aWV3Iiwidmlldy1wcm9qZWN0cy1pZi1pbi1ncm91cCIsInRlc3Qgc3VwcG9ydCIsInVwZGF0ZS1zY2FuIiwiZGV2IiwiZGVsZXRlLXByb2plY3QiLCJvcGVuLWZlYXR1cmUtcmVxdWVzdCIsInZpZXctcG9saWN5LW1hbmFnZW1lbnQiLCJkYXN0LXVwZGF0ZS1yZXN1bHQtc3RhdGUtbm90LWV4cGxvaXRhYmxlIiwiYXN0LXJpc2stbWFuYWdlciIsIm1hbmFnZS1yZXBvcnRzIiwidmlldy1xdWVyaWVzIiwibWFuYWdlLXdlYmhvb2siLCJ1cGRhdGUtc2NoZWR1bGUtc2NhbiIsImNyZWF0ZS1hcHBsaWNhdGlvbiIsIkRpcmVjdG9yIC0gU3IuIE1hbmFnZXIiLCJxdWVyaWVzLWVkaXRvciIsInVwZGF0ZS1xdWVyeSIsInVwZGF0ZS1yZXN1bHQtbm90LWV4cGxvaXRhYmxlIiwiZGFzdC11cGRhdGUtc2NhbiIsInZpZXctZW5naW5lcyIsInVwZGF0ZS1wcm9qZWN0IiwiY3JlYXRlLXF1ZXJ5IiwiZGVsZXRlLXNjYW4iLCJkYXN0LWNyZWF0ZS1lbnZpcm9ubWVudCIsInZpZXctcHJlc2V0IiwiVGVzdCBEZWZhdWx0IiwiYWJvcnQtZGF0YS1yZXRlbnRpb24iLCJhc3NpZ24tdG8tYXBwbGljYXRpb24iLCJ2aWV3LXdlYmhvb2tzIiwib3Blbi1zdXBwb3J0LXRpY2tldCIsInZpZXctYWNjZXNzIiwidmlldy1wb29scyIsInVwZGF0ZS1zY2FuLWlmLWluLWdyb3VwIiwic2FzdC1taWdyYXRpb24iLCJ1cGRhdGUtYXBwbGljYXRpb24iLCJkYXN0LXVwZGF0ZS1yZXN1bHQtc2V2ZXJpdHkiLCJ1cGRhdGUtcHJvamVjdC1wYXJhbXMiLCJjcmVhdGUtcHJlc2V0IiwiZGFzdC1leHRlcm5hbC1zY2FucyIsImNyZWF0ZS1wb2xpY3ktbWFuYWdlbWVudCIsInZpZXctZmVlZGJhY2thcHAiLCJ2aWV3LWNuYXMiLCJ2aWV3LXRlbmFudC1wYXJhbXMiLCJtYW5hZ2UtcHJvamVjdCIsInZpZXctc2NhbnMiLCJjcmVhdGUtc2NhbiIsInZpZXctcHJvamVjdHMiLCJ2aWV3LXNjaGVkdWxlLXNjYW5zIiwidmlldy1yaXNrLW1hbmFnZW1lbnQiLCJhc3Qtc2Nhbm5lciIsInN0YXJ0LWRhdGEtcmV0ZW50aW9uIiwiYWRkLXBhY2thZ2UiLCJkZWxldGUtcXVlcnkiLCJ1cGRhdGUtZmVlZGJhY2thcHAiLCJ2aWV3LXByb2plY3QtcGFyYW1zIiwiZGVsZXRlLXBvb2wiLCJjcmVhdGUtcG9vbCIsImNyZWF0ZS1zY2hlZHVsZS1zY2FuIiwidXBkYXRlLXRlbmFudC1wYXJhbXMiLCJkZWxldGUtcHJvamVjdC1pZi1pbi1ncm91cCIsImRhc3QtY2FuY2VsLXNjYW4iLCJ1cGRhdGUtcmVzdWx0LW5vdC1leHBsb2l0YWJsZS1pZi1pbi1ncm91cCIsImNyZWF0ZS1mZWVkYmFja2FwcCIsInVwZGF0ZS1wYWNrYWdlLXN0YXRlLW11dGUiLCJ1cGRhdGUtcG9vbCIsImFjY2Vzcy1pYW0iLCJ1cGRhdGUtcmVzdWx0LWlmLWluLWdyb3VwIiwidmlldy1yZXN1bHRzIiwiZGVsZXRlLWZlZWRiYWNrYXBwIiwidmlldy1kYXRhLXJldGVudGlvbiIsInVwZGF0ZS1yaXNrLW1hbmFnZW1lbnQiLCJ1cGRhdGUtcmVzdWx0IiwidXBkYXRlLXByZXNldCIsInVwZGF0ZS1wb2xpY3ktbWFuYWdlbWVudCIsImRhc3QtdXBkYXRlLXJlc3VsdHMiLCJkYXN0LWNyZWF0ZS1zY2FuIiwibWFuYWdlLWNuYXMiLCJkZWxldGUtcG9saWN5LW1hbmFnZW1lbnQiLCJ1cGRhdGUtYWNjZXNzIiwibWFuYWdlLXBvbGljeS1tYW5hZ2VtZW50IiwiYXN0LXZpZXdlciIsIm1hbmFnZS1mZWVkYmFja2FwcCIsImFuYWx5dGljcy12dWxuZXJhYmlsaXR5LWRhc2hib2FyZC12aWV3IiwibWFuYWdlLWRhdGEtcmV0ZW50aW9uIiwiZGFzdC11cGRhdGUtcmVzdWx0LXN0YXRlcyIsImRlbGV0ZS1wcmVzZXQiLCJ2aWV3LWFwcGxpY2F0aW9ucyIsInZpZXctbGljZW5zZSIsInVwZGF0ZS1wYWNrYWdlLXN0YXRlLXNub296ZSIsImNyZWF0ZS1zY2FuLWlmLWluLWdyb3VwIiwiZGFzdC11cGRhdGUtcmVzdWx0LXN0YXRlLXByb3Bvc2Utbm90LWV4cGxvaXRhYmxlIiwib3JkZXItc2VydmljZXMiLCJhbmFseXRpY3MtcmVwb3J0cy1hZG1pbiIsImRhc3QtdXBkYXRlLWVudmlyb25tZW50Iiwidmlldy1yZXN1bHRzLWlmLWluLWdyb3VwIiwiZGFzdC1kZWxldGUtZW52aXJvbm1lbnQiLCJ2aWV3LXNjYW5zLWlmLWluLWdyb3VwIiwidmlldy1wcm9qZWN0LXBhcmFtcy1pZi1pbi1ncm91cCIsImFzdC1hZG1pbiIsIm1hbmFnZS1hY2Nlc3MiLCJtYW5hZ2UtYXBwbGljYXRpb24iLCJ1cGRhdGUtd2ViaG9vayJdLCJ0ZW5hbnQtdHlwZSI6IkludGVybmFsIiwiYXN0LWxpY2Vuc2UiOnsiSUQiOjQ5MDksIlRlbmFudElEIjoiNmExYzlkMTQtOTc4YS00NzE3LWIwNmMtZGNkMmVkZmZiMTdiIiwiSXNBY3RpdmUiOnRydWUsIlBhY2thZ2VJRCI6NiwiTGljZW5zZURhdGEiOnsiYWN0aXZhdGlvbkRhdGUiOjE2NTQ4MTczNDYxMTAsImFsbG93ZWRFbmdpbmVzIjpbIlNBU1QiLCJTQ0EiLCJLSUNTIiwiQ29udGFpbmVycyIsIkZ1c2lvbiIsIkFQSSBTZWN1cml0eSIsIkRBU1QiLCJDb2RlYmFzaGluZyJdLCJhcGlTZWN1cml0eUVuYWJsZWQiOnRydWUsImNvZGVCYXNoaW5nRW5hYmxlZCI6dHJ1ZSwiY29kZUJhc2hpbmdVcmwiOiJodHRwczovL2RhdmlkbmVsbGlzLmNvZGViYXNoaW5nLmNvbSIsImNvZGVCYXNoaW5nVXNlcnNDb3VudCI6MTAsImN1c3RvbU1heENvbmN1cnJlbnRTY2Fuc0VuYWJsZWQiOnRydWUsImRhc3RFbmFibGVkIjp0cnVlLCJleHBpcmF0aW9uRGF0ZSI6MTcxNzg4OTM0MDAwMCwiZmVhdHVyZXMiOlsiU1NPIl0sImxhc3RDb21tZW50TGltaXQiOjkwLCJtYXhDb25jdXJyZW50U2NhbnMiOjEsIm1heFF1ZXVlZFNjYW5zIjoxMDAwLCJzY3NFbmFibGVkIjpmYWxzZSwic2VydmljZVR5cGUiOiJTdGFuZGFyZCIsInNlcnZpY2VzIjpbIjAgQXBwc2VjIEhlbHBkZXNrIEFzc2lzdGFuY2UiLCIwIE9wdGltaXphdGlvbiBTZXJ2aWNlIE9yZGVyIl0sInVubGltaXRlZFByb2plY3RzIjp0cnVlLCJ1c2Vyc0NvdW50Ijo1MH0sIlBhY2thZ2VOYW1lIjoiUHJvZmVzc2lvbmFsIn0sInNlcnZpY2VfdXNlcnNfZW5hYmxlZCI6dHJ1ZSwidGVuYW50IjoiY3hfYXN0X2NlY19uYV90ZXN0X25lbGxpc19kYXZpZCJ9.aFanPp4-MaBV66rHpP2nJfTs6wzsP2UorkbVxLrTt9VOaewRc8j6aLeGozzLZjm01UecZo5o2Y4Ap-OuQ9jpgODM2gdFNc3fkoh2P3mqNWapv0BwboVEAfvbOnLcgIobTLXoBa6pWHpIAXp1G51GywVA02QLSIxIRmqsgUoWTir-10J8MvLIFchJY-zw2gVq_jaPe5g8fNRkz7Yb1L64BflwOE79YqSiKX_jVAVB-9C4Jw7gAcLSvIUxd78DI-D5XZFXw4MiTphCNS_Yedbwmlz502hAtm-utaY4SNYuUNp7YKV75fP6VC9PxGQ8-CB4UA3QOTSTfThErnIaNQVGVg",
    [Parameter(Mandatory = $False)]
    [String]
    $policyId = ""
)

#example values for above:
# $cx1url = "https://ast.checkmarx.net"
# $iamurl = "https://iam.checkmarx.net
# $client = "cx1client_2024"
# $clientsecret = "XalT4MAyYpbHX38JKFi77a5FLWqqqeeh"
# $tenant = "tenant_name"
# $apikey = "eyJhbGciOiJIUzI1NilsInR5cCIgOiAiSldUIiwia2lkIiA6ICJkY2NiYTVlYS05NTY0LTQ1MGEtOGU0Yy02ZjU3MWJjNzExOTUifQ.eyJpYXQiOjE3MTQ3MzM0OTcxImp0aSI6IjJlMTJkNjkxLTE1OTYtNGQwNS04OWQzLWY3ODc3YjQyMGJhOCIsImlzcyI6Imh0dHBzOi8vaWFtLmNoZWNrbWFyeC5uZXQvYXV0aC9yZWFsbXMvY3hfcHNfcGsiLCJhdWQiOiJodHRwczovL2lhbS5jaGVja21hcngubmV0L2F1dGgvcmVhbG1zL2N4X3BzX3BrIiwic3ViIjoiOTMxZjMxMTctYjNhMi00MTlkLTkyYzicitYjZlMGMNTUxYjdlIiwidHlwIjoiT2ZmbGluZSIsImF6cCI6ImFzdC1hcHAiLCJzZXNaZty9uX3N0YXRlIjoiNzJmYzhmODMtOWY2Ni00MjUxLTkxMzEtN2E3ODAxYTg0NDkwIiwic2NvcGUiOiIgb2ZmbGlueVshY2Nlc3MiLCJsaWQiOiI3MmZjOGY4My05ZjY2LTQyNTEtOTEzMS03YTc4MDFhODQ0OTAifQ.QwNxUrDWcSKfiqjaZzkR0ROPNwWJHypOIzK7XEYhZc0"



# Get timestamp for Logs
function getTime() {
    return "[{0:MM/dd/yyyy} {0:HH:mm:ss.fff K}]" -f (Get-Date)
}

#log message to Console
function log($message, $warning = $false) {
    $formattedMessage = "$(getTime) ${message}"
}

function getToken() {
    $uri = "$($iamurl)/auth/realms/$($tenant)/protocol/openid-connect/token"
    $body = @{}
    $body["client_id"] = $client
    $body["client_secret"] = $clientsecret
    $body["grant_type"] = "client_credentials"
    try  {
        $resp = $null
        $resp = Invoke-RestMethod -uri $uri -method "POST" -body $body 
        #$token = ConvertTo-SecureString $resp.access_token -AsPlainText -Force
        $token = $resp.access_token
        return $token
    } catch {
        log $_ $true
        $value = $_.Exception.Response.StatusCode.value__
        $description = $_.Exception.Response.StatusDescription
        log "StatusCode: ${value}" 
        log "StatusDescription: ${description}" 
    }
}

function updatePolicies($token, $policyId) {
    $bearer = "Bearer " + (Plaintext($token))
    $uri = "$($cx1url)/api/policy_management_service_uri/policies/$($policyId)"
    $headers = @{
      Accept = "application/json;version=1.0"
      Authorization = $bearer
    }
    
    $body = @{}
    $body["limit"] = 10000
    try  {
        $resp = $null
        $resp = Invoke-RestMethod -uri $uri -method "Put" -header $headers -body $body
        log $body
        return $resp
    } catch {
        log $_ $true
        $value = $_.Exception.Response.StatusCode.value__
        $description = $_.Exception.Response.StatusDescription
        log "StatusCode: ${value}" 
        log "StatusDescription: ${description}" 
    }
}


# add $token to param
function req($uri, $method, $client, $errorMessage, $body, $proxy){
    $headers = @{
        Authorization = "Bearer $token"
        "Content-Type" = "application/json;v=1.0"
        "Accept" = "application/json; version=1.0"
    }
    try {
        if($method -eq "POST" -or $method -eq "PUT" -or $method -eq "PATCH" ){
            $body = ConvertTo-Json -InputObject $body -Depth 5
            if ( $proxy -eq "" ) {
                $resp = Invoke-RestMethod -uri $uri -method $method -headers $headers -body $body
            } else {
                $resp = Invoke-RestMethod -uri $uri -method $method -headers $headers -body $body -Proxy $proxy
            }
        } else {
            if ( $proxy -eq "" ) {
                $resp = Invoke-RestMethod -uri $uri -method $method -headers $headers
            } else {
                $resp = Invoke-RestMethod -uri $uri -method $method -headers $headers -Proxy $proxy
            }
        }
        return $resp
    } catch {
        if ( $client.ShowErrors ) {
            log -message $_  -warning $true
            $value = $_.Exception.Response.StatusCode.value__
            $description = $_.Exception.Response.StatusDescription
            log "HTTP ${value} - $uri - StatusDescription: ${description}" $true
            log "Request body was: $($body | ConvertTo-Json)"
        }
        throw $errorMessage
    }
}

function Plaintext( $securestring ) {
    $workingstring = ConvertTo-SecureString $securestring -AsPlainText -Force
    $BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($workingstring)
    $UnsecureString = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)
    [Runtime.InteropServices.Marshal]::ZeroFreeBSTR($BSTR)
    return $UnsecureString
}


###################

#get token
$token = getToken

Write-Output $getToken