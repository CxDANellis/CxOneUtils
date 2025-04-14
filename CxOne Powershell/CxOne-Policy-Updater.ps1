param(
    [Parameter(Mandatory = $False)]
    [String]
    $cx1url = "",

    [Parameter(Mandatory = $False)]
    [String]
    $iamurl = "",

    [Parameter(Mandatory = $False)]
    [String]
    $client = "",

    [Parameter(Mandatory = $False)]
    [String]
    $clientsecret = "",

    [Parameter(Mandatory = $False)]
    [String]
    $tenant = "",

    [Parameter(Mandatory = $False)]
    [String]
    $apikey = "",
    [Parameter(Mandatory = $False)]
    [String]
    $policyId,
    [Parameter(Mandatory = $False)]
    [String]$FunctionName
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

function getProjects($token) {
    $bearer = "Bearer " + (Plaintext($token))
    $uri = "$($cx1url)/api/projects/"
    $headers = @{
      Accept = "application/json;version=1.0"
      Authorization = $bearer
    }
    
    $body = @{}
    $body["limit"] = 10000
    try  {
        $resp = $null
        $resp = Invoke-RestMethod -uri $uri -method "Get" -header $headers -body $body 
        return $resp
    } catch {
        log $_ $true
        $value = $_.Exception.Response.StatusCode.value__
        $description = $_.Exception.Response.StatusDescription
        log "StatusCode: ${value}" 
        log "StatusDescription: ${description}" 
    }
}

function getPolicies($token) {
    $bearer = "Bearer " + (Plaintext($token))
    $uri = "$($cx1url)/api/policy_management_service_uri/policies/v2/?limit=99&page=1"
    $headers = @{
      Accept = "application/json;version=1.0"
      Authorization = $bearer
    }
    
    $body = @{}
    $body["limit"] = 10000
    try  {
        $resp = $null
        $resp = Invoke-RestMethod -uri $uri -method "Get" -header $headers -body $body 
        return $resp
    } catch {
        log $_ $true
        $value = $_.Exception.Response.StatusCode.value__
        $description = $_.Exception.Response.StatusDescription
        log "StatusCode: ${value}" 
        log "StatusDescription: ${description}" 
    }
}

function getPolicyInfo($token, $policyId) {
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
        $resp = Invoke-RestMethod -uri $uri -method "Get" -header $headers -body $body
        $jsonBody = $resp | ConvertTo-Json
        log $jsonBody
        $jsonBody | Out-File -FilePath "response.json"
        return $resp
    } catch {
        Write-Output $_ $true
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
      ContentType = "application/json"      
    }
    $body = Get-Content -Path "C:\Users\DavidNe\OneDrive - Checkmarx\Documents\CxOne Scripts\response - Copy.json"

    try  {
        $resp = $null
        $resp = Invoke-RestMethod -uri $uri -method "Put" -header $headers -body $body -ContentType 'application/json'
        return $resp
    } catch {
        log $_ $true
        $value = $_.Exception.Response.StatusCode.value__
        $description = $_.Exception.Response.StatusDescription
        Write-Host "StatusCode: ${value}" 
        Write-Host "StatusDescription: ${description}" 
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
log $token

if ($FunctionName -eq "updatePolicies") {
     $getUpdatedPolicy = & $FunctionName $token $policyId
     Write-Output $getUpdatedPolicy
} elseif ($FunctionName -eq "getPolicyInfo") {
     $getPolicyTest = & $FunctionName $token $policyId
     $getPolResp = $getPolicyTest | ConvertTo-json
     Write-Output $getPolResp;
} elseif ($FunctionName -eq "getProjects") {
    $projects = getProjects $token
    $eachProject = $projects | 
    Select-Object -ExpandProperty projects |
    Select-Object project, @{n='astProjectId';e={$_.id}},
        @{n='name';e={$_.name}};
    Write-Output $eachProject
} else {
    $policies = getPolicies $token
    $eachPolicy = $policies |
    Select-Object -ExpandProperty policies |
    Select-Object policy, @{n='id';e={$_.id}},
        @{n='name';e={$_.name}};
    Write-Output $eachPolicy;
}



