#!/bin/bash

# 1. Configuration
UNIQUE_ID=$(date +%s)
PROJECT_ID="dolphin-app-$UNIQUE_ID"
USER_EMAIL=$(gcloud config get-value account)

echo "--- Starting Smart Dolphin Setup ---"
echo "Detected Account: $USER_EMAIL"

# 2. Create Project
gcloud projects create $PROJECT_ID --name="Dolphin Project $UNIQUE_ID"
gcloud config set project $PROJECT_ID

# 3. Enable APIs
echo "Enabling AdMob API... please wait."
gcloud services enable admob.googleapis.com --quiet

# 4. Intelligence Logic: Detect Account Type
if [[ "$USER_EMAIL" == *"@gmail.com" ]]; then
    # --- PERSONAL ACCOUNT FLOW ---
    echo "------------------------------------------------"
    echo "PERSONAL GMAIL ACCOUNT DETECTED"
    echo "Google requires you to manually confirm the Consent Screen."
    echo "------------------------------------------------"
    echo "1. Open this link: https://console.cloud.google.com/apis/credentials/consent?project=$PROJECT_ID"
    echo "2. Select 'EXTERNAL' and click 'CREATE'."
    echo "3. Fill in 'App Name' (anything) and your email for support/contact."
    echo "4. Click 'SAVE AND CONTINUE' through the next 3 screens."
    echo "------------------------------------------------"
    read -p "Press [Enter] once you have clicked 'Back to Dashboard'..."
else
    # --- WORKSPACE/ORG FLOW ---
    echo "Workspace account detected. Attempting automated branding..."
    # We use a subshell to catch errors if they aren't actually in an Org
    gcloud iap oauth-brands create --application_title="Dolphin App" --support_email="$USER_EMAIL" --quiet 2>/dev/null
fi

# 5. Create the Client ID
# We use 'default' as the brand name which works for most personal/new projects
echo "Finalizing OAuth Client ID..."
CLIENT_INFO=$(gcloud alpha iap oauth-clients create projects/$PROJECT_ID/brands/default --display_name="Dolphin-Client" 2>&1)

# 6. Save and Display
echo "------------------------------------------------" > credentials.txt
echo "DOLPHIN SETUP RESULTS" >> credentials.txt
echo "Project ID: $PROJECT_ID" >> credentials.txt
echo "" >> credentials.txt
echo "$CLIENT_INFO" >> credentials.txt
echo "------------------------------------------------" >> credentials.txt

# Open the file for the user automatically
cloudshell edit credentials.txt

echo "SUCCESS! Please see the credentials.txt file opened above."