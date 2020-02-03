#!/bin/bash
pacman -S bash-completion

# Create user
useradd -m mesch
chown -R mesch:mesch /home/mesch

echo "Password"
passwd mesch

echo "mesch ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# Clone full repo
cd /tmp
git clone https://github.com/christianmesch/arch.git
chown -R mesch:mesch arch
chmod -R 777 arch
cd arch
pacman -Syu
pacman -Syy

# Yay
cd /tmp
git clone https://aur.archlinux.org/yay.git
chmod -R 777 yay
cd yay
runuser mesch -c 'makepkg -si'

# npm
pacman -S npm --noconfirm --needed

# Network
pacman -S wpa_supplicant wireless_tools networkmanager network-manager-applet
systemctl enable NetworkManager
systemctl enable wpa_supplicant.service

# Graphics
echo "Installing xorg display server"
pacman -S xorg-server xorg-apps xorg-xinit xorg-twm xterm --noconfirm --needed

echo "Opting for opensource nvidia drivers"
pacman -S xf86-video-nouveau --noconfirm --needed

# Copy wallpapers
mkdir -p /home/mesch/Pictures/wallpapers
cp -r configs/wallpapers /home/mesch/Pictures/wallpapers

# lightdm, display manager
pacman -S lightdm --noconfirm --needed
systemctl enable lightdm.service

runuser mesch -c 'yay -S lightdm-mini-greeter'

cp -r configs/lightdm/ /etc/lightdm/

# i3
pacman -S i3 --noconfirm --needed

mkdir -p /home/mesch/.config/i3
cp -r configs/i3/ /home/mesch/.config/i3/

# Polybar̈́
runuser -c mesch 'yay -S polybar-git'
install -Dm644 /usr/share/doc/polybar/config /home/mesch/.config/polybar/config
pacman -S ttf-font-awesome --noconfirm --needed

cp -r configs/polybar/ /home/mesch/.config/polybar/

# Betterlockscreen
runuser mesch -c 'yay -S betterlockscreen'
runuser mesch -c 'cp /usr/share/doc/betterlockscreen/examples/betterlockscreenrc /home/mesch/.config'
runuser mesch -c 'betterlockscreen -u /home/mesch/Pictures/wallpapers/cristofer-jeschke-VIqCeAwQ1rU-unsplash.jpg'

# Rofi
pacman -S rofi --noconfirm --needed

# IDE
runuser mesch -c 'yay -S visual-studio-code-bin'
runuser mesch -c 'yay -S intellij-idea-community-edition'

# Java
pacman -S jdk-openjdk

# Messaging
runuser mesch -c 'yay -S slack-desktop'

# Internet
pacman -S firefox

# Utilities
runuser mesch -c 'sudo npm install -g tldr'
pacman -S diff-so-fancy --noconfirm --needed
runuser mesch -c 'git config --global core.pager "diff-so-fancy | less --tabs=4 -RFX"'
pacman -S bat --noconfirm --needed
pacman -S ripgrep --noconfirm --needed
pacman -S fd --noconfirm --needed
pacman -S terminator --noconfirm --needed

echo "Installing bluetooth manager"
pacman -S blueberry --noconfirm --needed

# Fix sudoers
head -n -1 /etc/sudoers > /tmp/sudo ; mv /tmp/sudo /etc/sudoers
echo "mesch ALL=(ALL:ALL) ALL"  >> /etc/sudoers
