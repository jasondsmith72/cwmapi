# ConnectWise Manage Company Configurations API

This document covers the Configuration-related APIs within the Company module of ConnectWise Manage.

## Base URL
All Company endpoints are relative to:
```
https://{server}/v4_6_release/apis/3.0/company
```

## Configurations

Configurations represent assets, devices, or other items tracked in the system.

### Endpoints

#### Get Configurations
```
GET /configurations
GET /configurations/{id}
GET /configurations/count
GET /configurations/search
```

**Parameters:**
- `id` (optional): The ID of a specific configuration to retrieve
- `conditions` (optional): Filter the results based on specific conditions
- `orderBy` (optional): Order the results by a specific field
- `page` (optional): Page number for paginated results
- `pageSize` (optional): Number of items per page
- `fields` (optional): Comma-separated list of fields to include in the response
- `customFieldConditions` (optional): Filter custom fields based on specific conditions

**Example Request:**
```
GET /configurations?conditions=company/id=123 and type/id=1&orderBy=name asc
```

**Example Response:**
```json
[
  {
    "id": 1,
    "name": "Server01",
    "type": {
      "id": 1,
      "name": "Server",
      "_info": {...}
    },
    "status": {
      "id": 1,
      "name": "Active",
      "_info": {...}
    },
    "company": {
      "id": 123,
      "identifier": "ABC",
      "name": "ABC Company",
      "_info": {...}
    },
    "contact": {
      "id": 456,
      "name": "John Doe",
      "_info": {...}
    },
    "site": {
      "id": 1,
      "name": "Main Office",
      "_info": {...}
    },
    "locationId": 1,
    "businessUnitId": 1,
    "deviceIdentifier": "SRV-001",
    "serialNumber": "ABC123456",
    "modelNumber": "PowerEdge R740",
    "tagNumber": null,
    "purchaseDate": "2022-01-15T00:00:00Z",
    "installationDate": "2022-01-20T00:00:00Z",
    "warrantyExpirationDate": "2025-01-15T00:00:00Z",
    "notes": "Primary application server",
    "activeFlag": true,
    "ip": "192.168.1.10",
    "cntrlZip": "12345",
    "cntrlPhone": "800-555-1234",
    "vendorNotes": null,
    "managementLink": "https://admin.server01.example.com",
    "localUserName": "admin",
    "localPassword": null,
    "manufacturer": {
      "id": 1,
      "name": "Dell",
      "_info": {...}
    },
    "billFlag": true,
    "typeSubcategory": null,
    "showRemoteFlag": true,
    "snmpCommunity": "public",
    "parentConfigurationId": null,
    "customFields": [...],
    "_info": {
      "lastUpdated": "2023-01-15T08:30:00Z",
      "updatedBy": "admin"
    }
  }
]
```

#### Create Configuration
```
POST /configurations
```

**Example Request Body:**
```json
{
  "name": "Workstation01",
  "type": {
    "id": 2
  },
  "status": {
    "id": 1
  },
  "company": {
    "id": 123
  },
  "contact": {
    "id": 456
  },
  "site": {
    "id": 1
  },
  "deviceIdentifier": "WKS-001",
  "serialNumber": "XYZ987654",
  "manufacturer": {
    "id": 2
  },
  "modelNumber": "Latitude 5520",
  "purchaseDate": "2023-01-01T00:00:00Z",
  "installationDate": "2023-01-05T00:00:00Z",
  "warrantyExpirationDate": "2026-01-01T00:00:00Z",
  "ip": "192.168.1.100",
  "activeFlag": true
}
```

#### Update Configuration
```
PATCH /configurations/{id}
PUT /configurations/{id}
```

**Example Request Body (PATCH):**
```json
{
  "notes": "Primary workstation for accounting department",
  "ip": "192.168.1.101"
}
```

#### Delete Configuration
```
DELETE /configurations/{id}
```

### Configuration Types

#### Get Configuration Types
```
GET /configurations/types
GET /configurations/types/{id}
GET /configurations/types/count
```

**Example Response:**
```json
[
  {
    "id": 1,
    "name": "Server",
    "inactiveFlag": false,
    "defaultFlag": false,
    "reportFlag": true,
    "requiredFlag": false,
    "categoryFlag": null,
    "subcategory": null,
    "questions": [...],
    "_info": {
      "lastUpdated": "2023-01-15T00:00:00Z",
      "updatedBy": "admin"
    }
  }
]
```

### Configuration Statuses

#### Get Configuration Statuses
```
GET /configurations/statuses
GET /configurations/statuses/{id}
GET /configurations/statuses/count
```

**Example Response:**
```json
[
  {
    "id": 1,
    "name": "Active",
    "defaultFlag": true,
    "inactiveFlag": false,
    "_info": {
      "lastUpdated": "2023-01-15T00:00:00Z",
      "updatedBy": "admin"
    }
  }
]
```

### Configuration Type Questions

#### Get Configuration Type Questions
```
GET /configurations/types/{typeId}/questions
GET /configurations/types/{typeId}/questions/{id}
GET /configurations/types/{typeId}/questions/count
```

**Example Response:**
```json
[
  {
    "id": 1,
    "configurationTypeId": 1,
    "fieldType": "Text",
    "entryType": "EntryField",
    "sequenceNumber": 1,
    "question": "Operating System",
    "helpText": "Enter the operating system name and version",
    "requiredFlag": true,
    "inactiveFlag": false,
    "values": [...],
    "_info": {
      "lastUpdated": "2023-01-15T00:00:00Z",
      "updatedBy": "admin"
    }
  }
]
```

### Configuration Type Question Values

#### Get Configuration Type Question Values
```
GET /configurations/{configId}/typeQuestions/{questionId}/values
GET /configurations/{configId}/typeQuestions/{questionId}/values/{id}
```

**Example Response:**
```json
[
  {
    "id": 1,
    "configurationId": 1,
    "questionId": 1,
    "value": "Windows Server 2022",
    "_info": {
      "lastUpdated": "2023-01-15T08:30:00Z",
      "updatedBy": "admin"
    }
  }
]
```

#### Create Configuration Type Question Value
```
POST /configurations/{configId}/typeQuestions/{questionId}/values
```

**Example Request Body:**
```json
{
  "value": "Windows Server 2022"
}
```

#### Update Configuration Type Question Value
```
PATCH /configurations/{configId}/typeQuestions/{questionId}/values/{id}
PUT /configurations/{configId}/typeQuestions/{questionId}/values/{id}
```

**Example Request Body (PATCH):**
```json
{
  "value": "Windows Server 2022 Standard"
}
```

### Configuration Additions

#### Get Configuration Additions
```
GET /configurations/{configId}/additions
GET /configurations/{configId}/additions/{id}
GET /configurations/{configId}/additions/count
```

## Code Examples

### PowerShell Example: Finding active servers for a company

```powershell
# Authenticate first (see authentication.md)

# Find all active servers for a specific company
$companyId = 123
$serverTypeId = 1  # Assuming 1 is the server type ID
$conditions = [System.Web.HttpUtility]::UrlEncode("company/id=$companyId and type/id=$serverTypeId and activeFlag=true")
$uri = "https://$Server/v4_6_release/apis/3.0/company/configurations?conditions=$conditions"

$servers = Invoke-RestMethod -Uri $uri -Headers $Headers -Method Get

foreach ($server in $servers) {
    Write-Output "Server Name: $($server.name)"
    Write-Output "IP Address: $($server.ip)"
    Write-Output "Serial Number: $($server.serialNumber)"
    Write-Output "Warranty Expiration: $($server.warrantyExpirationDate)"
    Write-Output "---"
}
```

### Python Example: Creating a new configuration

```python
import requests
import json
import base64
from datetime import datetime, timedelta

# Authentication setup (see authentication.md)

# Create a configuration
config_data = {
    "name": "Firewall01",
    "type": {
        "id": 3  # Assuming 3 is the firewall type ID
    },
    "status": {
        "id": 1  # Active
    },
    "company": {
        "id": 123
    },
    "site": {
        "id": 1
    },
    "deviceIdentifier": "FW-001",
    "serialNumber": "FW123456",
    "manufacturer": {
        "id": 3  # Assuming 3 is the manufacturer ID for the firewall
    },
    "modelNumber": "FortiGate 60F",
    "purchaseDate": datetime.now().strftime("%Y-%m-%dT00:00:00Z"),
    "warrantyExpirationDate": (datetime.now() + timedelta(days=365*3)).strftime("%Y-%m-%dT00:00:00Z"),
    "ip": "192.168.1.1",
    "activeFlag": True,
    "notes": "Main edge firewall"
}

url = f"https://{server}/v4_6_release/apis/3.0/company/configurations"
response = requests.post(url, headers=headers, json=config_data)

if response.status_code == 201:
    new_config = response.json()
    print(f"Successfully created configuration: {new_config['name']}")
    
    # Add configuration type question values
    if new_config.get('id'):
        question_id = 10  # Example: Question about firmware version
        question_value = {
            "value": "FortiOS 7.0.5"
        }
        
        value_url = f"https://{server}/v4_6_release/apis/3.0/company/configurations/{new_config['id']}/typeQuestions/{question_id}/values"
        value_response = requests.post(value_url, headers=headers, json=question_value)
        
        if value_response.status_code == 201:
            print("Successfully added configuration type question value")
        else:
            print(f"Error adding question value: {value_response.status_code}")
            print(value_response.text)
else:
    print(f"Error: {response.status_code}")
    print(response.text)
```
