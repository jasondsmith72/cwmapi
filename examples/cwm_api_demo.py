#!/usr/bin/env python3
"""
ConnectWise Manage API Demo Script - Python Version

This script demonstrates common operations with the ConnectWise Manage API
using Python. It includes authentication, retrieving data, creating tickets,
and working with time entries.
"""

import requests
import json
import base64
import urllib.parse
from datetime import datetime, timedelta

# ---------------------------------------------------------
# Configuration - Update these variables with your values
# ---------------------------------------------------------
SERVER = "na.myconnectwise.net"    # Replace with your CW server
COMPANY = "yourcompany"            # Replace with your company ID
PUB_KEY = "YourPublicKey"          # Replace with your public key
PRIVATE_KEY = "YourPrivateKey"     # Replace with your private key
CLIENT_ID = "YourClientID"         # Replace with your client ID

# ---------------------------------------------------------
# Authentication Setup
# ---------------------------------------------------------
def initialize_connection():
    """Set up connection to ConnectWise Manage API"""
    
    # Create authentication string and encode it
    auth_string = f"{COMPANY}+{PUB_KEY}:{PRIVATE_KEY}"
    encoded_auth = base64.b64encode(auth_string.encode('utf-8')).decode('utf-8')
    
    # Create headers for API requests
    global HEADERS, BASE_URL
    HEADERS = {
        'Authorization': f"Basic {encoded_auth}",
        'ClientID': CLIENT_ID,
        'Content-Type': 'application/json',
        'Accept': 'application/vnd.connectwise.com+json; version=2022.1'
    }
    
    # Base URL for API requests
    BASE_URL = f"https://{SERVER}/v4_6_release/apis/3.0"
    
    # Test connection by retrieving system info
    try:
        info_url = f"{BASE_URL}/system/info"
        response = requests.get(info_url, headers=HEADERS)
        response.raise_for_status()  # Raise exception for 4XX/5XX responses
        system_info = response.json()
        print("\033[92mSuccessfully connected to ConnectWise Manage\033[0m")
        print(f"\033[92mVersion: {system_info.get('version')}\033[0m")
        return True
    except Exception as e:
        print(f"\033[91mFailed to connect to ConnectWise Manage\033[0m")
        print(f"\033[91mError: {str(e)}\033[0m")
        return False

# ---------------------------------------------------------
# Company Functions
# ---------------------------------------------------------
def get_companies(condition="", limit=25):
    """Retrieve companies from ConnectWise Manage"""
    
    url = f"{BASE_URL}/company/companies"
    
    params = {}
    if condition:
        params['conditions'] = condition
    
    params['pageSize'] = limit
    
    try:
        response = requests.get(url, headers=HEADERS, params=params)
        response.raise_for_status()
        return response.json()
    except Exception as e:
        print(f"\033[91mError retrieving companies: {str(e)}\033[0m")
        return None

def get_company_by_id(company_id):
    """Retrieve a specific company by ID"""
    
    url = f"{BASE_URL}/company/companies/{company_id}"
    
    try:
        response = requests.get(url, headers=HEADERS)
        response.raise_for_status()
        return response.json()
    except Exception as e:
        print(f"\033[91mError retrieving company {company_id}: {str(e)}\033[0m")
        return None

# ---------------------------------------------------------
# Ticket Functions
# ---------------------------------------------------------
def get_tickets(condition="", limit=25):
    """Retrieve tickets from ConnectWise Manage"""
    
    url = f"{BASE_URL}/service/tickets"
    
    params = {}
    if condition:
        params['conditions'] = condition
    
    params['pageSize'] = limit
    
    try:
        response = requests.get(url, headers=HEADERS, params=params)
        response.raise_for_status()
        return response.json()
    except Exception as e:
        print(f"\033[91mError retrieving tickets: {str(e)}\033[0m")
        return None

def create_ticket(summary, company_id, board_id, notes="", contact_id=None, site_id=None):
    """Create a new ticket in ConnectWise Manage"""
    
    ticket_data = {
        "summary": summary,
        "company": {
            "id": company_id
        },
        "board": {
            "id": board_id
        },
        "recordType": "ServiceTicket"
    }
    
    if notes:
        ticket_data["initialDescription"] = notes
    
    if contact_id:
        ticket_data["contact"] = {
            "id": contact_id
        }
    
    if site_id:
        ticket_data["site"] = {
            "id": site_id
        }
    
    url = f"{BASE_URL}/service/tickets"
    
    try:
        response = requests.post(url, headers=HEADERS, json=ticket_data)
        response.raise_for_status()
        new_ticket = response.json()
        print(f"\033[92mSuccessfully created ticket #{new_ticket.get('id')}\033[0m")
        return new_ticket
    except Exception as e:
        print(f"\033[91mError creating ticket: {str(e)}\033[0m")
        return None

def get_ticket_notes(ticket_id):
    """Retrieve notes for a specific ticket"""
    
    url = f"{BASE_URL}/service/tickets/{ticket_id}/notes"
    
    try:
        response = requests.get(url, headers=HEADERS)
        response.raise_for_status()
        return response.json()
    except Exception as e:
        print(f"\033[91mError retrieving notes for ticket #{ticket_id}: {str(e)}\033[0m")
        return None

def add_ticket_note(ticket_id, note_text, internal=True, detail_description=False, resolution=False):
    """Add a note to an existing ticket"""
    
    note_data = {
        "text": note_text,
        "internalFlag": internal,
        "detailDescriptionFlag": detail_description,
        "resolutionFlag": resolution
    }
    
    url = f"{BASE_URL}/service/tickets/{ticket_id}/notes"
    
    try:
        response = requests.post(url, headers=HEADERS, json=note_data)
        response.raise_for_status()
        new_note = response.json()
        print(f"\033[92mSuccessfully added note to ticket #{ticket_id}\033[0m")
        return new_note
    except Exception as e:
        print(f"\033[91mError adding note to ticket #{ticket_id}: {str(e)}\033[0m")
        return None

# ---------------------------------------------------------
# Time Entry Functions
# ---------------------------------------------------------
def get_time_entries(condition="", limit=25):
    """Retrieve time entries from ConnectWise Manage"""
    
    url = f"{BASE_URL}/time/entries"
    
    params = {}
    if condition:
        params['conditions'] = condition
    
    params['pageSize'] = limit
    
    try:
        response = requests.get(url, headers=HEADERS, params=params)
        response.raise_for_status()
        return response.json()
    except Exception as e:
        print(f"\033[91mError retrieving time entries: {str(e)}\033[0m")
        return None

def create_time_entry(company_id, charge_to_id, charge_to_type, member_id, 
                    time_start, time_end, actual_hours, work_type_id, 
                    work_role_id, notes="", billable_option="Billable"):
    """Create a new time entry in ConnectWise Manage"""
    
    # Ensure time_start and time_end are in ISO format
    if isinstance(time_start, datetime):
        time_start = time_start.isoformat()
    
    if isinstance(time_end, datetime):
        time_end = time_end.isoformat()
    
    time_entry_data = {
        "company": {
            "id": company_id
        },
        "chargeToId": charge_to_id,
        "chargeToType": charge_to_type,
        "member": {
            "id": member_id
        },
        "timeStart": time_start,
        "timeEnd": time_end,
        "actualHours": actual_hours,
        "workType": {
            "id": work_type_id
        },
        "workRole": {
            "id": work_role_id
        },
        "billableOption": billable_option
    }
    
    if notes:
        time_entry_data["notes"] = notes
    
    url = f"{BASE_URL}/time/entries"
    
    try:
        response = requests.post(url, headers=HEADERS, json=time_entry_data)
        response.raise_for_status()
        new_time_entry = response.json()
        print(f"\033[92mSuccessfully created time entry #{new_time_entry.get('id')}\033[0m")
        return new_time_entry
    except Exception as e:
        print(f"\033[91mError creating time entry: {str(e)}\033[0m")
        return None

# ---------------------------------------------------------
# Member Functions
# ---------------------------------------------------------
def get_members(condition="", limit=25):
    """Retrieve members from ConnectWise Manage"""
    
    url = f"{BASE_URL}/system/members"
    
    params = {}
    if condition:
        params['conditions'] = condition
    
    params['pageSize'] = limit
    
    try:
        response = requests.get(url, headers=HEADERS, params=params)
        response.raise_for_status()
        return response.json()
    except Exception as e:
        print(f"\033[91mError retrieving members: {str(e)}\033[0m")
        return None

def get_my_info():
    """Retrieve information about the authenticated user"""
    
    url = f"{BASE_URL}/system/myaccount"
    
    try:
        response = requests.get(url, headers=HEADERS)
        response.raise_for_status()
        return response.json()
    except Exception as e:
        print(f"\033[91mError retrieving my account info: {str(e)}\033[0m")
        return None

# ---------------------------------------------------------
# Main Demo Script
# ---------------------------------------------------------
def main():
    """Main function to run the demo"""
    
    # Initialize connection
    connected = initialize_connection()
    
    if not connected:
        print("Script terminated due to connection failure.")
        return
    
    # Demo 1: Get my info
    print("\n\033[96m=== My Account Information ===\033[0m")
    my_info = get_my_info()
    if my_info:
        print(f"ID: {my_info.get('id')}")
        print(f"Name: {my_info.get('firstName')} {my_info.get('lastName')}")
        print(f"Email: {my_info.get('emailAddress')}")
    
    # Demo 2: List recent companies
    print("\n\033[96m=== Recent Companies ===\033[0m")
    companies = get_companies(limit=5)
    if companies:
        for company in companies:
            print(f"{company.get('id')}: {company.get('name')}")
    
    # Demo 3: List recent tickets
    print("\n\033[96m=== Recent Tickets ===\033[0m")
    tickets = get_tickets(condition="recordType='ServiceTicket'", limit=5)
    if tickets:
        for ticket in tickets:
            print(f"Ticket #{ticket.get('id')}: {ticket.get('summary')} - Status: {ticket.get('status', {}).get('name')}")
    
    # Demo 4: List active members
    print("\n\033[96m=== Active Members ===\033[0m")
    members = get_members(condition="inactiveFlag=false", limit=5)
    if members:
        for member in members:
            print(f"{member.get('id')}: {member.get('firstName')} {member.get('lastName')} ({member.get('identifier')})")
    
    """
    # Uncomment these sections to test creating tickets and time entries
    
    # Demo 5: Create a ticket
    print("\n\033[96m=== Create a Test Ticket ===\033[0m")
    if companies:
        company_id = companies[0].get('id')  # Use the first company from earlier query
        board_id = 1  # Replace with a valid board ID
        ticket = create_ticket(
            summary="API Test Ticket", 
            company_id=company_id, 
            board_id=board_id, 
            notes="This is a test ticket created via the API."
        )
        
        # Demo 6: Add a note to the ticket
        if ticket:
            print("\n\033[96m=== Add a Note to the Ticket ===\033[0m")
            note = add_ticket_note(
                ticket_id=ticket.get('id'),
                note_text="This is a test note added via the API.",
                internal=True
            )
        
        # Demo 7: Add a time entry to the ticket
        if ticket and my_info:
            print("\n\033[96m=== Add a Time Entry to the Ticket ===\033[0m")
            member_id = my_info.get('id')
            work_type_id = 1  # Replace with a valid work type ID
            work_role_id = 1  # Replace with a valid work role ID
            
            time_start = datetime.now() - timedelta(hours=1)
            time_end = datetime.now()
            hours = (time_end - time_start).total_seconds() / 3600
            
            time_entry = create_time_entry(
                company_id=company_id,
                charge_to_id=ticket.get('id'),
                charge_to_type="ServiceTicket",
                member_id=member_id,
                time_start=time_start,
                time_end=time_end,
                actual_hours=hours,
                work_type_id=work_type_id,
                work_role_id=work_role_id,
                notes="Test time entry via API",
                billable_option="Billable"
            )
    """
    
    print("\n\033[92mConnectWise Manage API Demo Complete\033[0m")

if __name__ == "__main__":
    main()
