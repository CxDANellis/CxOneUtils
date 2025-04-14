import csv
import getpass
import requests
from datetime import datetime

# Project Class
class Project:
    def __init__(self):
        self.ProjectName = ""
        self.ProjectId = ""
        self.TeamId = ""
        self.TeamName = ""
        self.PresetName = ""
        self.PresetId = ""
        self.EngineConfigurationId = ""
        self.PostScanActionName = ""
        self.PostScanActionId = ""
        self.EmailFailedScan = []
        self.EmailBeforeScan = []
        self.EmailAfterScan = []
        self.RunOnlyWhenNewResults = ""
        self.RunOnlyWhenNewResultsMinSeverity = ""
        self.PostScanActionArguments = ""

#Variables

baseURI = "ast.checkmarx.net"        

# Login and create header
def create_header():
    print("Starting Authentication")
    username = input("Enter your SAST username: ")
    password = getpass.getpass("Enter your SAST password: ")
    
    uri = f"{baseURI}/cxrestapi/auth/identity/connect/token"
    body = {
        "username": username,
        "password": password,
        "grant_type": "password",
        "scope": "access_control_api sast_rest_api",
        "client_id": "resource_owner_client",
        "client_secret": "014DF517-39D1-4453-B7B3-9930C563627C"
    }
    try:
        response = requests.post(uri, json=body)
        response.raise_for_status()
        access_token = response.json()["access_token"]
    except requests.exceptions.RequestException as e:
        print("Error authenticating. Please check the URI, Username, and Password and try again")
        exit()

    print("Authentication Completed")
    return {"accept": "application/json", "Authorization": f"Bearer {access_token}"}

# Get presets
def get_presets(header):
    print("Getting Presets")
    uri = f"{baseURI}/cxrestapi/help/sast/presets"
    try:
        response = requests.get(uri, headers=header)
        response.raise_for_status()
        presets = {preset["id"]: preset["name"] for preset in response.json()}
        new_preset_id = next((id for id, name in presets.items() if name == newPreset), None)
    except requests.exceptions.RequestException as e:
        print("Error retrieving presets. Please check the user selected has the appropriate rights for this command")
        exit()

    print(f"{len(presets)} Presets returned")
    return presets, new_preset_id

# Get Teams
def get_teams(header):
    print("Getting Teams")
    uri = f"{baseURI}/cxrestapi/auth/Teams"
    try:
        response = requests.get(uri, headers=header)
        response.raise_for_status()
        teams = {team["id"]: team["name"] for team in response.json()}
    except requests.exceptions.RequestException as e:
        print("Error retrieving teams. Please check the user selected has the appropriate rights for this command")
        exit()

    print(f"{len(teams)} Teams returned")
    return teams

# Get all projects and store Project ID, Project name, and Project Owner
def get_projects(header, teams):
    print("Getting Projects")
    projects_list = []
    uri = f"{baseURI}/cxrestapi/help/projects"
    try:
        response = requests.get(uri, headers=header)
        response.raise_for_status()
        projects = response.json()
    except requests.exceptions.RequestException as e:
        print("Error retrieving projects. Please check the user selected has the appropriate rights for this command")
        exit()

    for project in projects:
        if not teamNameFilter and not teamIdFilter or (teamNameFilter and teams[project["teamId"]] in teamNameFilter) or (teamIdFilter and project["teamId"] in teamIdFilter):
            p = Project()
            p.ProjectName = project["name"]
            p.ProjectId = project["id"]
            p.TeamId = project["teamId"]
            p.TeamName = teams[project["teamId"]]
            projects_list.append(p)

    print(f"{len(projects)} Projects returned")
    return projects_list

# Get Project scan settings
def get_project_scan_settings(header, projects, presets):
    print("Getting Scan Settings")
    v4 = False
    for p in projects:
        uri = f"{baseURI}/cxrestapi/help/sast/scanSettings/{p.ProjectId}"
        try:
            response = requests.get(uri, headers=header)
            response.raise_for_status()
            scan_settings = response.json()
        except requests.exceptions.RequestException as e:
            print("Error retrieving scan settings.")
            exit()

        p.PresetId = scan_settings["preset"]["id"]
        p.PresetName = presets[scan_settings["preset"]["id"]]
        p.EngineConfigurationId = scan_settings["engineConfiguration"]["id"]
        p.PostScanActionName = scan_settings["postScanActionName"]
        p.PostScanActionId = scan_settings["postScanAction"]["id"]
        p.EmailFailedScan = scan_settings["emailNotifications"]["failedScan"]
        p.EmailBeforeScan = scan_settings["emailNotifications"]["beforeScan"]
        p.EmailAfterScan = scan_settings["emailNotifications"]["afterScan"]

        if scan_settings["postScanActionConditions"]:
            v4 = True
            p.RunOnlyWhenNewResults = scan_settings["postScanActionConditions"]["runOnlyWhenNewResults"]
            p.RunOnlyWhenNewResultsMinSeverity = scan_settings["postScanActionConditions"]["runOnlyWhenNewResultsMinSeverity"]
            p.PostScanActionArguments = scan_settings["postScanActionArguments"]

    print("Scan Settings returned")
    return v4

# Update presets using new value
def update_project_preset(header, projects, presets, new_preset_id, v4):
    print("Updating projects")
    update_count = 0

    for p in projects:
        if p.PresetName == currentPreset.strip('\'"'):
            uri = f"{baseURI}/cxrestapi/help/sast/scanSettings"
            body = {
                "projectId": p.ProjectId,
                "presetId": new_preset_id,
                "engineConfigurationId": p.EngineConfigurationId,
                "postScanActionId": p.PostScanActionId,
                "emailNotifications": {
                    "failedScan": p.EmailFailedScan,
                    "beforeScan": p.EmailBeforeScan,
                    "afterScan": p.EmailAfterScan
                }
            }
            if v4:
                body["postScanActionConditions"] = {
                    "runOnlyWhenNewResults": p.RunOnlyWhenNewResults,
                    "runOnlyWhenNewResultsMinSeverity": p.RunOnlyWhenNewResultsMinSeverity
                }
                body["postScanActionArguments"] = p.PostScanActionArguments

            try:
                response = requests.put(uri, headers=header, json=body)
                response.raise_for_status()
                print(f"Project {p.ProjectName} projectName preset updated to {newPreset}")
                update_count += 1
            except requests.exceptions.RequestException as e:
                print("Error updating project.")
                exit()

    return update_count

# Main
if teamNameFilter and teamIdFilter:
    print("Use either Team Name or Team ID as filter.")
    exit()

if help:
    print(__doc__)
    exit()

print("\nProcessing Started")

header = create_header()
presets, newPresetId = get_presets(header)
teams = get_teams(header)
projects = get_projects(header, teams)
v4 = get_project_scan_settings(header, projects, presets)
if update:
    update_count = update_project_preset(header, projects, presets, newPresetId, v4)
    print(f"{update_count} projects updated")
else:
    with open(filePath, 'w', newline='') as csvfile:
        writer = csv.DictWriter(csvfile, fieldnames=Project().__dict__.keys())
        writer.writeheader()
        for p in projects:
            writer.writerow(p.__dict__)
    print(f"Report written to {filePath}")

print("Processing Completed")