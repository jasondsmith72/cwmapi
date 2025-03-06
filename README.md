# ConnectWise Manage API Reference

This repository contains a comprehensive reference for the ConnectWise Manage REST API commands, endpoints, and usage examples.

## Overview

ConnectWise Manage provides a RESTful API that allows users to interact with their ConnectWise Manage instance programmatically. This reference aims to document all available endpoints, their parameters, and example usage.

## Structure

This repository is organized into the following sections:

- **[Authentication](authentication.md)**: Details on how to authenticate with the ConnectWise Manage API
- **[Core Concepts](core-concepts.md)**: Explains key concepts like pagination, filtering, and error handling
- **Module-specific endpoints**:
  - [Company](modules/company.md): Company-related endpoints
  - [Finance](modules/finance.md): Finance-related endpoints
  - [Marketing](modules/marketing.md): Marketing-related endpoints
  - [Procurement](modules/procurement.md): Procurement-related endpoints
  - [Project](modules/project.md): Project-related endpoints
  - [Sales](modules/sales.md): Sales-related endpoints
  - [Schedule](modules/schedule.md): Schedule-related endpoints
  - [Service](modules/service.md): Service-related endpoints (tickets, boards, etc.)
  - [System](modules/system.md): System-related endpoints
  - [Time](modules/time.md): Time-related endpoints

## API Base URL

The ConnectWise Manage API base URL follows this format:
```
https://{server}/v4_6_release/apis/3.0/
```

Where:
- `{server}` is your ConnectWise Manage server (e.g., `na.myconnectwise.net`)

## API Versioning

The ConnectWise Manage API supports versioning through an Accept header:
```
Accept: application/vnd.connectwise.com+json; version=2022.1
```

## Common Parameters

Most GET endpoints support the following query parameters:

- `conditions`: Filter the results based on specific conditions
- `orderBy`: Order the results by a specific field
- `page`: Page number for paginated results
- `pageSize`: Number of items per page
- `fields`: Comma-separated list of fields to include in the response
- `childConditions`: Filter child objects based on specific conditions
- `customFieldConditions`: Filter custom fields based on specific conditions

## Contributing

Feel free to contribute to this reference by submitting pull requests or opening issues for any missing or incorrect information.

## Resources

- [Official ConnectWise Developer Documentation](https://developer.connectwise.com/Products/Manage/REST)
- [ConnectWise API Client Creation](https://developer.connectwise.com/ClientID)
