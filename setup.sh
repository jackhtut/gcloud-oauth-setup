#!/bin/bash

# 1. Config
UNIQUE_ID=$(date +%s)
PROJECT_ID="admob-dash-$UNIQUE_ID"
ORG_ID=$(gcloud organizations list --format="value(ID)" --limit=1)

echo "------------------------------------------------"
echo "🚀 STARTING ADMOB SETUP"
echo "------------------------------------------------"

# 2. Project Creation
if [ -n "$ORG_ID" ]; then
    echo "🏢 Creating Workspace Project..."
    gcloud projects create $PROJECT_ID --organization="$ORG_ID" --quiet
else
    echo "👤 Creating Personal Project..."
    gcloud projects create $PROJECT_ID --quiet
fi

gcloud config set project $PROJECT_ID

# 3. Enable AdMob API
echo "⚙️  Enabling AdMob API... (Wait about 30 seconds)"
gcloud services enable admob.googleapis.com --quiet

# 4. Teleport to the Finish Line
echo "------------------------------------------------"
echo "✅ CLOUD INFRASTRUCTURE READY"
echo "------------------------------------------------"
echo "Opening your browser to the final step..."

# This opens the OAuth Client Creation page directly
cloudshell launch-browser "https://console.cloud.google.com/apis/credentials/oauthclient?project=$PROJECT_ID"

echo ""
echo "IN THE NEW TAB:"
echo "1. If it asks to 'Configure Consent Screen', do that first (takes 10 seconds)."
echo "2. Select 'Web application'."
echo "3. Add http://localhost, http://localhost:3000 and http://localhost:8080 to 'Authorized JavaScript origins'."
echo "4. Click CREATE."