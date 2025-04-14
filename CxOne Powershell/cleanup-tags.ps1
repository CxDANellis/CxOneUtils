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
        $token = ConvertTo-SecureString $resp.access_token -AsPlainText -Force
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

function getProjectTags($token) {
    $bearer = "Bearer " + (Plaintext($token))
    $uri = "$($cx1url)/api/projects/tags"
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

function updateProject($token, $id, $data) {
    $jsonPayload = $data | ConvertTo-Json
    Write-Output $jsonPayload
    $bearer = "Bearer " + (Plaintext($token))
    $uri = "$($cx1url)/api/projects/$($id)"
    $headers = @{
      Accept = "application/json;version=1.0"
      Authorization = $bearer
      ContentType = "application/json"      
    }
    try  {
        $resp = $null
        $resp = Invoke-RestMethod -uri $uri -method "Put" -header $headers -body $jsonPayload -ContentType 'application/json'
        return $resp
    } catch {
        log $_ $true
        $value = $_.Exception.Response.StatusCode.value__
        $description = $_.Exception.Response.StatusDescription
        Write-Host "StatusCode: ${value}" 
        Write-Host "StatusDescription: ${description}" 
    }
}

function checkForCommas() {
    $projects = getProjects $token
    foreach($project in $projects | Select-Object -ExpandProperty projects) {
        $project | ForEach-Object {
            Write-Host $project
            $tagsArray = $_.Tags -split ",\s*"
            $modifiedTags = $tagsArray | ForEach-Object {
                if ($_ -match ",") {
                    $_ -replace ",", "" 
                } else {
                    $_
                }
            }
            $_.Tags = $modifiedTags -join " "
            $_.Tags = $_.Tags | ConvertTo-Json -Depth 3
            Write-Host "Rewritten Tags: $($_.Tags)"
            $runIt = updateProject $token $($_.id) $($_)
            Write-Host $runIt           
        }
    }
    Write-Output $projectTags, $listTags
}





###################
#get token
$token = getToken
log $token

$checkingCommas = checkForCommas $token
$checkingCommas | Out-Host
$outputs = getProjects $token | Select-Object -ExpandProperty projects
# $outputs = getProjects $token
$outputs | Out-Host