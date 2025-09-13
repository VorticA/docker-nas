#!/bin/bash

# A script to configure and generate the docker-compose.yml from the template.

echo "🚀 Welcome to the Docker NAS Setup Script!"
echo "-------------------------------------------"
echo "This script will guide you through creating your docker-compose.yml file."
echo ""

# --- Dependency Check ---
echo "--> Checking for dependencies (Docker and Docker Compose)..."
if ! command -v docker &> /dev/null; then
    echo "❌ Error: Docker is not installed. Please install it before proceeding."
    exit 1
fi
if ! command -v docker compose &> /dev/null; then
    echo "❌ Error: Docker Compose is not installed. Please install it before proceeding."
    exit 1
fi
echo "✅ Dependencies found."
echo ""


# --- Check for template file ---
if [ ! -f "docker-compose.yml.tpl" ]; then
    echo "❌ Error: 'docker-compose.yml.tpl' not found."
    echo "   Please run this script from the same directory as the template file."
    exit 1
fi

# --- Gather User Input ---
echo "--> Please provide the following configuration details:"
echo ""

read -p "Enter your server URL for WireGuard (e.g., mynas.duckdns.org): " SRV_URL
read -p "Enter your DuckDNS subdomain(s) (e.g., mynas): " SUBDOMAINS
read -sp "Enter your DuckDNS token (input will be hidden): " DUCKDNS_TOKEN
echo ""
read -p "Enter the internal container path for your share [default: /shared]: " SHARE_PATH
# Use default if input is empty
SHARE_PATH=${SHARE_PATH:-/shared}

echo ""
echo "--> Generating docker-compose.yml from template..."

# --- Generate docker-compose.yml using sed ---
# We use '|' as a separator for sed to avoid issues with URLs containing '/'
sed -e "s|{\$SRV_URL}|${SRV_URL}|g" \
    -e "s|{\$SUBDOMAINS}|${SUBDOMAINS}|g" \
    -e "s|TOKEN=|TOKEN=${DUCKDNS_TOKEN}|g" \
    -e "s|{\$SHARE}|${SHARE_PATH}|g" \
    docker-compose.yml.tpl > docker-compose.yml

if [ $? -eq 0 ]; then
    echo "✅ Successfully created 'docker-compose.yml'!"
else
    echo "❌ Error: Failed to create 'docker-compose.yml'."
    exit 1
fi

echo ""
echo "-------------------------------------------"
echo "🎉 Setup is complete! What's next?"
echo ""
echo "1. Create the shared directory on your host machine:"
echo "   mkdir -p ~/docker-nas/shared"
echo ""
echo "2. Build and start your NAS services:"
echo "   docker-compose up -d --build"
echo ""
echo "3. Set the password for the 'webadmin' user:"
echo "   bash ./change_password.sh"
echo ""
