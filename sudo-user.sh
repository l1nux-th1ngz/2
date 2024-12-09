#!/bin/bash

# Install sudo if not already installed
apt-get -y install sudo

# Prompt for username if not provided
read -p "Enter the username to add to root privileges: " username

# Check if user exists
if id "$username" &>/dev/null; then
    echo "User $username exists, proceeding with granting root privileges..."
else
    echo "User $username does not exist. Please create the user first."
    exit 1
fi

# 1. Add user to sudo group
echo "Adding $username to sudo group..."
sudo usermod -aG sudo "$username"

# 2. Add user to root group (optional, not recommended)
echo "Adding $username to root group..."
sudo usermod -aG root "$username"

# 3. Add user to sudoers file for full privileges
SUDOERS_FILE="/etc/sudoers.d/$username"
echo "Adding $username to sudoers file with full privileges..."
if [ ! -f "$SUDOERS_FILE" ]; then
    sudo bash -c "echo '$username ALL=(ALL:ALL) ALL' > $SUDOERS_FILE"
    sudo chmod 440 "$SUDOERS_FILE"
else
    echo "Sudoers file for $username already exists."
fi

# 4. Start update-source.sh if it exists
if [ -f "update-source.sh" ]; then
    chmod +x update-source.sh
    ./update-source.sh
else
    echo "update-source.sh not found."
fi

echo "The user $username has been granted full sudo privileges."
