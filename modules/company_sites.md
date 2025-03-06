# ConnectWise Manage Company Sites API

This document covers the Site-related APIs within the Company module of ConnectWise Manage.

## Base URL
All Company endpoints are relative to:
```
https://{server}/v4_6_release/apis/3.0/company
```

## Sites

Sites represent physical locations for companies.

### Endpoints

#### Get Sites
```
GET /companies/{companyId}/sites
GET /companies/{companyId}/sites/{id}
GET /companies/{companyId}/sites/count
```

**Parameters:**
- `companyId`: The ID of the company
- `id` (optional): The ID of a specific site to retrieve
- `conditions` (optional): Filter the results based on specific conditions
- `orderBy` (optional): Order the results by a specific field
- `page` (optional): Page number for paginated results
- `pageSize` (optional): Number of items per page

**Example Request:**
```
GET /companies/123/sites?orderBy=name asc
```

**Example Response:**
```json
[
  {
    "id": 1,
    "name": "Main Office",
    "addressLine1": "123 Main St",
    "addressLine2": "Suite 100",
    "city": "Anytown",
    "state": "CA",
    "zip": "12345",
    "country": {
      "id": 1,
      "name": "United States",
      "_info": {...}
    },
    "addressFormat": "123 Main St\nSuite 100\nAnytown, CA 12345\nUnited States",
    "phoneNumber": "800-555-1234",
    "faxNumber": "800-555-5678",
    "defaultBillingFlag": true,
    "defaultShippingFlag": true,
    "defaultMailing": true,
    "defaultPrimaryFlag": true,
    "inactiveFlag": false,
    "expenseReimbursement": false,
    "_info": {
      "lastUpdated": "2023-01-15T08:30:00Z",
      "updatedBy": "admin"
    }
  }
]
```

#### Create Site
```
POST /companies/{companyId}/sites
```

**Example Request Body:**
```json
{
  "name": "Branch Office",
  "addressLine1": "456 Branch Rd",
  "city": "Othertown",
  "state": "NY",
  "zip": "54321",
  "phoneNumber": "800-555-4321"
}
```

#### Update Site
```
PATCH /companies/{companyId}/sites/{id}
PUT /companies/{companyId}/sites/{id}
```

**Example Request Body (PATCH):**
```json
{
  "phoneNumber": "800-555-9876",
  "defaultBillingFlag": true
}
```

#### Delete Site
```
DELETE /companies/{companyId}/sites/{id}
```

## Code Examples

### PowerShell Example: Getting all sites for a company

```powershell
# Authenticate first (see authentication.md)

# Get all sites for a specific company
$companyId = 123
$uri = "https://$Server/v4_6_release/apis/3.0/company/companies/$companyId/sites"

$sites = Invoke-RestMethod -Uri $uri -Headers $Headers -Method Get

foreach ($site in $sites) {
    Write-Output "Site Name: $($site.name)"
    Write-Output "Address: $($site.addressFormat -replace '\\n', ', ')"
    Write-Output "Phone: $($site.phoneNumber)"
    Write-Output "Default Billing: $($site.defaultBillingFlag)"
    Write-Output "Default Shipping: $($site.defaultShippingFlag)"
    Write-Output "---"
}
```

### Python Example: Creating a new site

```python
import requests
import json
import base64

# Authentication setup (see authentication.md)

# Create a site
company_id = 123
site_data = {
    "name": "Branch Office",
    "addressLine1": "456 Branch Rd",
    "city": "Othertown",
    "state": "NY",
    "zip": "54321",
    "phoneNumber": "800-555-4321",
    "defaultBillingFlag": False,
    "defaultShippingFlag": True
}

url = f"https://{server}/v4_6_release/apis/3.0/company/companies/{company_id}/sites"
response = requests.post(url, headers=headers, json=site_data)

if response.status_code == 201:
    new_site = response.json()
    print(f"Successfully created site: {new_site['name']}")
else:
    print(f"Error: {response.status_code}")
    print(response.text)
```
