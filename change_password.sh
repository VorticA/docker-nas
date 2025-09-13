#!/bin/bash

# The name of your storage container
CONTAINER_NAME="nas.samba"

echo "--> Checking if container '$CONTAINER_NAME' is running..."

# Check if the container is running
if [ ! "$(docker ps -q -f name=$CONTAINER_NAME)" ]; then
    echo "Error: Container '$CONTAINER_NAME' is not running."
    echo "Please start your services with 'docker-compose up -d' first."
    exit 1
fi

echo "--> Container found. Please set the new password for 'webadmin'."
echo "    (You will be prompted to enter and confirm the password)"
echo ""

# Execute the passwd command inside the container
# The -it flags are essential for the interactive password prompt
docker exec -it $CONTAINER_NAME passwd webadmin

echo ""
echo "--> Password for 'webadmin' has been set successfully!"
