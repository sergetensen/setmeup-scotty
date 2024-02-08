#!/bin/bash

# This script will update ~/.ssh/authorized_keys. The starting point is that
# authentication is hardened by Fido2, hardware-key backed SSH-keys. 
# ToAdd:
# Check:
# - SSHD version
# - ~/.ssh folder

# Check version currently installed OpenSSH
sshd_versions=sshd -V 2>&1 | grep "OpenSSH" | awk '{print $1}'



# Define the URL of the authorized keys file
URL="http://example.com/authorized_keys"

# Define the path of the existing authorized keys file
AUTHORIZED_KEYS_FILE="$HOME/.ssh/authorized_keys"

# Define the path of the backup file
BACKUP_FILE="$HOME/.ssh/authorized_keys.backup"

# Check if the authorized keys file exists and has a size of 0 bytes
if [ ! -s "$AUTHORIZED_KEYS_FILE" ]; then
    echo "Creating new authorized keys file..."
    curl -s "$URL" -o "$AUTHORIZED_KEYS_FILE"
elif [ -f "$AUTHORIZED_KEYS_FILE" ]; then
    # Calculate the MD5 hash of the current authorized keys file
    CURRENT_MD5=$(md5sum "$AUTHORIZED_KEYS_FILE" | awk '{print $1}')

    # Download the authorized keys file and calculate its MD5 hash
    TEMP_FILE=$(mktemp)
    curl -s "$URL" -o "$TEMP_FILE"
    DOWNLOAD_MD5=$(md5sum "$TEMP_FILE" | awk '{print $1}')

    if [ "$DOWNLOAD_MD5" != "$CURRENT_MD5" ]; then
        echo "Updating authorized keys file..."
        cp "$AUTHORIZED_KEYS_FILE" "$BACKUP_FILE"
        mv "$TEMP_FILE" "$AUTHORIZED_KEYS_FILE"
        echo "Backup created: $BACKUP_FILE"
    else
        echo "No update required. The authorized keys file is already up to date."
        rm "$TEMP_FILE"
    fi
fi
