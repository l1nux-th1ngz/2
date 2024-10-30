#!/bin/bash

# Install necessary packages
sudo apt-get update
sudo apt-get -y install xinit xorg xserver-xorg xbacklight xbindkeys xvkbd xinput
sudo apt-get -y install gcc make xcb libxcb-util0-dev libxcb-ewmh-dev build-essential intel-microcode
sudo apt-get -y install libxcb-randr0-dev libxcb-icccm4-dev libxcb-keysyms1-dev network-manager-gnome
sudo apt-get -y install libxcb-xinerama0-dev libxcb-ewmh2 curl wget aria2 network-manager gvfs udiskie udisks2
sudo apt-get -y install bspwm sxhkd
sudo apt-get -y install ranger kitty alacritty
sudo apt-get -y install xdg-user-dirs xdg-user-dirs-gtk
xdg-user-dirs-update
xdg-user-dirs-gtk-update
sudo apt-get -y install polybar rofi dunst nitrogen
sudo apt-get -y install i3lock cmus ranger policykit-1-gnome

# Configure bspwm
mkdir -p /home/$USER/.config/bspwm
sudo cp /usr/share/doc/bspwm/examples/bspwmrc /home/$USER/.config/bspwm/
chmod 774 /home/$USER/.config/bspwm/bspwmrc

# Configure sxhkd
mkdir -p /home/$USER/.config/sxhkd
touch /home/$USER/.config/sxhkd/sxhkdrc
chmod 774 /home/$USER/.config/sxhkd/sxhkdrc

# Configure Polybar
mkdir -p /home/$USER/.config/polybar
sudo cp /etc/polybar/config.ini /home/$USER/.config/polybar/

# Add to .xinitrc
echo "exec bspwm" >> /home/$USER/.xinitrc
echo "exec bspwm-session" >> /home/$USER/.xinitrc

# Configure bspwmrc
cat <<EOF >> /home/$USER/.config/bspwm/bspwmrc
sxhkd &
pgrep -x sxhkd > /dev/null || sxhkd &
picom --backend glx --vsync opengl-swc &
/usr/lib/gnome-polkit/gnome-polkit &
~/.config/polybar/polybar-launch.sh &
nitrogen --restore &
bspc config automatic_scheme longest_side
EOF

# Configure polybar-launch.sh
cat <<EOF > /home/$USER/.config/polybar/polybar-launch.sh
#!/usr/bin/env sh
# Terminate already running bar instances
killall -q polybar
# Wait until the processes have been shut down
while pgrep -x polybar >/dev/null; do sleep 1; done
# Launch Polybar
polybar &
EOF

chmod +x /home/$USER/.config/polybar/polybar-launch.sh

# Configure sxhkdrc
cat <<EOF > /home/$USER/.config/sxhkd/sxhkdrc
xsetroot -cursor_name left_ptr &
# change layout
alt + control + {1,2,3} ~/.config/bspwm/config_scheme.sh {first_child,longest_side,spiral}
# send the window to the given desktop
alt + shift + {1-9} bspc node -d '^{1-9}'
# close and kill
ctrl + alt + k bspc node -{c,k}
# preselect the direction
super + ctrl + {h,j,k,l} bspc node -p {west,south,north,east}
# spawn terminal
ctrl + Return kitty
# reload sxhkd configuration
alt + Escape pkill -USR1 -x sxhkd
# rofi
super + r rofi -show run
# quit/restart bspwm
ctrl + alt + {q,r} bspc {quit,wm -r}
EOF

# Install additional packages
sudo apt-get -y install pamixer lxappearance dialog mtools dosfstools acpi acpid gvfs-backends
sudo apt-get -y install pulseaudio pavucontrol pamixer feh fonts-recommended fonts-font-awesome fonts-terminus
sudo apt-get -y install papirus-icon-theme exa scrot dunst libnotify-bin xdotool unzip zip libnotify-dev
sudo apt-get -y install geany-plugins maim scrot inxi iw jq yad
sudo systemctl enable avahi-daemon
sudo systemctl enable acpid
sudo apt-get -y install firefox-esr fonts-firacode fonts-liberation2 fonts-ubuntu papirus-icon-theme fonts-cascadia-code
sudo apt-get -y install parcellite

# Install and configure LightDM
sudo apt-get install -y lightdm
sudo apt-get install -y lightdm-gtk-greeter
sudo apt-get install -y slick-greeter

# Download and install LightDM settings package
wget http://packages.linuxmint.com/pool/main/l/lightdm-settings/lightdm-settings_2.0.5_all.deb
sudo dpkg -i lightdm-settings_2.0.5_all.deb

# Configure LightDM
sudo dpkg-reconfigure lightdm

# Update LightDM configuration to set bspwm as the default session
sudo tee /etc/lightdm/lightdm.conf > /dev/null <<EOL
[Seat:*]
greeter-session=slick-greeter
user-session=bspwm
greeter-hide-users=false
greeter-allow-guest=true
EOL

# Enable and start LightDM
if sudo systemctl enable lightdm && sudo systemctl start lightdm; then
    echo "LightDM has been enabled and started successfully."
else
    echo "Failed to enable or start LightDM. Please check the output for errors."
    exit 1
fi

echo "Configuration complete! Please reboot to start using bspwm with LightDM."
