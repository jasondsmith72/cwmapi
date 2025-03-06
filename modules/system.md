# ConnectWise Manage System API

This document covers the System module APIs in ConnectWise Manage, which includes members, info, and other system-wide settings.

## Base URL
All System endpoints are relative to:
```
https://{server}/v4_6_release/apis/3.0/system
```

## System Info

The System Info API provides information about the ConnectWise Manage instance.

### Endpoints

#### Get System Info
```
GET /info
```

**Example Response:**
```json
{
  "version": "v2023.1.12345",
  "isCloud": true,
  "serverTimeZone": "Eastern Standard Time",
  "cloudRegion": "NA"
}
```

## Members

Members represent users in the ConnectWise Manage system.

### Endpoints

#### Get Members
```
GET /members
GET /members/{id}
GET /members/count
GET /members/search
```

**Parameters:**
- `id` (optional): The ID of a specific member to retrieve
- `conditions` (optional): Filter the results based on specific conditions
- `orderBy` (optional): Order the results by a specific field
- `page` (optional): Page number for paginated results
- `pageSize` (optional): Number of items per page
- `fields` (optional): Comma-separated list of fields to include in the response

**Example Request:**
```
GET /members?conditions=inactiveFlag=false and type/id=1&orderBy=lastName asc
```

**Example Response:**
```json
[
  {
    "id": 1,
    "identifier": "admin",
    "firstName": "System",
    "lastName": "Administrator",
    "emailAddress": "admin@example.com",
    "title": "System Administrator",
    "inactiveFlag": false,
    "defaultEmail": {
      "id": 1,
      "domain": {
        "id": 1,
        "name": "example.com",
        "_info": {...}
      },
      "type": {
        "id": 1,
        "name": "Work",
        "_info": {...}
      },
      "address": "admin@example.com",
      "_info": {...}
    },
    "defaultPhone": {
      "id": 1,
      "type": {
        "id": 1,
        "name": "Office",
        "_info": {...}
      },
      "extension": "",
      "number": "800-555-1234",
      "_info": {...}
    },
    "officeEmail": {
      "id": 1,
      "domain": {
        "id": 1,
        "name": "example.com",
        "_info": {...}
      },
      "type": {
        "id": 1,
        "name": "Work",
        "_info": {...}
      },
      "address": "admin@example.com",
      "_info": {...}
    },
    "officePhone": {
      "id": 1,
      "type": {
        "id": 1,
        "name": "Office",
        "_info": {...}
      },
      "extension": "",
      "number": "800-555-1234",
      "_info": {...}
    },
    "timeZone": {
      "id": 1,
      "name": "US Eastern",
      "_info": {...}
    },
    "country": {
      "id": 1,
      "name": "United States",
      "_info": {...}
    },
    "department": {
      "id": 1,
      "name": "Administration",
      "_info": {...}
    },
    "location": {
      "id": 1,
      "name": "Main Office",
      "_info": {...}
    },
    "reportsTo": null,
    "systemUserFlag": true,
    "licenseClass": "A",
    "disablePortalLoginFlag": false,
    "lastLogin": "2023-01-15T08:30:00Z",
    "photo": {
      "id": 1,
      "fileName": "admin.jpg",
      "serverFileName": "admin_12345.jpg",
      "size": 15243,
      "contentType": "image/jpeg"
    },
    "enableMobileFlag": true,
    "type": {
      "id": 1,
      "name": "Admin",
      "_info": {...}
    },
    "securityRole": {
      "id": 1,
      "name": "System Administrator",
      "_info": {...}
    },
    "securityLocation": null,
    "securityDepartment": null,
    "structureLevel": null,
    "calendarId": 1,
    "agreementCount": 0,
    "notes": "",
    "mfaEnabled": true,
    "ssoClient": "",
    "ssoClientIdentifier": null,
    "_info": {
      "lastUpdated": "2023-01-15T08:30:00Z",
      "updatedBy": "admin"
    }
  }
]
```

#### Create Member
```
POST /members
```

**Example Request Body:**
```json
{
  "identifier": "jsmith",
  "firstName": "John",
  "lastName": "Smith",
  "emailAddress": "jsmith@example.com",
  "title": "Help Desk Technician",
  "inactiveFlag": false,
  "defaultEmail": {
    "domain": {
      "id": 1
    },
    "type": {
      "id": 1
    },
    "address": "jsmith@example.com"
  },
  "defaultPhone": {
    "type": {
      "id": 1
    },
    "number": "800-555-5678"
  },
  "timeZone": {
    "id": 1
  },
  "country": {
    "id": 1
  },
  "department": {
    "id": 2
  },
  "location": {
    "id": 1
  },
  "type": {
    "id": 2
  },
  "securityRole": {
    "id": 5
  }
}
```

#### Update Member
```
PATCH /members/{id}
PUT /members/{id}
```

**Example Request Body (PATCH):**
```json
{
  "title": "Senior Help Desk Technician",
  "department": {
    "id": 3
  }
}
```

#### Delete Member
```
DELETE /members/{id}
```

### Member API Tokens

#### Get Member API Tokens
```
GET /members/{memberId}/tokens
```

#### Create Member API Token
```
POST /members/{memberId}/tokens
```

#### Delete Member API Token
```
DELETE /members/{memberId}/tokens/{tokenId}
```

### Member Types

#### Get Member Types
```
GET /members/types
GET /members/types/{id}
GET /members/types/count
```

### Member Security Roles

#### Get Security Roles
```
GET /securityRoles
GET /securityRoles/{id}
GET /securityRoles/count
```

## My Account

The My Account API provides information about the authenticated user.

### Endpoints

#### Get My Account
```
GET /myAccount
```

**Example Response:**
```json
{
  "id": 1,
  "identifier": "admin",
  "firstName": "System",
  "lastName": "Administrator",
  "emailAddress": "admin@example.com",
  "timeZone": {
    "id": 1,
    "name": "US Eastern",
    "_info": {...}
  },
  "defaultDepartment": {
    "id": 1,
    "name": "Administration",
    "_info": {...}
  },
  "defaultLocation": {
    "id": 1,
    "name": "Main Office",
    "_info": {...}
  },
  "defaultEmail": {
    "id": 1,
    "domain": {
      "id": 1,
      "name": "example.com",
      "_info": {...}
    },
    "type": {
      "id": 1,
      "name": "Work",
      "_info": {...}
    },
    "address": "admin@example.com",
    "_info": {...}
  },
  "_info": {
    "lastUpdated": "2023-01-15T08:30:00Z",
    "updatedBy": "admin"
  }
}
```

## My Security

The My Security API provides information about the permissions of the authenticated user.

### Endpoints

#### Get My Security
```
GET /mySecurity
```

## Departments

Departments represent organizational units in the ConnectWise Manage system.

### Endpoints

#### Get Departments
```
GET /departments
GET /departments/{id}
GET /departments/count
```

**Example Response:**
```json
[
  {
    "id": 1,
    "name": "Administration",
    "locationId": 1,
    "businessUnitId": 1,
    "inactiveFlag": false,
    "_info": {
      "lastUpdated": "2023-01-15T00:00:00Z",
      "updatedBy": "admin"
    }
  }
]
```

## Locations

Locations represent physical locations in the ConnectWise Manage system.

### Endpoints

#### Get Locations
```
GET /locations
GET /locations/{id}
GET /locations/count
```

**Example Response:**
```json
[
  {
    "id": 1,
    "name": "Main Office",
    "inactiveFlag": false,
    "locationFlag": true,
    "serviceLocationFlag": true,
    "salesLocationFlag": true,
    "transferWorkRolesFlag": false,
    "_info": {
      "lastUpdated": "2023-01-15T00:00:00Z",
      "updatedBy": "admin"
    }
  }
]
```

## Callbacks

Callbacks (webhooks) allow external systems to be notified when events occur in ConnectWise Manage.

### Endpoints

#### Get Callbacks
```
GET /callbacks
GET /callbacks/{id}
GET /callbacks/count
```

**Example Response:**
```json
[
  {
    "id": 1,
    "description": "Ticket Created Notification",
    "url": "https://example.com/webhook/ticket-created",
    "objectId": 1,
    "type": "Ticket",
    "level": "Add",
    "memberId": 1,
    "inactiveFlag": false,
    "options": null,
    "payloadVersion": "1.0",
    "_info": {
      "lastUpdated": "2023-01-15T08:30:00Z",
      "updatedBy": "admin"
    }
  }
]
```

#### Create Callback
```
POST /callbacks
```

**Example Request Body:**
```json
{
  "description": "Ticket Status Changed",
  "url": "https://example.com/webhook/ticket-status",
  "objectId": 1,
  "type": "Ticket",
  "level": "Update",
  "memberId": 1,
  "inactiveFlag": false,
  "payloadVersion": "1.0"
}
```

#### Update Callback
```
PATCH /callbacks/{id}
PUT /callbacks/{id}
```

#### Delete Callback
```
DELETE /callbacks/{id}
```

## API Reports

API Reports allow for running ConnectWise Manage reports via the API.

### Endpoints

#### Get API Reports
```
GET /apiReports
GET /apiReports/{id}
GET /apiReports/count
```

#### Run API Report
```
POST /apiReports/{id}/run
```

**Example Request Body:**
```json
{
  "params": {
    "locationId": 1,
    "startDate": "2023-01-01T00:00:00Z",
    "endDate": "2023-01-31T23:59:59Z"
  }
}
```

## Audittrail

The Audittrail API allows retrieving audit history for objects in ConnectWise Manage.

### Endpoints

#### Get Audit Trail
```
GET /audittrail
```

**Parameters:**
- `type` (required): The type of object (e.g., "Ticket", "Company", "Member")
- `id` (required): The ID of the object

**Example Request:**
```
GET /audittrail?type=Ticket&id=12345
```

## Code Examples

### PowerShell Example: Getting all active members

```powershell
# Authenticate first (see authentication.md)

# Get all active members
$conditions = [System.Web.HttpUtility]::UrlEncode("inactiveFlag=false")
$uri = "https://$Server/v4_6_release/apis/3.0/system/members?conditions=$conditions"

$members = Invoke-RestMethod -Uri $uri -Headers $Headers -Method Get

foreach ($member in $members) {
    Write-Output "Member: $($member.firstName) $($member.lastName) ($($member.identifier))"
    Write-Output "Title: $($member.title)"
    Write-Output "Email: $($member.emailAddress)"
    Write-Output "---"
}
```

### Python Example: Creating a callback (webhook)

```python
import requests
import json
import base64

# Authentication setup (see authentication.md)

# Create a callback (webhook)
callback_data = {
    "description": "New Ticket Notification",
    "url": "https://example.com/webhook/new-ticket",
    "objectId": 1,  # Service board ID
    "type": "Ticket",
    "level": "Add",
    "memberId": 1,  # Member ID who will receive notifications
    "inactiveFlag": False,
    "payloadVersion": "1.0"
}

url = f"https://{server}/v4_6_release/apis/3.0/system/callbacks"
response = requests.post(url, headers=headers, json=callback_data)

if response.status_code == 201:
    new_callback = response.json()
    print(f"Successfully created callback: {new_callback['description']}")
    print(f"ID: {new_callback['id']}")
else:
    print(f"Error: {response.status_code}")
    print(response.text)
```

### PowerShell Example: Getting the audit trail for a ticket

```powershell
# Authenticate first (see authentication.md)

# Get audit trail for a ticket
$ticketId = 12345
$uri = "https://$Server/v4_6_release/apis/3.0/system/audittrail?type=Ticket&id=$ticketId"

$auditTrail = Invoke-RestMethod -Uri $uri -Headers $Headers -Method Get

foreach ($entry in $auditTrail) {
    $entryDate = [DateTime]::Parse($entry.entryDate)
    $entryDateFormatted = $entryDate.ToString("yyyy-MM-dd HH:mm:ss")
    
    Write-Output "Date: $entryDateFormatted"
    Write-Output "User: $($entry.enteredBy)"
    Write-Output "Text: $($entry.text)"
    Write-Output "---"
}
```
