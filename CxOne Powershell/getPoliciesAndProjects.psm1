param(
    [Parameter(Mandatory = $False)]
    [String]
    $cx1url = "https://ast.checkmarx.net",

    [Parameter(Mandatory = $False)]
    [String]
    $iamurl = "https://iam.checkmarx.net",

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

function getPolicyInfo($token) {
    $bearer = "Bearer " + (Plaintext($token))
    $uri = "$($cx1url)/api/policy_management_service_uri/policies/5380"
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
#Write-Host "token is"
#Write-Host $token

#get projects
$projects = getProjects $token
$eachProject = $projects | 
    Select-Object -ExpandProperty projects |
    Select-Object project, @{n='id';e={$_.id}},
        @{n='name';e={$_.name}}
#Write-Host $projs
#$projs


$policies = getPolicies $token
#$pols = $policies | Select-Object -property policies
#$policies.PSObject.Properties | ForEach-Object {    $_}
#$eachPolicy = $pols
#Write-Output $eachPolicy
#foreach ($pol in $policies) {
#    $pol
#}
$eachPolicy = $policies |
    Select-Object -ExpandProperty policies |
    Select-Object policy, @{n='id';e={$_.id}},
        @{n='name';e={$_.name}}

$getPolicyTest = getPolicyInfo $token
$getPolResp = $getPolicyTest | ConvertTo-json



 
#Write-Output $eachPolicy
#Write-Output "`n"
#Write-Output $eachProject
#Write-Output $getPolResp
Write-Output $getPolResp;
Write-Output $eachProject;
Write-Output $eachPolicy;

#got this far, then customer revealed they did not want to continue on this path
#$projs | ForEach-Object
#$projects.PSObject.Properties | ForEach-Object {    $_}


