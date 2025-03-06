# ConnectWise Manage API Reference

A comprehensive reference for the ConnectWise Manage REST API commands, endpoints, and usage examples.

## Overview

ConnectWise Manage provides a RESTful API that allows users to interact with their ConnectWise Manage instance programmatically. This repository documents all major endpoints, their parameters, and includes code examples to help you quickly implement ConnectWise Manage integrations.

## Quick Start

### 1. Authentication Setup

First, you need to authenticate with the ConnectWise Manage API. See [Authentication](authentication.md) for detailed instructions.

Basic PowerShell authentication example:
```powershell
$Server = "na.myconnectwise.net"
$Company = "mycompany"
$PubKey = "YourPublicKey"
$PrivateKey = "YourPrivateKey"
$ClientID = "YourClientID"

$AuthString = "$($Company)+$($PubKey):$($PrivateKey)"
$EncodedAuth = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes($AuthString))

$Headers = @{
    'Authorization' = "Basic $EncodedAuth"
    'ClientID' = $ClientID
    'Content-Type' = 'application/json'
    'Accept' = 'application/vnd.connectwise.com+json; version=2022.1'
}
```

Basic Python authentication example:
```python
import requests
import json
import base64

server = "na.myconnectwise.net"
company = "mycompany"
pub_key = "YourPublicKey"
private_key = "YourPrivateKey"
client_id = "YourClientID"

# Create auth string
auth_string = f"{company}+{pub_key}:{private_key}"
encoded_auth = base64.b64encode(auth_string.encode('utf-8')).decode('utf-8')

headers = {
    'Authorization': f"Basic {encoded_auth}",
    'ClientID': client_id,
    'Content-Type': 'application/json',
    'Accept': 'application/vnd.connectwise.com+json; version=2022.1'
}
```

### 2. Common API Operations

#### Get items with filtering:
```python
import urllib.parse

condition = "status/name='New' and priority/name='High'"
encoded_condition = urllib.parse.quote(condition)
url = f"https://{server}/v4_6_release/apis/3.0/service/tickets?conditions={encoded_condition}"

response = requests.get(url, headers=headers)
tickets = response.json()
```

#### Create an item:
```python
data = {
    "summary": "Server Down",
    "recordType": "ServiceTicket",
    "board": {
        "id": 1
    },
    "company": {
        "id": 123
    }
}

url = f"https://{server}/v4_6_release/apis/3.0/service/tickets"
response = requests.post(url, headers=headers, json=data)
new_ticket = response.json()
```

## Documentation Structure

This repository is organized as follows:

### Core Concepts

- **[Authentication](authentication.md)**: Authentication methods and examples
- **[Core Concepts](core-concepts.md)**: Pagination, filtering, error handling, and other common patterns

### Module-specific Documentation

#### Company Module
- [**Company Overview**](modules/company.md): Main company entities
- [**Company Contacts**](modules/company_contacts.md): Contact management
- [**Company Sites**](modules/company_sites.md): Site management
- [**Company Configurations**](modules/company_configurations.md): Configuration/asset management

#### Service Module
- [**Service Module**](modules/service.md): Tickets, boards, and service-related entities

#### System Module
- [**System Module**](modules/system.md): Members, info, departments, and system-wide settings

#### Time Module
- [**Time Module**](modules/time.md): Time entries, time sheets, work types and roles

#### Other Modules (Coming Soon)
- Finance
- Marketing
- Procurement
- Project
- Sales
- Schedule

## Example Scripts

The repository includes working example scripts to help you get started:

### PowerShell Example
[cwm-api-demo.ps1](examples/cwm-api-demo.ps1) - A comprehensive PowerShell script demonstrating how to:
- Authenticate with the ConnectWise Manage API
- Retrieve companies, tickets, and members
- Create tickets and add notes
- Add time entries
- And more

### Python Example
[cwm_api_demo.py](examples/cwm_api_demo.py) - A Python equivalent of the PowerShell demo that shows:
- Authentication with the API
- Working with companies and tickets
- Creating and updating records
- Error handling and best practices

To run these examples, update the configuration variables at the top of each script with your ConnectWise Manage credentials and server information.

## API Base URL

The ConnectWise Manage API base URL follows this format:
```
https://{server}/v4_6_release/apis/3.0/
```

Where:
- `{server}` is your ConnectWise Manage server (e.g., `na.myconnectwise.net`)

## Common Query Parameters

Most GET endpoints support the following query parameters:

| Parameter | Description | Example |
|-----------|-------------|---------|
| `conditions` | Filter results based on conditions | `status/name="New"` |
| `orderBy` | Sort order | `dateEntered desc` |
| `page` | Page number for pagination | `1` |
| `pageSize` | Results per page | `50` |
| `fields` | Fields to include | `id,summary,status` |
| `childConditions` | Filter child objects | `notes/text contains "important"` |
| `customFieldConditions` | Filter custom fields | `customFields/id=123 and customFields/value="Value"` |

## Common HTTP Status Codes

| Code | Description |
|------|-------------|
| 200 | Success - GET, PUT, PATCH |
| 201 | Created - POST |
| 204 | No Content - DELETE |
| 400 | Bad Request |
| 401 | Unauthorized |
| 403 | Forbidden |
| 404 | Not Found |
| 429 | Too Many Requests |
| 500 | Internal Server Error |

## Best Practices

1. **Use filtering**: Always use conditions to limit your result set
2. **Select specific fields**: Use the fields parameter to reduce payload size
3. **Implement pagination**: Process large result sets in chunks
4. **Handle rate limiting**: Implement backoff logic for 429 responses
5. **Cache when possible**: Avoid duplicate requests for static data

## Contributing

Feel free to contribute to this reference by submitting pull requests or opening issues for any missing or incorrect information.

## Resources

- [Official ConnectWise Developer Documentation](https://developer.connectwise.com/Products/Manage/REST)
- [ConnectWise API Client Creation](https://developer.connectwise.com/ClientID)
