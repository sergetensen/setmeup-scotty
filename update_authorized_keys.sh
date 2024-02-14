#!/bin/bash

# The goal of this script is to add Fido2, hardware backed, ssh public key(s) 
# to ~/.ssh/authorized_keys of your user. These keys are supported by OpenSSH
# version 8.2 and up.

# Workflow:
# - Assume OpenSSH 8.2 or higher is present on the system and notify this.
# - Is ~/.ssh present?
#    - No: Create, Continue.
# - Has ~/.ssh the correct ownership?
#        - No: Modify, Continue.
# - Has ~/.ssh a permission of 700?
#     - No: Modify, Continue.
# - Download authorized_keys from the git repo to a temp folder.
# - Is ~/.ssh/authorized_keys present?
#     - No: Copy downloaded version ti ~/.ssh and finish
#   - If it is: check if it is empty. If so, append the content of the downloaded version and finish.
#   - If it is not: check if it has the same content as the downloaded version. If so finisch.
#   - If not: append content of the downloaded version.

 
# Check version currently installed OpenSSH. The method below seems to work
# on most UNIX-like systems. OpenSSH has the -V option on sshd since 
#SSHD_MINVER="OpenSSH_8.2"
#SSHD_ACTVER=$(sshd -V 2>&1 | grep "OpenSSH" | awk '{print $1}')

clear
echo "This script assumes that OpenSSH 8.2 or up is installed. If not, ^C, update and re-run."
sleep 1
echo "Checking ~/.ssh and ~/.ssh/authorized_keys..."

SSH_DIR="~/.ssh"
if [ ! -d $SSH_DIR ]; then
    echo $SSH_DIR" does not exist. Creating it..."
    sleep 1
    mkdir $SSH_DIR
 fi
chmod 700 $SSH_DIR # Making sure the security of this directory is right.

# Define the variables used for handling the authorized keys file
URL="http://example.com/authorized_keys"
AUTHORIZED_KEYS_FILE="$HOME/.ssh/authorized_keys"
BACKUP_FILE="$AUTHORIZED_KEYS_FILE.backup"

# Download the authorized keys file to a temporary created directory
TEMP_FILE="$(mktemp)/authorized_keys.tmp"
curl -s -o "$TEMP_FILE" "$URL"

# Check if the authorized keys file exists and has a size of 0 bytes
if [ ! -s "$AUTHORIZED_KEYS_FILE" ]; then
    echo "Creating new authorized keys file..."
    cp $TEMP_FILE $AUTHORIZED_KEYS_FILE
    chown $USER:$USER $AUTHORIZED_KEYS_FILE
    chmod 600 $AUTHORIZED_KEYS_FILE
    echo "Newly created $AUTHORIZES_KEYS_FILE. Exiting..."
    exit 0
elif [ -f "$AUTHORIZED_KEYS_FILE" ]; then
    # Calculate the MD5 hash of the current authorized keys file
    CURRENT_MD5=$(md5sum "$AUTHORIZED_KEYS_FILE" | awk '{print $1}')
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
