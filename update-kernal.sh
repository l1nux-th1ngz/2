#!/bin/bash

# Repo Refresh
sudo apt update
echo "Installing Needed Packages"
sudo apt-get -y install bc 
sudo apt-get -y install bison
sudo apt-get -y install dh-make 
sudo apt-get -y install pbuilder
sudo apt-get -y install build-essential
sudo apt-get -y install fakeroot 
sudo apt-get -y install flex 
sudo apt-get -y install libelf-dev 
sudo apt-get -y install libncurses5-dev 
sudo apt-get -y install libssl-dev
sudo apt-get -y install autoconf
sudo apt-get -y install libparse-debcontrol-perl
sudo apt-get -y install automake
sudo apt-get -y install autopoint 
sudo apt-get -y install autotools-dev
sudo apt-get -y install debhelper
sudo apt-get -y install dh-autoreconf
sudo apt-get -y install dpkg-dev
sudo apt-get -y install devscripts
sudo apt-get -y install dh-strip-nondeterminism
sudo apt-get -y install dwz 
sudo apt-get -y install gettext
sudo apt-get -y install intltool-debian 
sudo apt-get -y install libarchive-zip-perl
sudo apt-get -y install libfl-dev
sudo apt-get -y install libdebhelper-perl
sudo apt-get -y install libfile-stripnondeterminism-perl
sudo apt-get -y install libsub-override-perl
sudo apt-get -y install libtool 
sudo apt-get -y install po-debconf
echo "Those are Done"

# Install kernel and firmware from bookworm-backports
sudo apt install -t bookworm-backports linux-image-amd64 linux-headers-amd64 firmware-linux
echo ""
# GRUB Update
sudo update-grub
echo "A system reboot is required to boot into your new kernel"

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

# Countdown and reboot
echo "System will reboot in 5 seconds..."
for i in {5..1}
do
    echo "$i"
    sleep 1
done
sudo reboot
