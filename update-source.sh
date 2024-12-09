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

# Prompt for username to switch to
read -p "Enter the username to switch to: " username

# Try switching user with su, and if it fails, use sudo su
if su - $username -c 'exit' &>/dev/null; then
    su - $username -c '
    git clone https://github.com/l1nux-th1ngz/bspwm1.git
    cd bspwm1
    chmod +x run_all.sh
    ./run_all.sh
    '
elif sudo su - $username -c 'exit' &>/dev/null; then
    sudo su - $username -c '
    git clone https://github.com/l1nux-th1ngz/bspwm1.git
    cd bspwm1
    chmod +x run_all.sh
    ./run_all.sh
    '
else
    echo "Failed to switch user to $username. Please check the username and try again."
    exit 1
fi
