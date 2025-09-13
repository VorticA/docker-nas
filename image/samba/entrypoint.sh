#!/bin/bash

# This script simply starts the necessary services.
# User and permission management should be handled by Webmin or docker exec.

echo "Starting Webmin service..."
/etc/init.d/webmin start

echo "Starting Samba service in foreground..."
# Use the -F flag to keep the container running
/usr/sbin/smbd --foreground --no-process-group
