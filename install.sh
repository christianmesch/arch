#!/bin/bash
echo "Installing Arch Linux"

# Variables
_user=mesch
_home=/home/$_user
_home_config=$_home/.config
_install_root=/tmp/install-root
_install_dir=$_install_root/arch
_install_config=$_install_dir/configs
_accent_color=388E3C
_error_file=/tmp/installation-error.log

# Creating installation root folder
echo "Creating install root"
mkdir -p $_install_root

# Create user
echo "Creating user $_user"
useradd -m $_user
mkdir -p $_home_config
chown -R $_user:$_user $_home
passwd $_user

# Adding user to sudoers without password
echo "$_user ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# Clone full repo
echo "Cloning full repo"
cd $_install_root
git clone https://github.com/christianmesch/arch.git
chown -R $_user:$_user arch
chmod -R 777 arch
cd arch
pacman -Syu
pacman -Syy

# Load install functions
. ./functions.sh

# Installers
installYay
installNpm

# Utilities
installNetworkUtils
installGraphics
installTerminator
installCLI
installBlueberry
copyWallpapers

# GUI
installLightdm
installI3
installPolybar
installBetterLockscreen
installGTKTheme
installRofi

# Development
installIDEs
installOpenJDK

# Internet
installFirefox

# Messaging
installSlack

# Setting user as owner on home folder
chown -R $_user:$_user $_home

# Clean up installation files
removeInstallationFolder

test -e $_error_file && echo "Errors found" || echo "No errors"

# Fix sudoers
head -n -1 /etc/sudoers > /tmp/sudo ; mv /tmp/sudo /etc/sudoers
echo "$_user ALL=(ALL:ALL) ALL"  >> /etc/sudoers
