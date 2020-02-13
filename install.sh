#!/bin/bash
echo "Installing Arch Linux"

# Variables
_USER=mesch
_HOME=/home/${_USER}
_HOME_CONFIG=${_HOME}/.config
_INSTALL_ROOT=/tmp/install-root
_INSTALL_DIR=${_INSTALL_ROOT}/arch
_INSTALL_CONFIG=${_INSTALL_DIR}/configs
_ACCENT_COLOR=388E3C

# Creating installation root folder
echo "Creating install root"
mkdir -p ${_INSTALL_ROOT}

# Create user
echo "Creating user ${_USER}"
useradd -m ${_USER}
chown -R ${_USER}:${_USER} ${_HOME}
passwd ${_USER}

# Adding user to sudoers without password
echo "${_USER} ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# Clone full repo
echo "Cloning full repo"
cd ${_INSTALL_ROOT}
git clone https://github.com/christianmesch/arch.git
chown -R ${_USER}:${_USER} arch
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
installCLI
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

# Clean up installation files
echo "Removing installation files"
rm -rf ${_INSTALL_ROOT}

# Fix sudoers
head -n -1 /etc/sudoers > /tmp/sudo ; mv /tmp/sudo /etc/sudoers
echo "${_USER} ALL=(ALL:ALL) ALL"  >> /etc/sudoers