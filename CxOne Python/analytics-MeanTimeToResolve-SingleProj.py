import datetime
import requests
import json
import csv


# Configuration
BASE_URL = "https://ast.checkmarx.net" # Make sure to update this for the correct realm
CLIENT_ID = ""  # Leave empty if using API key
CLIENT_SECRET = ""  # Leave empty if using API key
API_KEY = ""  # Leave empty if using OAuth
REALM = ""  # Example: "YourCompany"
TOKEN_URL = f"{BASE_URL}/auth/realms/{REALM}/protocol/openid-connect/token"
PROJECT_ID = "" # Project ID you want metrics for
KPI_ENDPOINT = f"{BASE_URL}/api/data_analytics/analyticsAPI/v1"
PROJECT_DATA = f"{BASE_URL}/api/projects/?offset=0&limit=20&ids={PROJECT_ID}"
TODAYS_DATE = f"{datetime.date.today():%Y-%m-%dT%H:%M:%S}"

# Function to get access token (OAuth)
def get_access_token():
    data = {
        "client_id": CLIENT_ID,
        "client_secret": CLIENT_SECRET,
        "grant_type": "client_credentials"
    }
    headers = {"Content-Type": "application/x-www-form-urlencoded"}
    response = requests.post(TOKEN_URL, data=data, headers=headers)
    response.raise_for_status()
    return response.json()["access_token"]

def fetch_project_data():
    headers = {
        "Content-Type": "application/json; version=1.0",
        "Authorization": f"Bearer {get_access_token()}" if CLIENT_ID else f"APIKey {API_KEY}"
    }

    response = requests.get(PROJECT_DATA, headers=headers)

    if response.status_code != 200:
        print("\nResponse Status Code:", response.status_code)
        print("\nResponse Text:", response.text)  # Print error details
        response.raise_for_status()
    print(response.json())
    return response.json()

# Function to fetch KPI data
def fetch_kpi_data(project_data):
    headers = {
        "Content-Type": "application/json; version=1.0",
        "Authorization": f"Bearer {get_access_token()}" if CLIENT_ID else f"APIKey {API_KEY}"
    }
    createdAtDate = project_data["projects"][0]["createdAt"].split(".")
    print()
    payload = {
        # "application": ["Add any application ID"],
        "projects": [f"{PROJECT_ID}"],   # Check if this is valid
        "scanners": ["sast"],   # Check if this is valid
        "severities": ["high", "medium", "low"],
        "startDate": f"{createdAtDate[0]}",
        # "startDate": "2025-01-01T00:00:00",
        "endDate": f"{TODAYS_DATE}",
        "kpi": "meanTimeToResolution"
    }

    print("\nRequest Payload:", json.dumps(payload, indent=2))
    # print("\nRequest Headers:", headers)

    response = requests.post(KPI_ENDPOINT, headers=headers, json=payload)

    if response.status_code != 200:
        print("\nResponse Status Code:", response.status_code)
        print("\nResponse Text:", response.text)  # Print error details
        response.raise_for_status()

    return response.json()


# Function to save data as CSV
def save_kpi_to_csv(data, filename="Checkmarx_KPI_Report.csv"):
    with open(filename, mode="w", newline="") as file:
        writer = csv.writer(file)
        writer.writerow(["Severity", "Mean Time to Resolution (hours)"])  # Header
        for item in data.get("meanTimeData", []):
            writer.writerow([item["label"], item["meanTime"]])
    
    print(f"\nCSV Report Saved: {filename}")

# Function to display data in formatted text
def display_kpi_data(data):
    print("\nCheckmarx KPI Data\n" + "=" * 40)
    print(f"{'Severity'.ljust(15)}{'Mean Time to Resolution (hours)'}")
    print("-" * 40)
    for item in data.get("meanTimeData", []):
        print(f"{item['label'].ljust(15)}{str(item['meanTime'])}")
    print("=" * 40)

# Main Execution
if __name__ == "__main__":
    try:
        project_data = fetch_project_data()
        kpi_data = fetch_kpi_data(project_data)
        save_kpi_to_csv(kpi_data)
        display_kpi_data(kpi_data)
    except Exception as e:
        print(f"Error: {e}")
