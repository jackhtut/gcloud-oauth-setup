#!/bin/bash

# 1. Generate a random project ID so they don't have to type one
UNIQUE_ID=$(date +%s)
PROJECT_ID="dolphin-project-$UNIQUE_ID"

echo "Step 1: Creating your Google Cloud Project..."
gcloud projects create $PROJECT_ID --name="Dolphin Project"
gcloud config set project $PROJECT_ID

echo "Step 2: Enabling AdMob APIs (this takes about 30-60 seconds)..."
gcloud services enable admob.googleapis.com --quiet

echo "Step 3: Creating OAuth Credentials..."
# Creates the 'Brand' (Consent Screen) automatically using their login email
USER_EMAIL=$(gcloud config get-value account)
gcloud iap oauth-brands create --application_title="Dolphin App" --support_email="$USER_EMAIL"

# Creates the Client ID
CLIENT_INFO=$(gcloud iap oauth-clients create projects/$PROJECT_ID/brands/$(gcloud iap oauth-brands list --format="value(name)" | head -n 1) --display_name="Client-$UNIQUE_ID")

echo "------------------------------------------------"
echo "DONE! I am saving your credentials to a file..."
echo "$CLIENT_INFO" > credentials.txt

# OPTIONAL: Automatically open the file for them so they see it
cloudshell edit credentials.txt
echo "The setup is finished. You can close this window."
------------------------------------------------