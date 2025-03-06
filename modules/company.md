# ConnectWise Manage Company API

This document covers the Company module APIs in ConnectWise Manage, which includes companies, contacts, configurations, and related objects.

## Base URL
All Company endpoints are relative to:
```
https://{server}/v4_6_release/apis/3.0/company
```

## Companies

Companies are the core of the Company module, representing customers, vendors, and prospects.

### Endpoints

#### Get Companies
```
GET /companies
GET /companies/{id}
GET /companies/count
GET /companies/search
```

**Parameters:**
- `id` (optional): The ID of a specific company to retrieve
- `conditions` (optional): Filter the results based on specific conditions
- `orderBy` (optional): Order the results by a specific field
- `page` (optional): Page number for paginated results
- `pageSize` (optional): Number of items per page
- `fields` (optional): Comma-separated list of fields to include in the response
- `childConditions` (optional): Filter child objects based on specific conditions
- `customFieldConditions` (optional): Filter custom fields based on specific conditions

**Example Request:**
```
GET /companies?conditions=status/name="Active" and types/id=1&orderBy=name asc
```

#### Create Company
```
POST /companies
```

**Example Request Body:**
```json
{
  "identifier": "XYZ",
  "name": "XYZ Corporation",
  "status": {
    "id": 1
  },
  "addressLine1": "123 Main St",
  "city": "Anytown",
  "state": "CA",
  "zip": "12345",
  "phoneNumber": "800-555-1234",
  "territory": {
    "id": 1
  },
  "market": {
    "id": 1
  }
}
```

#### Update Company
```
PATCH /companies/{id}
PUT /companies/{id}
```

#### Delete Company
```
DELETE /companies/{id}
```

### Company Types

#### Get Company Types
```
GET /companies/types
GET /companies/types/{id}
GET /companies/types/count
```

### Company Statuses

#### Get Company Statuses
```
GET /companies/statuses
GET /companies/statuses/{id}
GET /companies/statuses/count
```

### Company Type Associations

#### Get Company Type Associations
```
GET /companies/{id}/typeAssociations
GET /companies/{id}/typeAssociations/{typeId}
GET /companies/{id}/typeAssociations/count
```

#### Create Company Type Association
```
POST /companies/{id}/typeAssociations
```

#### Delete Company Type Association
```
DELETE /companies/{id}/typeAssociations/{typeId}
```

## For more detailed information, continue to:
- [Company Contacts](company_contacts.md)
- [Company Sites](company_sites.md)
- [Company Configurations](company_configurations.md)
