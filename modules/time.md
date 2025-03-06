# ConnectWise Manage Time API

This document covers the Time module APIs in ConnectWise Manage, which includes time entries, time sheets, and work types.

## Base URL
All Time endpoints are relative to:
```
https://{server}/v4_6_release/apis/3.0/time
```

## Time Entries

Time entries represent time spent on tickets, projects, or activities.

### Endpoints

#### Get Time Entries
```
GET /entries
GET /entries/{id}
GET /entries/count
GET /entries/search
```

**Parameters:**
- `id` (optional): The ID of a specific time entry to retrieve
- `conditions` (optional): Filter the results based on specific conditions
- `orderBy` (optional): Order the results by a specific field
- `page` (optional): Page number for paginated results
- `pageSize` (optional): Number of items per page
- `fields` (optional): Comma-separated list of fields to include in the response

**Example Request:**
```
GET /entries?conditions=member/identifier="jsmith" and dateStart > [2023-01-01T00:00:00Z]&orderBy=dateStart desc
```

**Example Response:**
```json
[
  {
    "id": 12345,
    "company": {
      "id": 123,
      "identifier": "ABC",
      "name": "ABC Company",
      "_info": {...}
    },
    "chargeToId": 456,
    "chargeToType": "ServiceTicket",
    "member": {
      "id": 1,
      "identifier": "jsmith",
      "name": "John Smith",
      "_info": {...}
    },
    "locationId": 1,
    "businessUnitId": 1,
    "workType": {
      "id": 1,
      "name": "Remote",
      "_info": {...}
    },
    "workRole": {
      "id": 1,
      "name": "Engineer",
      "_info": {...}
    },
    "agreement": null,
    "timeStart": "2023-01-15T08:00:00Z",
    "timeEnd": "2023-01-15T12:00:00Z",
    "hoursDeduct": 0,
    "actualHours": 4,
    "billableOption": "Billable",
    "notes": "Installed software updates and performed system maintenance",
    "internalNotes": "No issues encountered",
    "addToDetailDescriptionFlag": false,
    "addToInternalAnalysisFlag": false,
    "addToResolutionFlag": false,
    "emailResourceFlag": false,
    "emailContactFlag": false,
    "emailCcFlag": false,
    "hoursBilled": 4,
    "enteredBy": "jsmith",
    "dateEntered": "2023-01-15T12:05:00Z",
    "invoice": null,
    "mobileGuid": null,
    "hourlyRate": 150,
    "timeSheet": {
      "id": 789,
      "_info": {...}
    },
    "customFields": [...],
    "_info": {
      "lastUpdated": "2023-01-15T12:05:00Z",
      "updatedBy": "jsmith"
    }
  }
]
```

#### Create Time Entry
```
POST /entries
```

**Example Request Body:**
```json
{
  "company": {
    "id": 123
  },
  "chargeToId": 456,
  "chargeToType": "ServiceTicket",
  "member": {
    "id": 1
  },
  "locationId": 1,
  "businessUnitId": 1,
  "workType": {
    "id": 1
  },
  "workRole": {
    "id": 1
  },
  "timeStart": "2023-01-15T13:00:00Z",
  "timeEnd": "2023-01-15T17:00:00Z",
  "actualHours": 4,
  "billableOption": "Billable",
  "notes": "Configured new firewall and tested connectivity"
}
```

#### Update Time Entry
```
PATCH /entries/{id}
PUT /entries/{id}
```

**Example Request Body (PATCH):**
```json
{
  "notes": "Configured new firewall, tested connectivity, and documented settings",
  "timeEnd": "2023-01-15T17:30:00Z",
  "actualHours": 4.5
}
```

#### Delete Time Entry
```
DELETE /entries/{id}
```

## Time Sheets

Time sheets represent collections of time entries for a specific member and period.

### Endpoints

#### Get Time Sheets
```
GET /sheets
GET /sheets/{id}
GET /sheets/count
GET /sheets/search
```

**Example Response:**
```json
[
  {
    "id": 789,
    "member": {
      "id": 1,
      "identifier": "jsmith",
      "name": "John Smith",
      "_info": {...}
    },
    "year": 2023,
    "period": 1,
    "periodStart": "2023-01-01T00:00:00Z",
    "periodEnd": "2023-01-15T23:59:59Z",
    "status": "InProgress",
    "hours": 36,
    "totalHours": 36,
    "salary": {
      "regular": 36,
      "overtime": 0,
      "nonBillable": 0
    },
    "hourly": {
      "regular": 0,
      "overtime": 0,
      "nonBillable": 0
    },
    "deadline": "2023-01-18T23:59:59Z",
    "_info": {
      "lastUpdated": "2023-01-15T12:05:00Z",
      "updatedBy": "jsmith"
    }
  }
]
```

#### Submit Time Sheet
```
POST /sheets/{id}/submit
```

**Example Response:**
```json
{
  "id": 789,
  "status": "Submitted",
  "_info": {
    "lastUpdated": "2023-01-15T14:30:00Z",
    "updatedBy": "jsmith"
  }
}
```

#### Approve Time Sheet
```
POST /sheets/{id}/approve
```

**Example Response:**
```json
{
  "id": 789,
  "status": "Approved",
  "_info": {
    "lastUpdated": "2023-01-16T09:15:00Z",
    "updatedBy": "manager"
  }
}
```

#### Reject Time Sheet
```
POST /sheets/{id}/reject
```

**Example Request Body:**
```json
{
  "rejectionReason": "Missing time entries for Monday"
}
```

**Example Response:**
```json
{
  "id": 789,
  "status": "Rejected",
  "_info": {
    "lastUpdated": "2023-01-16T09:20:00Z",
    "updatedBy": "manager"
  }
}
```

#### Reopen Time Sheet
```
POST /sheets/{id}/reopen
```

## Work Types

Work types represent the types of work that can be performed.

### Endpoints

#### Get Work Types
```
GET /workTypes
GET /workTypes/{id}
GET /workTypes/count
```

**Example Response:**
```json
[
  {
    "id": 1,
    "name": "Remote",
    "inactiveFlag": false,
    "overallDefaultFlag": true,
    "serviceDefaultFlag": true,
    "projectDefaultFlag": false,
    "billTime": "Billable",
    "rateType": "Standard",
    "externalId": null,
    "snoozingFlag": false,
    "_info": {
      "lastUpdated": "2023-01-15T00:00:00Z",
      "updatedBy": "admin"
    }
  },
  {
    "id": 2,
    "name": "On-Site",
    "inactiveFlag": false,
    "overallDefaultFlag": false,
    "serviceDefaultFlag": false,
    "projectDefaultFlag": true,
    "billTime": "Billable",
    "rateType": "Standard",
    "externalId": null,
    "snoozingFlag": false,
    "_info": {
      "lastUpdated": "2023-01-15T00:00:00Z",
      "updatedBy": "admin"
    }
  }
]
```

## Work Roles

Work roles represent the roles that members can fulfill when performing work.

### Endpoints

#### Get Work Roles
```
GET /workRoles
GET /workRoles/{id}
GET /workRoles/count
```

**Example Response:**
```json
[
  {
    "id": 1,
    "name": "Engineer",
    "inactiveFlag": false,
    "hourlyRate": 150,
    "locationId": 1,
    "businessUnitId": 1,
    "_info": {
      "lastUpdated": "2023-01-15T00:00:00Z",
      "updatedBy": "admin"
    }
  },
  {
    "id": 2,
    "name": "Project Manager",
    "inactiveFlag": false,
    "hourlyRate": 175,
    "locationId": 1,
    "businessUnitId": 1,
    "_info": {
      "lastUpdated": "2023-01-15T00:00:00Z",
      "updatedBy": "admin"
    }
  }
]
```

## Charge Codes

Charge codes represent codes that can be used to categorize time entries.

### Endpoints

#### Get Charge Codes
```
GET /chargeCodes
GET /chargeCodes/{id}
GET /chargeCodes/count
```

**Example Response:**
```json
[
  {
    "id": 1,
    "name": "Maintenance",
    "company": {
      "id": 0,
      "identifier": "All",
      "name": "All",
      "_info": {...}
    },
    "locationId": 1,
    "businessUnitId": 1,
    "workRole": {
      "id": 1,
      "name": "Engineer",
      "_info": {...}
    },
    "workType": {
      "id": 1,
      "name": "Remote",
      "_info": {...}
    },
    "billTime": "NoDefault",
    "notes": "Used for routine maintenance activities",
    "status": "Active",
    "expenseEntryFlag": false,
    "allowAllExpTypesFlag": false,
    "timeEntryFlag": true,
    "productEntryFlag": false,
    "integrationXRef": null,
    "_info": {
      "lastUpdated": "2023-01-15T00:00:00Z",
      "updatedBy": "admin"
    }
  }
]
```

## Code Examples

### PowerShell Example: Create a time entry

```powershell
# Authenticate first (see authentication.md)

# Create a time entry
$timeEntry = @{
    company = @{
        id = 123
    }
    chargeToId = 456
    chargeToType = "ServiceTicket"
    member = @{
        id = 1
    }
    locationId = 1
    businessUnitId = 1
    workType = @{
        id = 1
    }
    workRole = @{
        id = 1
    }
    timeStart = (Get-Date).AddHours(-4).ToString("o")
    timeEnd = (Get-Date).ToString("o")
    actualHours = 4
    billableOption = "Billable"
    notes = "Resolved network connectivity issues"
}

$uri = "https://$Server/v4_6_release/apis/3.0/time/entries"
$timeEntryJson = $timeEntry | ConvertTo-Json

$newTimeEntry = Invoke-RestMethod -Uri $uri -Headers $Headers -Method Post -Body $timeEntryJson -ContentType "application/json"

Write-Output "Created time entry ID: $($newTimeEntry.id)"
Write-Output "Hours: $($newTimeEntry.actualHours)"
Write-Output "Billable: $($newTimeEntry.billableOption)"
```

### Python Example: Getting time entries for a member in a date range

```python
import requests
import json
import base64
import urllib.parse

# Authentication setup (see authentication.md)

# Get time entries for a member in a date range
member_identifier = "jsmith"
start_date = "2023-01-01T00:00:00Z"
end_date = "2023-01-31T23:59:59Z"

# Build condition
condition = f"member/identifier='{member_identifier}' and timeStart >= [{start_date}] and timeStart <= [{end_date}]"
encoded_condition = urllib.parse.quote(condition)

url = f"https://{server}/v4_6_release/apis/3.0/time/entries?conditions={encoded_condition}&orderBy=timeStart asc"
response = requests.get(url, headers=headers)

if response.status_code == 200:
    time_entries = response.json()
    
    # Calculate total hours
    total_hours = sum(entry.get('actualHours', 0) for entry in time_entries)
    billable_hours = sum(entry.get('actualHours', 0) for entry in time_entries if entry.get('billableOption') == 'Billable')
    
    print(f"Found {len(time_entries)} time entries")
    print(f"Total hours: {total_hours}")
    print(f"Billable hours: {billable_hours}")
    print(f"Billable percentage: {(billable_hours / total_hours * 100) if total_hours > 0 else 0:.2f}%")
    
    # Print time entry details
    for entry in time_entries:
        start_time = entry.get('timeStart')
        charge_type = entry.get('chargeToType')
        charge_id = entry.get('chargeToId')
        hours = entry.get('actualHours')
        notes = entry.get('notes')
        
        print(f"{start_time} | {charge_type} #{charge_id} | {hours} hours | {notes[:50]}...")
else:
    print(f"Error: {response.status_code}")
    print(response.text)
```

### PowerShell Example: Submit a time sheet

```powershell
# Authenticate first (see authentication.md)

# Get the current time sheet for a member
$memberId = 1
$conditions = [System.Web.HttpUtility]::UrlEncode("member/id=$memberId and status='InProgress'")
$uri = "https://$Server/v4_6_release/apis/3.0/time/sheets?conditions=$conditions"

$timeSheets = Invoke-RestMethod -Uri $uri -Headers $Headers -Method Get

if ($timeSheets.Count -gt 0) {
    $timeSheet = $timeSheets[0]
    $timeSheetId = $timeSheet.id
    
    # Submit the time sheet
    $submitUri = "https://$Server/v4_6_release/apis/3.0/time/sheets/$timeSheetId/submit"
    $submitResult = Invoke-RestMethod -Uri $submitUri -Headers $Headers -Method Post
    
    Write-Output "Submitted time sheet ID: $($submitResult.id)"
    Write-Output "Status: $($submitResult.status)"
    Write-Output "Hours: $($submitResult.hours)"
} else {
    Write-Output "No in-progress time sheets found for member ID: $memberId"
}
```
