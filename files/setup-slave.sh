#!/usr/bin/env bash

# This script template is expected to be populated during the setup of a
# jenkins slave node. It runs on host startup.

# Log everything we do.
set -x
exec > /var/log/user-data.log 2>&1

sudo yum update -y
sudo hostnamectl set-hostname ${hostname}

# persist hostname across reboots
LINE='preserve_hostname: true'
REPLACE_LINE='preserve_hostname: false'
FILE='/etc/cloud/cloud.cfg'

sudo grep -qF -- "$REPLACE_LINE" "$FILE" && sed -i.bak "s/$REPLACE_LINE/$LINE/g" "$FILE"
sudo grep -qF -- "$LINE" "$FILE" || echo "$LINE" >> "$FILE"

# Create devops user
sudo adduser devops
sudo -i -u devops bash << EOF
cd
mkdir .ssh
chmod 700 .ssh
touch .ssh/authorized_keys
chmod 600 .ssh/authorized_keys
echo "${devops_user_public_key}" >> .ssh/authorized_keys
EOF
sudo echo "devops ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
