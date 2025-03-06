#
# ConnectWise Manage API Demo Script
# 
# This script demonstrates common operations with the ConnectWise Manage API
# using PowerShell. It includes authentication, retrieving data, creating 
# tickets, and working with time entries.
#

# ---------------------------------------------------------
# Configuration - Update these variables with your values
# ---------------------------------------------------------
$Server = "na.myconnectwise.net"   # Replace with your CW server
$Company = "yourcompany"           # Replace with your company ID
$PubKey = "YourPublicKey"          # Replace with your public key
$PrivateKey = "YourPrivateKey"     # Replace with your private key
$ClientID = "YourClientID"         # Replace with your client ID

# ---------------------------------------------------------
# Authentication Setup
# ---------------------------------------------------------
function Initialize-CWMConnection {
    param(
        [string]$Server,
        [string]$Company,
        [string]$PubKey,
        [string]$PrivateKey,
        [string]$ClientID
    )
    
    # Create authentication string and encode it
    $AuthString = "$($Company)+$($PubKey):$($PrivateKey)"
    $EncodedAuth = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes($AuthString))
    
    # Create headers for API requests
    $script:Headers = @{
        'Authorization' = "Basic $EncodedAuth"
        'ClientID' = $ClientID
        'Content-Type' = 'application/json'
        'Accept' = 'application/vnd.connectwise.com+json; version=2022.1'
    }
    
    # Base URL for API requests
    $script:BaseURL = "https://$Server/v4_6_release/apis/3.0"
    
    # Test connection by retrieving system info
    try {
        $infoUri = "$BaseURL/system/info"
        $systemInfo = Invoke-RestMethod -Uri $infoUri -Headers $Headers -Method Get
        Write-Host "Successfully connected to ConnectWise Manage" -ForegroundColor Green
        Write-Host "Version: $($systemInfo.version)" -ForegroundColor Green
        return $true
    }
    catch {
        Write-Host "Failed to connect to ConnectWise Manage" -ForegroundColor Red
        Write-Host "Error: $_" -ForegroundColor Red
        return $false
    }
}

# ---------------------------------------------------------
# Company Functions
# ---------------------------------------------------------
function Get-CWMCompanies {
    param(
        [string]$Condition = "",
        [int]$Limit = 25
    )
    
    $uri = "$BaseURL/company/companies"
    
    if ($Condition) {
        $encodedCondition = [System.Web.HttpUtility]::UrlEncode($Condition)
        $uri += "?conditions=$encodedCondition"
    }
    
    $uri += "&pageSize=$Limit"
    
    try {
        $companies = Invoke-RestMethod -Uri $uri -Headers $Headers -Method Get
        return $companies
    }
    catch {
        Write-Host "Error retrieving companies: $_" -ForegroundColor Red
        return $null
    }
}

function Get-CWMCompanyById {
    param(
        [Parameter(Mandatory = $true)]
        [int]$CompanyId
    )
    
    $uri = "$BaseURL/company/companies/$CompanyId"
    
    try {
        $company = Invoke-RestMethod -Uri $uri -Headers $Headers -Method Get
        return $company
    }
    catch {
        Write-Host "Error retrieving company $CompanyId: $_" -ForegroundColor Red
        return $null
    }
}

# ---------------------------------------------------------
# Ticket Functions
# ---------------------------------------------------------
function Get-CWMTickets {
    param(
        [string]$Condition = "",
        [int]$Limit = 25
    )
    
    $uri = "$BaseURL/service/tickets"
    
    if ($Condition) {
        $encodedCondition = [System.Web.HttpUtility]::UrlEncode($Condition)
        $uri += "?conditions=$encodedCondition"
    }
    
    $uri += "&pageSize=$Limit"
    
    try {
        $tickets = Invoke-RestMethod -Uri $uri -Headers $Headers -Method Get
        return $tickets
    }
    catch {
        Write-Host "Error retrieving tickets: $_" -ForegroundColor Red
        return $null
    }
}

function New-CWMTicket {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Summary,
        
        [Parameter(Mandatory = $true)]
        [int]$CompanyId,
        
        [Parameter(Mandatory = $true)]
        [int]$BoardId,
        
        [string]$Notes = "",
        
        [int]$ContactId = $null,
        
        [int]$SiteId = $null
    )
    
    $ticketBody = @{
        summary = $Summary
        company = @{
            id = $CompanyId
        }
        board = @{
            id = $BoardId
        }
        recordType = "ServiceTicket"
    }
    
    if ($Notes) {
        $ticketBody.initialDescription = $Notes
    }
    
    if ($ContactId) {
        $ticketBody.contact = @{
            id = $ContactId
        }
    }
    
    if ($SiteId) {
        $ticketBody.site = @{
            id = $SiteId
        }
    }
    
    $uri = "$BaseURL/service/tickets"
    
    try {
        $ticketJson = $ticketBody | ConvertTo-Json -Depth 10
        $newTicket = Invoke-RestMethod -Uri $uri -Headers $Headers -Method Post -Body $ticketJson
        Write-Host "Successfully created ticket #$($newTicket.id)" -ForegroundColor Green
        return $newTicket
    }
    catch {
        Write-Host "Error creating ticket: $_" -ForegroundColor Red
        return $null
    }
}

function Get-CWMTicketNotes {
    param(
        [Parameter(Mandatory = $true)]
        [int]$TicketId
    )
    
    $uri = "$BaseURL/service/tickets/$TicketId/notes"
    
    try {
        $notes = Invoke-RestMethod -Uri $uri -Headers $Headers -Method Get
        return $notes
    }
    catch {
        Write-Host "Error retrieving notes for ticket #$TicketId: $_" -ForegroundColor Red
        return $null
    }
}

function Add-CWMTicketNote {
    param(
        [Parameter(Mandatory = $true)]
        [int]$TicketId,
        
        [Parameter(Mandatory = $true)]
        [string]$NoteText,
        
        [bool]$Internal = $true,
        
        [bool]$DetailDescription = $false,
        
        [bool]$Resolution = $false
    )
    
    $noteBody = @{
        text = $NoteText
        internalFlag = $Internal
        detailDescriptionFlag = $DetailDescription
        resolutionFlag = $Resolution
    }
    
    $uri = "$BaseURL/service/tickets/$TicketId/notes"
    
    try {
        $noteJson = $noteBody | ConvertTo-Json
        $newNote = Invoke-RestMethod -Uri $uri -Headers $Headers -Method Post -Body $noteJson
        Write-Host "Successfully added note to ticket #$TicketId" -ForegroundColor Green
        return $newNote
    }
    catch {
        Write-Host "Error adding note to ticket #$TicketId: $_" -ForegroundColor Red
        return $null
    }
}

# ---------------------------------------------------------
# Time Entry Functions
# ---------------------------------------------------------
function Get-CWMTimeEntries {
    param(
        [string]$Condition = "",
        [int]$Limit = 25
    )
    
    $uri = "$BaseURL/time/entries"
    
    if ($Condition) {
        $encodedCondition = [System.Web.HttpUtility]::UrlEncode($Condition)
        $uri += "?conditions=$encodedCondition"
    }
    
    $uri += "&pageSize=$Limit"
    
    try {
        $timeEntries = Invoke-RestMethod -Uri $uri -Headers $Headers -Method Get
        return $timeEntries
    }
    catch {
        Write-Host "Error retrieving time entries: $_" -ForegroundColor Red
        return $null
    }
}

function New-CWMTimeEntry {
    param(
        [Parameter(Mandatory = $true)]
        [int]$CompanyId,
        
        [Parameter(Mandatory = $true)]
        [int]$ChargeToId,
        
        [Parameter(Mandatory = $true)]
        [ValidateSet("ServiceTicket", "ProjectTicket", "ChargeCode", "Activity")]
        [string]$ChargeToType,
        
        [Parameter(Mandatory = $true)]
        [int]$MemberId,
        
        [Parameter(Mandatory = $true)]
        [datetime]$TimeStart,
        
        [Parameter(Mandatory = $true)]
        [datetime]$TimeEnd,
        
        [Parameter(Mandatory = $true)]
        [double]$ActualHours,
        
        [Parameter(Mandatory = $true)]
        [int]$WorkTypeId,
        
        [Parameter(Mandatory = $true)]
        [int]$WorkRoleId,
        
        [string]$Notes = "",
        
        [ValidateSet("Billable", "DoNotBill", "NoCharge", "NoDefault")]
        [string]$BillableOption = "Billable"
    )
    
    $timeEntryBody = @{
        company = @{
            id = $CompanyId
        }
        chargeToId = $ChargeToId
        chargeToType = $ChargeToType
        member = @{
            id = $MemberId
        }
        timeStart = $TimeStart.ToString("o")
        timeEnd = $TimeEnd.ToString("o")
        actualHours = $ActualHours
        workType = @{
            id = $WorkTypeId
        }
        workRole = @{
            id = $WorkRoleId
        }
        billableOption = $BillableOption
    }
    
    if ($Notes) {
        $timeEntryBody.notes = $Notes
    }
    
    $uri = "$BaseURL/time/entries"
    
    try {
        $timeEntryJson = $timeEntryBody | ConvertTo-Json -Depth 10
        $newTimeEntry = Invoke-RestMethod -Uri $uri -Headers $Headers -Method Post -Body $timeEntryJson
        Write-Host "Successfully created time entry #$($newTimeEntry.id)" -ForegroundColor Green
        return $newTimeEntry
    }
    catch {
        Write-Host "Error creating time entry: $_" -ForegroundColor Red
        return $null
    }
}

# ---------------------------------------------------------
# Member Functions
# ---------------------------------------------------------
function Get-CWMMembers {
    param(
        [string]$Condition = "",
        [int]$Limit = 25
    )
    
    $uri = "$BaseURL/system/members"
    
    if ($Condition) {
        $encodedCondition = [System.Web.HttpUtility]::UrlEncode($Condition)
        $uri += "?conditions=$encodedCondition"
    }
    
    $uri += "&pageSize=$Limit"
    
    try {
        $members = Invoke-RestMethod -Uri $uri -Headers $Headers -Method Get
        return $members
    }
    catch {
        Write-Host "Error retrieving members: $_" -ForegroundColor Red
        return $null
    }
}

function Get-CWMMyInfo {
    $uri = "$BaseURL/system/myaccount"
    
    try {
        $myInfo = Invoke-RestMethod -Uri $uri -Headers $Headers -Method Get
        return $myInfo
    }
    catch {
        Write-Host "Error retrieving my account info: $_" -ForegroundColor Red
        return $null
    }
}

# ---------------------------------------------------------
# Main Demo Script
# ---------------------------------------------------------

# Add required assembly for URL encoding
Add-Type -AssemblyName System.Web

# Initialize connection
$connected = Initialize-CWMConnection -Server $Server -Company $Company -PubKey $PubKey -PrivateKey $PrivateKey -ClientID $ClientID

if ($connected) {
    # Demo 1: Get my info
    Write-Host "`n=== My Account Information ===" -ForegroundColor Cyan
    $myInfo = Get-CWMMyInfo
    Write-Host "ID: $($myInfo.id)"
    Write-Host "Name: $($myInfo.firstName) $($myInfo.lastName)"
    Write-Host "Email: $($myInfo.emailAddress)"
    
    # Demo 2: List recent companies
    Write-Host "`n=== Recent Companies ===" -ForegroundColor Cyan
    $companies = Get-CWMCompanies -Limit 5
    $companies | ForEach-Object {
        Write-Host "$($_.id): $($_.name)"
    }
    
    # Demo 3: List recent tickets
    Write-Host "`n=== Recent Tickets ===" -ForegroundColor Cyan
    $tickets = Get-CWMTickets -Condition "recordType='ServiceTicket'" -Limit 5
    $tickets | ForEach-Object {
        Write-Host "Ticket #$($_.id): $($_.summary) - Status: $($_.status.name)"
    }
    
    # Demo 4: List active members
    Write-Host "`n=== Active Members ===" -ForegroundColor Cyan
    $members = Get-CWMMembers -Condition "inactiveFlag=false" -Limit 5
    $members | ForEach-Object {
        Write-Host "$($_.id): $($_.firstName) $($_.lastName) ($($_.identifier))"
    }
    
    <#
    # Uncomment these sections to test creating tickets and time entries
    
    # Demo 5: Create a ticket
    Write-Host "`n=== Create a Test Ticket ===" -ForegroundColor Cyan
    $companyId = $companies[0].id  # Use the first company from earlier query
    $boardId = 1  # Replace with a valid board ID
    $ticket = New-CWMTicket -Summary "API Test Ticket" -CompanyId $companyId -BoardId $boardId -Notes "This is a test ticket created via the API."
    
    # Demo 6: Add a note to the ticket
    if ($ticket) {
        Write-Host "`n=== Add a Note to the Ticket ===" -ForegroundColor Cyan
        $note = Add-CWMTicketNote -TicketId $ticket.id -NoteText "This is a test note added via the API." -Internal $true
    }
    
    # Demo 7: Add a time entry to the ticket
    if ($ticket) {
        Write-Host "`n=== Add a Time Entry to the Ticket ===" -ForegroundColor Cyan
        $memberId = $myInfo.id
        $workTypeId = 1  # Replace with a valid work type ID
        $workRoleId = 1  # Replace with a valid work role ID
        
        $timeStart = (Get-Date).AddHours(-1)
        $timeEnd = Get-Date
        $hours = ($timeEnd - $timeStart).TotalHours
        
        $timeEntry = New-CWMTimeEntry -CompanyId $companyId -ChargeToId $ticket.id -ChargeToType "ServiceTicket" `
                                      -MemberId $memberId -TimeStart $timeStart -TimeEnd $timeEnd -ActualHours $hours `
                                      -WorkTypeId $workTypeId -WorkRoleId $workRoleId -Notes "Test time entry via API" -BillableOption "Billable"
    }
    #>
}
else {
    Write-Host "Script terminated due to connection failure." -ForegroundColor Red
}

Write-Host "`nConnectWise Manage API Demo Complete" -ForegroundColor Green
