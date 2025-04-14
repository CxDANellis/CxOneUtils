import requests
import json
from datetime import datetime

cx1url = "https://ast.checkmarx.net"  # Provide your values here
iamurl = "https://iam.checkmarx.net"
client = ""
clientsecret = ""
tenant = ""
apikey = ""
policyId = ""
FunctionName = ""

# Get timestamp for Logs
def getTime():
    return datetime.now().strftime("[%m/%d/%Y %H:%M:%S.%f %Z]")

# Log message to Console
def log(message, warning=False):
    formatted_message = f"{getTime()} {message}"
    print(formatted_message)

def getToken():
    uri = f"{iamurl}/auth/realms/{tenant}/protocol/openid-connect/token"
    body = {
        "client_id": client,
        "client_secret": clientsecret,
        "grant_type": "client_credentials"
    }
    try:
        resp = requests.post(uri, json=body)
        resp.raise_for_status()
        token = resp.json().get('access_token')
        return token
    except requests.exceptions.RequestException as e:
        log(e, True)

def getProjects(token):
    bearer = f"Bearer {token}"
    uri = f"{cx1url}/api/projects/"
    headers = {
        "Accept": "application/json;version=1.0",
        "Authorization": bearer
    }
    body = {"limit": 10000}
    try:
        resp = requests.get(uri, headers=headers, json=body)
        resp.raise_for_status()
        return resp.json()
    except requests.exceptions.RequestException as e:
        log(e, True)

def getPolicies(token):
    bearer = f"Bearer {token}"
    uri = f"{cx1url}/api/policy_management_service_uri/policies/v2/?limit=99&page=1"
    headers = {
        "Accept": "application/json;version=1.0",
        "Authorization": bearer
    }
    body = {"limit": 10000}
    try:
        resp = requests.get(uri, headers=headers, json=body)
        resp.raise_for_status()
        return resp.json()
    except requests.exceptions.RequestException as e:
        log(e, True)

def getPolicyInfo(token, policyId):
    bearer = f"Bearer {token}"
    uri = f"{cx1url}/api/policy_management_service_uri/policies/{policyId}"
    headers = {
        "Accept": "application/json;version=1.0",
        "Authorization": bearer
    }
    body = {"limit": 10000}
    try:
        resp = requests.get(uri, headers=headers, json=body)
        resp.raise_for_status()
        return resp.json()
    except requests.exceptions.RequestException as e:
        log(e, True)

def updatePolicies(token, policyId):
    bearer = f"Bearer {token}"
    uri = f"{cx1url}/api/policy_management_service_uri/policies/{policyId}"
    headers = {
        "Accept": "application/json;version=1.0",
        "Authorization": bearer,
        "ContentType": "application/json"
    }
    body = json.load(open("response.json"))
    try:
        resp = requests.put(uri, headers=headers, json=body)
        resp.raise_for_status()
        return resp.json()
    except requests.exceptions.RequestException as e:
        log(e, True)

def req(uri, method, token, errorMessage, body=None, proxy=None):
    headers = {
        "Authorization": f"Bearer {token}",
        "Content-Type": "application/json;v=1.0",
        "Accept": "application/json; version=1.0"
    }
    try:
        if method in ["POST", "PUT", "PATCH"]:
            if body:
                body = json.dumps(body, indent=5)
            resp = requests.request(method, uri, headers=headers, json=body)
        else:
            resp = requests.request(method, uri, headers=headers)
        resp.raise_for_status()
        return resp.json()
    except requests.exceptions.RequestException as e:
        log(e, True)
        raise errorMessage

def plaintext(securestring):
    workingstring = securestring.decode("utf-8")
    return workingstring

# Get token
token = getToken()
log(token)

if FunctionName == "updatePolicies":
    getUpdatedPolicy = updatePolicies(token, policyId)
    print(getUpdatedPolicy)
elif FunctionName == "getPolicyInfo":
    getPolicyTest = getPolicyInfo(token, policyId)
    getPolResp = json.dumps(getPolicyTest)
    print(getPolResp)
elif FunctionName == "getProjects":
    projects = getProjects(token)
    eachProject = [{project['project'], project['id'], project['name']} for project in projects['projects']]
    print(eachProject)
else:
    policies = getPolicies(token)
    eachPolicy = [{policy['policy'], policy['id'], policy['name']} for policy in policies['policies']]
    print(eachPolicy)