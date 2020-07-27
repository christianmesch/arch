#!/bin/bash
echo "Installing Arch Linux"

# Read user and hostname
read -p 'Username [mesch]: ' _user
read -p 'Hostname [soundwave]: ' _hostname

# Variables
_user=${_user:-mesch}
_hostname=${_hostname:-soundwave}
_home=/home/$_user
_home_config=$_home/.config
_install_root=/tmp/install-root
_install_dir=$_install_root/arch
_install_config=$_install_dir/configs
_accent_color=388E3C
_background_color=0c0c0c
_foreground_color=d0d0d0
_error_file=/tmp/installation-error.log
_bold=$(tput bold)
_normal=$(tput sgr0)
_green=$(tput setaf 2)
_red=$(tput setaf 1)

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

# Colors
readColorsFromXresources

# Pre
setTimeAndLocale
setHostname
installGrub

# Installers
installYay
installNpm

# Utilities
installNetworkUtils
installGraphics
installPicom
installTerminator
installZsh
installCLI
installOpenssh
installScrot
installBlueberry
installLight
installDunst
installLogitechUR
installVLC
installStreamlink
copyWallpapers
copyCustomScripts

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
installDocker
installYarn
installTypescript

# Internet
installFirefox

# Messaging
installSlack

# Setting user as owner on home folder again
chown -R $_user:$_user $_home

# Clean up installation files
removeInstallationFolder

echo "${_bold}Verifying installation$_normal"
test -e $_error_file && echo "${_red}Errors found!$_normal Read output at $_error_file" || echo "${_green}No errors$_normal"

# Fix sudoers
head -n -1 /etc/sudoers > /tmp/sudo ; mv /tmp/sudo /etc/sudoers
echo "$_user ALL=(ALL:ALL) ALL"  >> /etc/sudoers