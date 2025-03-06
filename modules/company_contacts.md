# ConnectWise Manage Company Contacts API

This document covers the Contact-related APIs within the Company module of ConnectWise Manage.

## Base URL
All Company endpoints are relative to:
```
https://{server}/v4_6_release/apis/3.0/company
```

## Contacts

Contacts represent individuals associated with companies.

### Endpoints

#### Get Contacts
```
GET /contacts
GET /contacts/{id}
GET /contacts/count
GET /contacts/search
```

**Parameters:**
- `id` (optional): The ID of a specific contact to retrieve
- `conditions` (optional): Filter the results based on specific conditions
- `orderBy` (optional): Order the results by a specific field
- `page` (optional): Page number for paginated results
- `pageSize` (optional): Number of items per page
- `fields` (optional): Comma-separated list of fields to include in the response

**Example Request:**
```
GET /contacts?conditions=company/id=123&orderBy=lastName asc
```

#### Create Contact
```
POST /contacts
```

**Example Request Body:**
```json
{
  "firstName": "Jane",
  "lastName": "Smith",
  "company": {
    "id": 123
  },
  "title": "CEO",
  "site": {
    "id": 1
  },
  "addressLine1": "123 Main St",
  "city": "Anytown",
  "state": "CA",
  "zip": "12345",
  "communicationItems": [
    {
      "type": {
        "id": 1
      },
      "value": "jane.smith@xyzcorp.com",
      "defaultFlag": true
    }
  ]
}
```

#### Update Contact
```
PATCH /contacts/{id}
PUT /contacts/{id}
```

#### Delete Contact
```
DELETE /contacts/{id}
```

### Contact Communications

#### Get Contact Communications
```
GET /contacts/{contactId}/communications
GET /contacts/{contactId}/communications/{id}
GET /contacts/{contactId}/communications/count
```

#### Create Contact Communication
```
POST /contacts/{contactId}/communications
```

**Example Request Body:**
```json
{
  "type": {
    "id": 1
  },
  "value": "jane.smith@personal.com",
  "defaultFlag": false
}
```

#### Update Contact Communication
```
PATCH /contacts/{contactId}/communications/{id}
PUT /contacts/{contactId}/communications/{id}
```

#### Delete Contact Communication
```
DELETE /contacts/{contactId}/communications/{id}
```

### Contact Notes

#### Get Contact Notes
```
GET /contacts/{contactId}/notes
GET /contacts/{contactId}/notes/{id}
GET /contacts/{contactId}/notes/count
```

#### Create Contact Note
```
POST /contacts/{contactId}/notes
```

**Example Request Body:**
```json
{
  "text": "Met with Jane at the industry conference",
  "enteredBy": "user1"
}
```

#### Update Contact Note
```
PATCH /contacts/{contactId}/notes/{id}
PUT /contacts/{contactId}/notes/{id}
```

#### Delete Contact Note
```
DELETE /contacts/{contactId}/notes/{id}
```

### Contact Types

#### Get Contact Types
```
GET /contacts/types
GET /contacts/types/{id}
GET /contacts/types/count
```

### Communication Types

#### Get Communication Types
```
GET /communicationTypes
GET /communicationTypes/{id}
GET /communicationTypes/count
```

## Code Examples

### PowerShell Example: Finding contacts at a company

```powershell
# Authenticate first (see authentication.md)

# Find all contacts at a specific company
$companyId = 123
$conditions = [System.Web.HttpUtility]::UrlEncode("company/id=$companyId")
$uri = "https://$Server/v4_6_release/apis/3.0/company/contacts?conditions=$conditions"

$contacts = Invoke-RestMethod -Uri $uri -Headers $Headers -Method Get

foreach ($contact in $contacts) {
    Write-Output "$($contact.firstName) $($contact.lastName) - $($contact.title)"
    
    # Get contact's email if available
    $emailComm = $contact.communicationItems | Where-Object { 
        $_.type.description -eq "Email" -and $_.defaultFlag -eq $true 
    }
    
    if ($emailComm) {
        Write-Output "Email: $($emailComm.value)"
    }
}
```

### Python Example: Creating a new contact

```python
import requests
import json
import base64

# Authentication setup (see authentication.md)

# Create a contact
contact_data = {
    "firstName": "Jane",
    "lastName": "Smith",
    "company": {
        "id": 123
    },
    "title": "CEO",
    "site": {
        "id": 1
    },
    "communicationItems": [
        {
            "type": {
                "id": 1  # Email
            },
            "value": "jane.smith@xyzcorp.com",
            "defaultFlag": True
        },
        {
            "type": {
                "id": 2  # Phone
            },
            "value": "800-555-1234",
            "defaultFlag": True
        }
    ]
}

url = f"https://{server}/v4_6_release/apis/3.0/company/contacts"
response = requests.post(url, headers=headers, json=contact_data)

if response.status_code == 201:
    new_contact = response.json()
    print(f"Successfully created contact: {new_contact['firstName']} {new_contact['lastName']}")
else:
    print(f"Error: {response.status_code}")
    print(response.text)
```
