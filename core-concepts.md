# ConnectWise Manage API Core Concepts

This document covers the fundamental concepts you need to understand when working with the ConnectWise Manage API.

## Request Format

All API requests to ConnectWise Manage should be formatted as standard REST calls using the appropriate HTTP methods:

- `GET`: Retrieve resources
- `POST`: Create new resources
- `PATCH`: Update existing resources
- `PUT`: Replace existing resources
- `DELETE`: Remove resources

## URL Structure

The ConnectWise Manage API follows this URL structure:

```
https://{server}/v4_6_release/apis/3.0/{resource-collection}/{id}
```

Example:
```
https://na.myconnectwise.net/v4_6_release/apis/3.0/service/tickets/12345
```

## Common Query Parameters

Most GET endpoints support these query parameters:

### Pagination

- `page`: Page number (1-based index)
- `pageSize`: Number of items per page (default varies by endpoint)

Example:
```
GET /service/tickets?page=2&pageSize=50
```

### Field Selection

- `fields`: Comma-separated list of fields to include in the response

Example:
```
GET /service/tickets?fields=id,summary,status
```

### Filtering

- `conditions`: Filter the results based on specific conditions
  
Example:
```
GET /service/tickets?conditions=status/name="New" and priority/name="High"
```

### Ordering

- `orderBy`: Order the results by a specific field (asc or desc)

Example:
```
GET /service/tickets?orderBy=dateEntered desc
```

### Child Objects

- `childConditions`: Filter child objects based on specific conditions
- `customFieldConditions`: Filter custom fields based on specific conditions

## Condition Operators

ConnectWise Manage API supports these operators in condition strings:

| Operator | Description | Example |
|----------|-------------|---------|
| `=` | Equal to | `status/name="New"` |
| `!=` | Not equal to | `status/name!="Closed"` |
| `>` | Greater than | `_info/dateEntered>"2023-01-01T00:00:00Z"` |
| `<` | Less than | `hours<5` |
| `>=` | Greater than or equal to | `priority/id>=3` |
| `<=` | Less than or equal to | `priority/id<=2` |
| `contains` | Contains string | `summary contains "error"` |
| `like` | Pattern match (use % as wildcard) | `summary like "server%"` |
| `in` | In a list of values | `status/name in ("New", "In Progress")` |
| `null` | Is null | `closedBy null` |
| `notnull` | Is not null | `closedDate notnull` |
| `and` | Logical AND | `status/name="New" and priority/name="High"` |
| `or` | Logical OR | `status/name="New" or status/name="In Progress"` |

## Response Format

Responses are returned in JSON format. Successful responses typically include:

- For individual resource requests: A JSON object representing the resource
- For collection requests: An array of JSON objects
- For count requests: A JSON object with a `count` property

## Error Handling

ConnectWise Manage API uses standard HTTP status codes to indicate success or failure:

- 2xx codes indicate success
- 4xx codes indicate client errors
- 5xx codes indicate server errors

Error responses include a JSON body with additional information:

```json
{
  "code": "NotFound",
  "message": "Ticket not found",
  "errors": []
}
```

Common error codes:

- `NotFound`: The requested resource does not exist
- `InvalidObject`: The request body contains invalid data
- `Unauthorized`: Authentication failed
- `Forbidden`: The authenticated user lacks necessary permissions
- `ConnectWiseApi`: General API error

## Pagination Handling

For endpoints that return large result sets, you should implement pagination:

1. Start with `page=1` and your desired `pageSize`
2. Continue requesting subsequent pages until you receive an empty array

Example (pseudo-code):
```
page = 1
pageSize = 100
allResults = []

do {
  results = fetchApi(`/service/tickets?page=${page}&pageSize=${pageSize}`)
  allResults.push(...results)
  page++
} while (results.length > 0)
```

## Rate Limiting

ConnectWise Manage implements rate limiting to prevent excessive API usage. The specific limits vary by deployment type.

If you exceed the rate limit, you'll receive a `429 Too Many Requests` response. Best practices:

1. Implement exponential backoff for retry logic
2. Spread requests over time when possible
3. Cache frequently accessed data

## Date/Time Handling

ConnectWise Manage API uses ISO 8601 format for dates and times:

```
YYYY-MM-DDThh:mm:ssZ
```

Example:
```
2023-01-15T14:30:00Z
```

When filtering by dates, use this format in your conditions:

```
conditions=dateEntered>"2023-01-01T00:00:00Z"
```

## Custom Fields

Custom fields are returned in a `customFields` array within resources. Each custom field has:

- `id`: The custom field ID
- `caption`: The display name
- `type`: The data type
- `value`: The field value

When updating custom fields, you need to include the entire array, even for fields you're not changing.

## Count Endpoints

Most collection endpoints support a `/count` suffix to get the total count without retrieving all records:

```
GET /service/tickets/count?conditions=status/name="New"
```

This returns:
```json
{
  "count": 42
}
```

## API Versions

ConnectWise Manage regularly updates their API. Specify the version you want to use in the Accept header:

```
Accept: application/vnd.connectwise.com+json; version=2022.1
```

If not specified, the latest version will be used, which may cause breaking changes in your integration.
