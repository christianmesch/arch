#!/bin/bash

function run {
    _bold=$(tput bold)
    _normal=$(tput sgr0)
    _green=$(tput setaf 2)
    _red=$(tput setaf 1)
    _error=""
    _command=""

    echo "$_bold$1$_normal"
    for var in "${@:2}"; do
        IFS=' ' read -ra cmd <<< "$var"
        if [ ${cmd[0]} = "yay" ]; then
            _command="runuser -u $_user -- ${cmd[@]}"
        else
            _command="${cmd[@]}"
        fi

        printf "$_command"
        _error=$(exec $_command 2>&1 >/dev/null)
        if [ $? -eq 0 ]; then
            echo "  $_green SUCCESS$_normal"
        else
            echo "$_command
$_error
" >> $_error_file
            echo "  $_red FAIL$_normal"
            break
        fi
    done
}

function installYay {
    echo "Installing yay"
    cd $_install_root
    git clone --depth 1 https://aur.archlinux.org/yay.git
    chmod -R 777 yay
    cd yay
    run user -u $_user -- makepkg -si
    chown -R $_user:$_user $_home_config/yay
}

function installNpm {
    run "Installing npm" \
        "pacman -S npm --noconfirm --needed"
}

function installNetworkUtils {
    run "Installing network utilities" \
        "pacman -S wpa_supplicant wireless_tools networkmanager network-manager-applet --noconfirm --needed" \
        "systemctl enable NetworkManager" \
        "systemctl enable wpa_supplicant.service"
}

function installGraphics {
    run "Installing xorg display server" \
        "pacman -S xorg-server xorg-apps xorg-xinit xorg-twm --noconfirm --needed"

    run "Installing open source Nvidia drivers" \
        "pacman -S xf86-video-nouveau --noconfirm --needed"
}

function copyWallpapers {
    run "Copying wallpapers" \
        "mkdir -p $_home/Pictures/wallpapers" \
        "cp -r $_install_config/wallpaper/* $_home/Pictures/wallpapers"
}

function installLightdm {
    run "Installing LightDM" \
        "pacman -S lightdm --noconfirm --needed" \
        "systemctl enable lightdm.service"

    run "Configuring LightDM" \
        "yay -S lightdm-mini-greeter --noconfirm" \
        "cp -r $_install_config/lightdm/* /etc/lightdm/"
}

function installI3 {
    run "Installing i3 and feh" \
        "pacman -S i3 feh --noconfirm --needed"

    run "Configuring i3" \
        "mkdir -p $_home_config/i3" \
        "cp -r $_install_config/i3/* $_home_config/i3/"
}

function installPolybar {
    run "Installing Polybar" \
        "yay -S polybar-git --noconfirm" \
        "install -Dm644 /usr/share/doc/polybar/config $_home_config/polybar/config" \
        "pacman -S ttf-font-awesome --noconfirm --needed"

    run "Configuring Polybar" \
        "cp -r $_install_config/polybar/* $_home_config/polybar/"
}

function installBetterLockscreen {
    run "Removing i3lock in favor of BetterLockscreen" \
        "pacman -Rs i3lock --noconfirm"

    run "Installing BetterLockscreen" \
        "yay -S --noconfirm betterlockscreen"

    run "Configuring BetterLockscreen" \
        "cp /usr/share/doc/betterlockscreen/examples/betterlockscreenrc $_home_config" \
        "betterlockscreen -u $_home/Pictures/wallpapers/cristofer-jeschke-VIqCeAwQ1rU-unsplash.jpg"
}

function installGTKTheme {
    run "Installing and configuring GTK Theme (Materia Theme)" \
        "pacman -S gnome-themes-extra gtk3 gtk-engine-murrine sassc --noconfirm --needed"

    cd $_install_root

    run "Cloning Materia Theme" \
        "git clone --depth 1 https://github.com/nana-4/materia-theme"

    cd materia-theme

    run "Adding my accent color to theme" \
        "sed -i s/\(1A73E8\|8AB4F8\)/$_accent_color/gI src/_sass/_colors.scss" \
        "sed -i s/\(1A73E8\|8AB4F8\)/$_accent_color/gI src/_sass/_color-palette.scss" \
        "./parse-sass.sh" \
        "./install.sh"

    run "Configure GTK" \
        "mkdir -p $_home_config/gtk-3.0/" \
        "cp -r $_install_config/gtk3/* $_home_config/gtk-3.0/"
}

function installRofi {
    run "Installing Rofi" \
        "pacman -S rofi --noconfirm --needed"

    run "Configuring Rofi" \
        "mkdir $_home_config/rofi" \
        "cp -r $_install_config/rofi/* $_home_config/rofi" \
        "chmod +x $_home_config/rofi/scripts/*"
}

function installIDEs {
    run "Installing Visual Studio Code" \
        "yay -S --noconfirm visual-studio-code-bin"

    run "Installing Jetbrains Toolbox" \
        "yay -S --noconfirm jetbrains-toolbox"

    run "Creating workspace" \
        "mkdir $_home/dev" \
        "chown -R ${_user}:${_user} $_home/dev"
}

function installOpenJDK {
    run "Installing OpenJDK" \
        "pacman -S jdk-openjdk --noconfirm --needed"
}

function installFirefox {
    run "Installing Firefox" \
        "pacman -S firefox --noconfirm --needed"
}

function installSlack {
    run "Installing Slack" \
        "yay -S --noconfirm slack-desktop"
}

function installTerminator {
    run "Installing Terminator" \
        "pacman -S terminator --noconfirm --needed"

    run "Configuring Terminator" \
        "cp -r $_install_config/terminator $_home_config/"

}

function installCLI {
    run "Installing various CLIs" \
        "runuser -u ${_user} -- sudo npm install -g tldr" \
        "pacman -S diff-so-fancy --noconfirm --needed" \
        "pacman -S bat --noconfirm --needed" \
        "pacman -S ripgrep --noconfirm --needed" \
        "pacman -S fd --noconfirm --needed" \
        "pacman -S fzf --noconfirm --needed"

    run "Copying .bashrc" \
        "cp $_install_config/misc/.bashrc $_home"

    run "Copying .gitconfig" \
        "cp $_install_config/misc/.gitconfig $_home"
}

function installScrot {
    run "Installing scrot" \
        "pacman -S scrot --noconfirm --needed"

    run "Creating folder for screenshots" \
        "mkdir $_home/Pictures/scrot"
}

function installBlueberry {
    run "Installing Blueberry" \
        "pacman -S blueberry --noconfirm --needed"
}

function removeInstallationFolder {
    run "Removing installation files" \
        "rm -rf $_install_root"
}
