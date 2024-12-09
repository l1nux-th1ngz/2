#!/bin/bash  

# Install necessary keyring
sudo apt-get -y install fasttrack-archive-keyring

# Update package lists
sudo apt-get update

# Update sources.list with the new repositories to make them available systemwide
sudo bash -c 'cat <<EOF > /etc/apt/sources.list
deb https://fasttrack.debian.net/debian-fasttrack/ bookworm-fasttrack main contrib non-free
deb https://ftp.debian.org/debian/ bookworm contrib main non-free non-free-firmware
deb https://ftp.debian.org/debian/ bookworm-updates contrib main non-free non-free-firmware
deb https://ftp.debian.org/debian/ bookworm-proposed-updates contrib main non-free non-free-firmware
deb https://ftp.debian.org/debian/ bookworm-backports contrib main non-free non-free-firmware
deb https://security.debian.org/debian-security/ bookworm-security contrib main non-free non-free-firmware
EOF'

# Update package lists with the new sources
sudo apt-get update

# Upgrade all packages
sudo apt-get upgrade -y

# Start update-kernel.sh if it exists
if [ -f "update-kernel.sh" ]; then
    chmod +x update-kernel.sh
    ./update-kernel.sh
else
    echo "update-kernel.sh not found."
fi
