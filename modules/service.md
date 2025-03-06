# ConnectWise Manage Service API

This document covers the Service module APIs in ConnectWise Manage, which includes tickets, boards, and related objects.

## Base URL
All Service endpoints are relative to:
```
https://{server}/v4_6_release/apis/3.0/service
```

## Tickets

Tickets are the core of the Service module, representing service requests, incidents, and problems.

### Endpoints

#### Get Tickets
```
GET /tickets
GET /tickets/{id}
GET /tickets/count
GET /tickets/search
```

**Parameters:**
- `id` (optional): The ID of a specific ticket to retrieve
- `conditions` (optional): Filter the results based on specific conditions
- `orderBy` (optional): Order the results by a specific field
- `page` (optional): Page number for paginated results
- `pageSize` (optional): Number of items per page
- `fields` (optional): Comma-separated list of fields to include in the response
- `childConditions` (optional): Filter child objects based on specific conditions
- `customFieldConditions` (optional): Filter custom fields based on specific conditions

**Example Request:**
```
GET /tickets?conditions=status/name="New" and priority/name="High"&orderBy=dateEntered desc
```

**Example Response:**
```json
[
  {
    "id": 12345,
    "summary": "Server Down",
    "recordType": "ServiceTicket",
    "board": {
      "id": 1,
      "name": "Service Board",
      "_info": {...}
    },
    "status": {
      "id": 1,
      "name": "New",
      "_info": {...}
    },
    "priority": {
      "id": 1,
      "name": "High",
      "_info": {...}
    },
    "company": {
      "id": 1,
      "identifier": "ABC",
      "name": "ABC Company",
      "_info": {...}
    },
    "contact": {
      "id": 1,
      "name": "John Doe",
      "_info": {...}
    },
    "site": {
      "id": 1,
      "name": "Main Office",
      "_info": {...}
    },
    "addressLine1": "123 Main St",
    "city": "Anytown",
    "stateIdentifier": "CA",
    "zip": "12345",
    "country": {
      "id": 1,
      "name": "United States",
      "_info": {...}
    },
    "team": {
      "id": 1,
      "name": "Support Team",
      "_info": {...}
    },
    "owner": {
      "id": 1,
      "identifier": "user1",
      "name": "Support User",
      "_info": {...}
    },
    "serviceLocation": {
      "id": 1,
      "name": "On-Site",
      "_info": {...}
    },
    "source": {
      "id": 1,
      "name": "Phone",
      "_info": {...}
    },
    "requiredDate": "2023-01-15T12:00:00Z",
    "budgetHours": 2.0,
    "dateResolved": null,
    "dateResplan": null,
    "dateResponded": null,
    "resolveMinutes": 0,
    "resPlanMinutes": 0,
    "respondMinutes": 0,
    "impact": "Medium",
    "severity": "Medium",
    "externalXRef": null,
    "poNumber": null,
    "estimatedStartDate": null,
    "dueDate": "2023-01-20T17:00:00Z",
    "resources": "Support User",
    "isInSla": true,
    "customFields": [...],
    "_info": {
      "lastUpdated": "2023-01-15T08:30:00Z",
      "updatedBy": "user1",
      "dateEntered": "2023-01-15T08:15:00Z",
      "enteredBy": "user1"
    }
  }
]
```

#### Create Ticket
```
POST /tickets
```

**Example Request Body:**
```json
{
  "summary": "Server Down",
  "recordType": "ServiceTicket",
  "board": {
    "id": 1
  },
  "status": {
    "id": 1
  },
  "priority": {
    "id": 1
  },
  "company": {
    "id": 1
  },
  "contact": {
    "id": 1
  },
  "site": {
    "id": 1
  },
  "team": {
    "id": 1
  },
  "owner": {
    "id": 1
  },
  "serviceLocation": {
    "id": 1
  },
  "source": {
    "id": 1
  }
}
```

#### Update Ticket
```
PATCH /tickets/{id}
PUT /tickets/{id}
```

**Example Request Body (PATCH):**
```json
{
  "status": {
    "id": 2
  },
  "owner": {
    "id": 2
  }
}
```

#### Delete Ticket
```
DELETE /tickets/{id}
```

### Ticket Notes

#### Get Ticket Notes
```
GET /tickets/{ticketId}/notes
GET /tickets/{ticketId}/notes/{id}
GET /tickets/{ticketId}/notes/count
```

**Example Response:**
```json
[
  {
    "id": 1,
    "ticketId": 12345,
    "text": "Called customer to get more information",
    "detailDescriptionFlag": false,
    "internalAnalysisFlag": true,
    "resolutionFlag": false,
    "member": {
      "id": 1,
      "identifier": "user1",
      "name": "Support User",
      "_info": {...}
    },
    "dateCreated": "2023-01-15T08:45:00Z",
    "createdBy": "user1",
    "internalFlag": true,
    "externalFlag": false,
    "_info": {
      "lastUpdated": "2023-01-15T08:45:00Z",
      "updatedBy": "user1"
    }
  }
]
```

#### Create Ticket Note
```
POST /tickets/{ticketId}/notes
```

**Example Request Body:**
```json
{
  "text": "Called customer to get more information",
  "internalAnalysisFlag": true,
  "internalFlag": true
}
```

#### Update Ticket Note
```
PUT /tickets/{ticketId}/notes/{id}
```

#### Delete Ticket Note
```
DELETE /tickets/{ticketId}/notes/{id}
```

### Ticket Tasks

#### Get Ticket Tasks
```
GET /tickets/{ticketId}/tasks
GET /tickets/{ticketId}/tasks/{id}
GET /tickets/{ticketId}/tasks/count
```

#### Create Ticket Task
```
POST /tickets/{ticketId}/tasks
```

**Example Request Body:**
```json
{
  "notes": "Restart server",
  "priority": 1,
  "schedule": {
    "id": 1
  }
}
```

#### Update Ticket Task
```
PUT /tickets/{ticketId}/tasks/{id}
```

#### Delete Ticket Task
```
DELETE /tickets/{ticketId}/tasks/{id}
```

### Ticket Configurations

#### Get Ticket Configurations
```
GET /tickets/{ticketId}/configurations
GET /tickets/{ticketId}/configurations/{id}
GET /tickets/{ticketId}/configurations/count
```

#### Create Ticket Configuration
```
POST /tickets/{ticketId}/configurations
```

**Example Request Body:**
```json
{
  "configuration": {
    "id": 123
  }
}
```

#### Delete Ticket Configuration
```
DELETE /tickets/{ticketId}/configurations/{id}
```

## Boards

Boards are containers for tickets, with their own workflows and rules.

### Endpoints

#### Get Boards
```
GET /boards
GET /boards/{id}
GET /boards/count
```

**Example Response:**
```json
[
  {
    "id": 1,
    "name": "Service Board",
    "locationId": 1,
    "businessUnitId": 1,
    "inactiveFlag": false,
    "signOffTemplateId": null,
    "sendToContactFlag": true,
    "billTicketsAfterClosedFlag": false,
    "billProductsAfterClosedFlag": false,
    "showDependenciesFlag": true,
    "autoAssignNewTicketsFlag": true,
    "autoAssignNewRequestsFlag": true,
    "serviceManagerFlag": true,
    "enableEscsFlag": true,
    "defaultEscalationTemplateId": 1,
    "projectFlag": false,
    "dispatchMember": {
      "id": 1,
      "identifier": "user1",
      "name": "Dispatch User",
      "_info": {...}
    },
    "serviceTypeIds": [1, 2, 3],
    "workTypeIds": [1, 2],
    "workRoleIds": [1, 2],
    "autoAssignTicketOwnerFlag": true,
    "billTime": "Billable",
    "billExpense": "Billable",
    "billProduct": "Billable",
    "discussionsFlag": true,
    "emailConnectorAllowReopenClosedFlag": true,
    "emailConnectorReopenStatus": {
      "id": 1,
      "name": "New",
      "_info": {...}
    },
    "emailConnectorNewTicketNoMatchFlag": true,
    "_info": {
      "lastUpdated": "2023-01-15T00:00:00Z",
      "updatedBy": "admin"
    }
  }
]
```

#### Create Board
```
POST /boards
```

#### Update Board
```
PATCH /boards/{id}
PUT /boards/{id}
```

#### Delete Board
```
DELETE /boards/{id}
```

### Board Status

#### Get Board Statuses
```
GET /boards/{boardId}/statuses
GET /boards/{boardId}/statuses/{id}
GET /boards/{boardId}/statuses/count
```

**Example Response:**
```json
[
  {
    "id": 1,
    "name": "New",
    "boardId": 1,
    "sortOrder": 1,
    "displayOnBoard": true,
    "inactiveFlag": false,
    "closedStatus": false,
    "timeEntryNotAllowed": false,
    "defaultFlag": true,
    "escalationStatus": "NotResponded",
    "customer": {
      "value": "Following"
    },
    "resources": {
      "value": "Waiting"
    },
    "_info": {
      "lastUpdated": "2023-01-15T00:00:00Z",
      "updatedBy": "admin"
    }
  }
]
```

### Board Types

#### Get Board Types
```
GET /boards/{boardId}/types
GET /boards/{boardId}/types/{id}
GET /boards/{boardId}/types/count
```

### Board Subtypes

#### Get Board Subtypes
```
GET /boards/{boardId}/subtypes
GET /boards/{boardId}/subtypes/{id}
GET /boards/{boardId}/subtypes/count
```

### Board Teams

#### Get Board Teams
```
GET /boards/{boardId}/teams
GET /boards/{boardId}/teams/{id}
GET /boards/{boardId}/teams/count
```

## Priorities

### Endpoints

#### Get Priorities
```
GET /priorities
GET /priorities/{id}
GET /priorities/count
```

**Example Response:**
```json
[
  {
    "id": 1,
    "name": "High",
    "sortOrder": 1,
    "color": "#FF0000",
    "defaultFlag": false,
    "respondHours": 1,
    "respondPercent": 75,
    "resolveHours": 8,
    "resolvePercent": 75,
    "image": "priority1.png",
    "_info": {
      "lastUpdated": "2023-01-15T00:00:00Z",
      "updatedBy": "admin"
    }
  }
]
```

## SLAs

### Endpoints

#### Get SLAs
```
GET /slAs
GET /slAs/{id}
GET /slAs/count
```

**Example Response:**
```json
[
  {
    "id": 1,
    "name": "Standard SLA",
    "defaultFlag": true,
    "respondHours": 4,
    "respondPercent": 75,
    "planWithin": 8,
    "planWithinPercent": 75,
    "resolutionHours": 16,
    "resolutionPercent": 75,
    "customCalendar": {
      "id": 1,
      "name": "Standard Calendar",
      "_info": {...}
    },
    "_info": {
      "lastUpdated": "2023-01-15T00:00:00Z",
      "updatedBy": "admin"
    }
  }
]
```

## Sources

### Endpoints

#### Get Sources
```
GET /sources
GET /sources/{id}
GET /sources/count
```

**Example Response:**
```json
[
  {
    "id": 1,
    "name": "Phone",
    "defaultFlag": true,
    "_info": {
      "lastUpdated": "2023-01-15T00:00:00Z",
      "updatedBy": "admin"
    }
  }
]
```

## Service Locations

### Endpoints

#### Get Service Locations
```
GET /serviceLocations
GET /serviceLocations/{id}
GET /serviceLocations/count
```

**Example Response:**
```json
[
  {
    "id": 1,
    "name": "On-Site",
    "defaultFlag": true,
    "_info": {
      "lastUpdated": "2023-01-15T00:00:00Z",
      "updatedBy": "admin"
    }
  }
]
```

## Knowledge Base

### Endpoints

#### Get Knowledge Base Articles
```
GET /knowledgeBaseArticles
GET /knowledgeBaseArticles/{id}
GET /knowledgeBaseArticles/count
GET /knowledgeBaseArticles/search
```

**Example Response:**
```json
[
  {
    "id": 1,
    "title": "How to Reset Password",
    "issue": "User forgot password",
    "resolution": "Reset using admin portal",
    "dateCreated": "2023-01-15T00:00:00Z",
    "createdBy": "admin",
    "locationId": 1,
    "businessUnitId": 1,
    "boardId": 1,
    "categoryId": 1,
    "subCategoryId": 1,
    "viewsActive": 45,
    "viewsInactive": 0,
    "_info": {
      "lastUpdated": "2023-01-15T00:00:00Z",
      "updatedBy": "admin"
    }
  }
]
```

#### Create Knowledge Base Article
```
POST /knowledgeBaseArticles
```

#### Update Knowledge Base Article
```
PATCH /knowledgeBaseArticles/{id}
PUT /knowledgeBaseArticles/{id}
```

#### Delete Knowledge Base Article
```
DELETE /knowledgeBaseArticles/{id}
```

## Callbacks

### Endpoints

#### Get Callbacks
```
GET /callbacks
GET /callbacks/{id}
GET /callbacks/count
```

#### Create Callback
```
POST /callbacks
```

**Example Request Body:**
```json
{
  "description": "Ticket Status Changed",
  "url": "https://example.com/webhook",
  "objectId": 1,
  "type": "Ticket",
  "level": "Status",
  "memberId": 1,
  "payloadVersion": "1.0",
  "inactiveFlag": false
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

## Code Examples

### PowerShell Example: Getting Tickets with Conditions

```powershell
# Authenticate first (see authentication.md)
$Server = "na.myconnectwise.net"
$Company = "mycompany"
$PubKey = "PublicKey"
$PrivateKey = "PrivateKey"
$ClientID = "ClientID"

$AuthString = "$($Company)+$($PubKey):$($PrivateKey)"
$EncodedAuth = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes($AuthString))

$Headers = @{
    'Authorization' = "Basic $EncodedAuth"
    'ClientID' = $ClientID
    'Content-Type' = 'application/json'
    'Accept' = 'application/vnd.connectwise.com+json; version=2022.1'
}

# Get all open tickets for a specific company
$companyId = 123
$conditions = [System.Web.HttpUtility]::UrlEncode("company/id=$companyId and closedFlag=false")
$uri = "https://$Server/v4_6_release/apis/3.0/service/tickets?conditions=$conditions"

$tickets = Invoke-RestMethod -Uri $uri -Headers $Headers -Method Get

foreach ($ticket in $tickets) {
    Write-Output "Ticket #$($ticket.id): $($ticket.summary)"
}
```

### Python Example: Creating a Ticket

```python
import requests
import json
import base64

# Authentication setup
server = "na.myconnectwise.net"
company = "mycompany"
pub_key = "PublicKey"
private_key = "PrivateKey"
client_id = "ClientID"

# Create auth string
auth_string = f"{company}+{pub_key}:{private_key}"
encoded_auth = base64.b64encode(auth_string.encode('utf-8')).decode('utf-8')

headers = {
    'Authorization': f"Basic {encoded_auth}",
    'ClientID': client_id,
    'Content-Type': 'application/json',
    'Accept': 'application/vnd.connectwise.com+json; version=2022.1'
}

# Create a ticket
ticket_data = {
    "summary": "New server deployment",
    "recordType": "ProjectTicket",
    "board": {
        "id": 1
    },
    "status": {
        "id": 1
    },
    "priority": {
        "id": 2
    },
    "company": {
        "id": 123
    },
    "contact": {
        "id": 456
    }
}

url = f"https://{server}/v4_6_release/apis/3.0/service/tickets"
response = requests.post(url, headers=headers, json=ticket_data)

if response.status_code == 201:
    new_ticket = response.json()
    print(f"Successfully created ticket #{new_ticket['id']}")
else:
    print(f"Error: {response.status_code}")
    print(response.text)
```
