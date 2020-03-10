#!/bin/bash

function run {
    _error=""
    _command=""

    echo "$_bold$1$_normal"
    for var in "${@:2}"; do
        IFS=' ' read -ra cmd <<< "$var"
        if [[ ${cmd[0]} == "yay" ]]; then
            _command="runuser -u $_user -- ${cmd[@]}"
        else
            _command="${cmd[@]}"
        fi

        printf "%-100s | " "${_command::100}"
        _error=$(exec $_command 2>&1 >/dev/null)
        if [ $? -eq 0 ]; then
            echo "${_green}SUCCESS$_normal"
        else
            echo "$_command
$_error
" >> $_error_file
            echo "${_red}FAIL$_normal"
            break
        fi
    done
}

function installYay {    
    cd $_install_root
    
    run "Cloning yay repo" \
        "git clone --depth 1 https://aur.archlinux.org/yay.git" \
        "chmod -R 777 yay"

    cd yay

    run "Installing yay" \
        "runuser -u $_user -- makepkg -si --noconfirm --needed"
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

    run "Copying .Xkbmap" \
        "cp $_install_config/misc/.Xkbmap $_home"

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
        "cp /usr/share/doc/betterlockscreen/examples/betterlockscreenrc $_home_config"
}

function installGTKTheme {
    run "Installing and configuring GTK Theme (Materia Theme)" \
        "pacman -S gnome-themes-extra gtk3 gtk-engine-murrine sassc --noconfirm --needed"

    cd $_install_root

    run "Cloning Materia Theme" \
        "git clone --depth 1 https://github.com/nana-4/materia-theme"

    cd materia-theme

    run "Installing needed dependencies for generating theme" \
        "pacman -S inkscape optipng --noconfirm --needed"

    echo "${_bold}Addig my colors to materia theme$_normal"

    ./change_color.sh -o materia-dark-compact-custom <(echo -e "ROUNDNESS=0\nBG=0c0c0c\nFG=eeeeee\nHDR_BG=0c0c0c\nHDR_FG=e0e0e0\nSEL_BG=$_accent_color\nMATERIA_VIEW=303030\nMATERIA_SURFACE=424242\nMATERIA_STYLE_COMPACT=True\n") 1>/dev/null

    run "Move generated theme to user folder" \
        "mv /root/.themes/ $_home"

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

function installDocker {
    run "Installing Docker and Docker Compose" \
        "pacman -S docker --noconfirm --needed" \
        "pacman -S docker-compose --noconfirm --needed"

    run "Adding user to docker group" \
        "usermod -aG docker $_user"

    run "Start and enable docker service" \
        "systemctl enable docker.service" \
        "systemctl start docker.service"
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
        "mkdir -p $_home/Pictures/scrot"
}

function installBlueberry {
    run "Installing Blueberry" \
        "pacman -S blueberry --noconfirm --needed"
}

function installLight {
    run "Installing Light" \
        "pacman -S light --noconfirm --needed"

    run "Adding user to video group" \
        "usermod -aG video $_user"
}

function installDunst {
    run "Installing Dunst" \
        "pacman -S dunst --noconfirm --needed"

    run "Configuring Dunst" \
        "cp -r $_install_config/dunst $_home_config/"
}

function installLogitechUR {
    run "Installing ltunify" \
        "yay -S ltunify-git --noconfirm"

    run "Creating plugdev group and adding user" \
        "groupadd -f plugdev" \
        "usermod -aG plugdev $_user"
}

function installVLC {
    run "Installing VLC" \
        "pacman -S vlc --noconfirm --needed"
}

function installStreamlink {
    run "Installing Streamlink" \
        "pacman -S streamlink --noconfirm --needed"
}

function copyCustomScripts {
    run "Copying custom config scripts" \
        "cp -r $_install_config/misc/.custom-scripts $_home/" \
        "chmod +x $_home/.custom-scripts/*"
}

function setTimeAndLocale {
    run "Setting time" \
        "ln -sf /usr/share/zoneinfo/Europe/Stockholm /etc/localtime" \
        "hwclock --systohc"

    run "Generating locale" \
        "sed -i s/\#en_US.UTF-8/en_US.UTF-8/gI /etc/locale.gen" \
        "locale-gen"

    run "Adding land and keymap to locale.conf and vconsole.conf" \
        "$(echo 'LANG=en_US.UTF-8' > /etc/locale.conf)" \
        "$(echo 'KEYMAP=sv-latin1' > /etc/vconsole.conf)"
}

function setHostname {
    run "Adding hostname to hostname and hosts" \
        "$(echo $_hostname >> /etc/hostname)" \
        "$(echo $_hostname >> /etc/hosts)"
}

function installGrub {
    run "Installing grub" \
        "pacman -S grub efibootmgr --noconfirm --needed" \
        "grub-install --target=x86_64-efi --efi-directory=/boot"

    run "Configuring grub" \
        "grub-mkconfig -o /boot/grub/grub.cfg"
}

function removeInstallationFolder {
    run "Removing installation files" \
        "rm -rf $_install_root"
}
