# ConnectWise Manage API Authentication

ConnectWise Manage API offers multiple authentication methods. This document outlines the available options and how to implement them.

## Prerequisites

Before you can authenticate with the ConnectWise Manage API, you need:

1. A ConnectWise Manage account with API access
2. A ConnectWise Manage ClientID
3. Appropriate credentials based on your chosen authentication method

## Client ID Requirement

As of August 14, 2019, ConnectWise requires a Client ID for all API interactions. To obtain a Client ID:

1. Visit the [ConnectWise Developer Portal](https://developer.connectwise.com/ClientID)
2. Register your integration
3. Receive a Client ID that must be included in all API requests

Your Client ID should be included in the header of all requests:
```
ClientID: {your-client-id}
```

## Authentication Methods

### 1. API Key Authentication

This is the most common method for server-to-server integrations.

#### Requirements:
- Company ID
- Public Key
- Private Key

#### Implementation:
1. Create an API Member in ConnectWise Manage with appropriate roles/permissions
2. Generate API Keys for this member
3. Create a Base64 encoded string of `{CompanyId}+{PublicKey}:{PrivateKey}`
4. Add this to your Authorization header:

```
Authorization: Basic {base64-encoded-string}
```

#### Example (using PowerShell):
```powershell
$Company = "YourCompany"
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

# Example request
Invoke-RestMethod -Uri "https://yourserver.connectwise.com/v4_6_release/apis/3.0/system/info" -Headers $Headers
```

### 2. Member Impersonation

For applications that need to take actions on behalf of different members.

#### Requirements:
- API Keys (as above)
- Member ID to impersonate

#### Implementation:
1. First, authenticate using your API keys
2. Request a token for the member you want to impersonate
3. Use that token for subsequent requests

#### Example (using PowerShell):
```powershell
# First authenticate with API Keys
# Then request impersonation token
$MemberID = "MemberToImpersonate"

$ImpersonationRequest = @{
    memberIdentifier = $MemberID
} | ConvertTo-Json

$TokenResult = Invoke-RestMethod -Uri "https://yourserver.connectwise.com/v4_6_release/apis/3.0/system/members/$MemberID/tokens" -Method Post -Headers $Headers -Body $ImpersonationRequest

# Now create new auth header with impersonation token
$ImpersonationAuthString = "$Company+$($TokenResult.publicKey):$($TokenResult.privateKey)"
$EncodedImpersonationAuth = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes($ImpersonationAuthString))

$ImpersonationHeaders = @{
    'Authorization' = "Basic $EncodedImpersonationAuth"
    'ClientID' = $ClientID
    'Content-Type' = 'application/json'
}

# Make requests as the impersonated user
Invoke-RestMethod -Uri "https://yourserver.connectwise.com/v4_6_release/apis/3.0/system/info" -Headers $ImpersonationHeaders
```

### 3. Cookie Authentication (Legacy)

This method uses the same credentials used to log into the ConnectWise Manage web interface.

#### Requirements:
- Company ID
- Username
- Password

#### Implementation:
1. Make a login request to obtain session cookies
2. Use those cookies for subsequent requests

#### Example (using PowerShell):
```powershell
$Company = "YourCompany"
$Credentials = Get-Credential # Will prompt for username and password
$ClientID = "YourClientID"

$Body = @{
    CompanyName = $Company
    UserName = $Credentials.UserName
    Password = $Credentials.GetNetworkCredential().Password
}

# Create session with cookies
$LoginSession = New-Object Microsoft.PowerShell.Commands.WebRequestSession
$LoginResult = Invoke-RestMethod -Uri "https://yourserver.connectwise.com/v4_6_release/login/login.aspx?response=json" -Method Post -Body $Body -SessionVariable 'LoginSession'

# Add required cookies
$Cookie = New-Object System.Net.Cookie
$Cookie.Name = "companyName"
$Cookie.Value = $Company
$Cookie.Domain = "yourserver.connectwise.com"
$LoginSession.Cookies.Add($Cookie)

$Cookie = New-Object System.Net.Cookie
$Cookie.Name = "memberHash"
$Cookie.Value = $LoginResult.Hash
$Cookie.Domain = "yourserver.connectwise.com"
$LoginSession.Cookies.Add($Cookie)

# Use session for requests
Invoke-RestMethod -Uri "https://yourserver.connectwise.com/v4_6_release/apis/3.0/system/info" -WebSession $LoginSession -Headers @{ 'ClientID' = $ClientID }
```

## Best Practices

1. **Store credentials securely**: Never hardcode API keys in your application code
2. **Use the least privilege principle**: Only request the permissions your integration needs
3. **Implement token refresh**: Handle token expiration appropriately
4. **Use TLS**: Always use HTTPS for API requests

## Rate Limiting

ConnectWise Manage implements rate limiting on API requests. If you exceed the limits, you'll receive a 429 (Too Many Requests) response. Implement appropriate retry logic with exponential backoff.

## Troubleshooting

Common authentication issues:

1. **401 Unauthorized**: Check your credentials, especially the Base64 encoding
2. **403 Forbidden**: Your API member lacks the necessary permissions
3. **429 Too Many Requests**: You've exceeded rate limits, implement backoff logic
