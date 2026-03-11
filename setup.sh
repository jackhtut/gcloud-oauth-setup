#!/bin/bash

# 1. Config
UNIQUE_ID=$(date +%s)
PROJECT_ID="dolphin-app-$UNIQUE_ID"
ORG_ID=$(gcloud organizations list --format="value(ID)" --limit=1)

echo "------------------------------------------------"
echo "🚀 STARTING DOLPHIN SETUP"
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
echo "⚙️  Enabling AdMob API... (This will take around 30 seconds)"
gcloud services enable admob.googleapis.com --quiet

# 4. Teleport to the Finish Line
echo "------------------------------------------------"
echo "✅ CLOUD INFRASTRUCTURE READY"
echo "------------------------------------------------"

# This updates the tutorial side-panel to provide the user with the next steps
cat << EOF >> tutorial.md

## Step 2: Configure OAuth

Great job! Your project is ready. Now complete the final steps below. It should take only 1-2 minutes to fill the forms as instructed below

Click the link below to open the form page: <a href="https://console.cloud.google.com/apis/credentials/oauthclient?project=$PROJECT_ID" target="_blank">Open the form</a>

### What to do on that page:

**Part 1**
1. Click on **Get Started**
2. Enter app name (Dolphin App) and select your email
3. Choose **External** for Audience
4. Enter your email again
5. Agree to data policy
6. Click **Continue**
7. Click **Create**

**Part 2**
1. Click **Create OAuth client**
2. Application type: **Web application**.
3. Enter name (Dolphin App)
3. Under **Authorized JavaScript origins**, click **Add URI** and paste the following one by one:
   * \`http://localhost\`
   * \`http://localhost:3000\`
   * \`http://localhost:8080\`
4. Click **Create** at the bottom.
5. **COPY your Client ID** and paste it in the configs.txt
EOF

cloudshell launch-tutorial tutorial.md