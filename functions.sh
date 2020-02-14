#!/bin/bash

function installYay {
    echo "Installing yay"
    cd ${_INSTALL_ROOT}
    git clone --depth 1 https://aur.archlinux.org/yay.git
    chmod -R 777 yay
    cd yay
    runuser ${_USER} -c 'makepkg -si'
}

function installNpm {
    echo "Installing npm"
    pacman -S npm --noconfirm --needed
}

function installNetworkUtils {
    echo "Installing network utilities"
    pacman -S wpa_supplicant wireless_tools networkmanager network-manager-applet --noconfirm --needed
    systemctl enable NetworkManager
    systemctl enable wpa_supplicant.service
}

function installGraphics {
    echo "Installing xorg display server"
    pacman -S xorg-server xorg-apps xorg-xinit xorg-twm --noconfirm --needed
    echo "Opting for opensource nvidia drivers"
    pacman -S xf86-video-nouveau --noconfirm --needed
}

function copyWallpapers {
    echo "Copying wallpapers"
    mkdir -p ${_HOME}/Pictures/wallpapers
    cp -r ${_INSTALL_CONFIG}/wallpaper/* ${_HOME}/Pictures/wallpapers    
}

function installLightdm {
    echo "Installing LightDM"
    pacman -S lightdm --noconfirm --needed
    systemctl enable lightdm.service

    echo "Configuring LightDM"
    runuser ${_USER} -c 'yay -S --noconfirm lightdm-mini-greeter'
    cp -r ${_INSTALL_CONFIG}/lightdm/* /etc/lightdm/
}

function installI3 {
    echo "Installing i3 and feh"
    pacman -S i3 feh --noconfirm --needed

    echo "Configuring i3"
    mkdir -p ${_HOME_CONFIG}/i3
    cp -r ${_INSTALL_CONFIG}/i3/* ${_HOME_CONFIG}/i3/
}

function installPolybar {
    echo "Installing Polybar"
    runuser ${_USER} -c 'yay -S --noconfirm polybar-git'
    install -Dm644 /usr/share/doc/polybar/config ${_HOME_CONFIG}/polybar/config
    pacman -S ttf-font-awesome --noconfirm --needed

    echo "Configuring Polybar"
    cp -r ${_INSTALL_CONFIG}/polybar/* ${_HOME_CONFIG}/polybar/
}

function installBetterLockscreen {
    echo "Removing i3lock in favor of BetterLockscreen"
    pacman -Rs i3lock --noconfirm
    echo "Installing BetterLockscreen"
    runuser ${_USER} -c 'yay -S --noconfirm betterlockscreen'

    echo "Configuring BetterLockscreen"
    runuser ${_USER} -c "cp /usr/share/doc/betterlockscreen/examples/betterlockscreenrc ${_HOME_CONFIG}"
    runuser ${_USER} -c "betterlockscreen -u ${_HOME}/Pictures/wallpapers/cristofer-jeschke-VIqCeAwQ1rU-unsplash.jpg"
}

function installGTKTheme {
    echo "Installing and configuring GTK Theme (Materia Theme)"
    pacman -S gnome-themes-extra gtk3 gtk-engine-murrine sassc --noconfirm --needed
    cd ${_INSTALL_ROOT}
    git clone --depth 1 https://github.com/nana-4/materia-theme
    cd materia-theme
    
    echo "Adding my own accent color to theme (#${_ACCENT_COLOR})"
    sed -i "s/\(1A73E8\|8AB4F8\)/${_ACCENT_COLOR}/gI" src/_sass/_colors.scss
    sed -i "s/\(1A73E8\|8AB4F8\)/${_ACCENT_COLOR}/gI" src/_sass/_color-palette.scss
    ./parse-sass.sh
    ./install.sh

    mkdir -p ${_HOME_CONFIG}/gtk-3.0/
    cp -r ${_INSTALL_CONFIG}/gtk3/* ${_HOME_CONFIG}/gtk-3.0/
}

function installRofi {
    echo "Installing Rofi"
    pacman -S rofi --noconfirm --needed

    echo "Installing needed icons for Rofi menus"
    runuser ${_USER} -c 'yay -S --noconfirm nerd-fonts-complete'
    runuser ${_USER} -c 'yay -S --noconfirm paper-icon-theme-git'

    echo "Configuring Rofi"
    cd ${_INSTALL_ROOT}
    runuser ${_USER} -c 'git clone --depth 1 https://gitlab.com/vahnrr/rofi-menus.git'
    cd rofi-menus
    chmod +x scripts/*
    mkdir -p ${_HOME_CONFIG}/rofi
    cp -r scripts themes config.rasi ${_HOME_CONFIG}/rofi
    cp -r networkmanager-dmenu ${_HOME_CONFIG}

    echo "Adding my own accent color to theme (#${_ACCENT_COLOR})"
    cd ${_HOME_CONFIG}/rofi/themes/shared/colorschemes
    cp dark-amber.rasi dark-accent.rasi
    sed -i "s/ffbf00/${_ACCENT_COLOR}/gI" ${_HOME_CONFIG}/rofi/themes/shared/colorschemes/dark-accent.rasi
    sed -i "s/dark-steel-blue/dark-accent/gI" ${_HOME_CONFIG}/rofi/themes/shared/settings.rasi
}

function installIDEs {
    echo "Installing Visual Studio Code"
    runuser ${_USER} -c 'yay -S --noconfirm visual-studio-code-bin'

    echo "Installing Jetbrains Toolbox"
    runuser ${_USER} -c 'yay -S --noconfirm jetbrains-toolbox'

    echo "Creating workspace"
    runuser ${_USER} -c "mkdir ${_HOME}/dev"
}

function installOpenJDK {
    echo "Installing OpenJDK"
    pacman -S jdk-openjdk --noconfirm --needed
}

function installFirefox {
    echo "Installing Firefox"
    pacman -S firefox --noconfirm --needed
}

function installSlack {
    echo "Installing Slack"
    runuser ${_USER} -c 'yay -S --noconfirm slack-desktop'
}

function installCLI {
    echo "Installing Terminator"
    pacman -S terminator --noconfirm --needed

    echo "Installing various CLIs"
    runuser ${_USER} -c 'sudo npm install -g tldr'
    pacman -S diff-so-fancy --noconfirm --needed
    runuser ${_USER} -c 'git config --global core.pager "diff-so-fancy | less --tabs=4 -RFX"'
    pacman -S bat --noconfirm --needed
    pacman -S ripgrep --noconfirm --needed
    pacman -S fd --noconfirm --needed

    echo "Copying .bashrc"
    cp ${_INSTALL_CONFIG}/misc/.bashrc ${_HOME}
}
