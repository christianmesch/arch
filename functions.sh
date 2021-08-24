#!/bin/bash

function run {
    _error=""
    _command=""

    echo "$_bold$1$_normal"
    for var in "${@:2}"; do
        IFS=' ' read -ra cmd <<< "$var"
        if [[ ${cmd[0]} == "paru" ]]; then
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

function installParu {    
    cd $_install_root
    
    run "Cloning paru repo" \
        "git clone --depth 1 https://aur.archlinux.org/paru.git" \
        "chmod -R 777 paru"

    cd paru

    run "Installing paru" \
        "runuser -u $_user -- makepkg -si --noconfirm --needed"
}

function installNpm {
    run "Installing npm" \
        "pacman -S npm --noconfirm --needed"
}

function installNvm {
    run "Installing nvm" \
        "paru -S nvm --noconfirm"
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

    run "Copying .Xkbmap and .Xresources" \
        "cp $_install_config/misc/.Xkbmap $_home" \
        "cp $_install_config/misc/.Xresources $_home"

    run "Installing open source Nvidia drivers" \
        "pacman -S xf86-video-nouveau --noconfirm --needed"
}

function installPicom {
    run "Installing picom" \
        "pacman -S picom --noconfirm --needed"
}

function copyWallpapers {
    run "Copying wallpapers" \
        "mkdir -p $_home/Pictures/wallpapers" \
        "cp -r $_install_config/wallpaper/* $_home/Pictures/wallpapers"
}

function installEmptty {
    run "Installing Emptty" \
        "paru -S emptty --noconfirm" \
        "systemctl enable emptty.service"

    run "Configuring Emptty" \
        "cp -r $_install_config/emptty/* /etc/emptty/"
}

function installI3 {
    run "Installing i3-gaps and feh" \
        "pacman -S i3-gaps feh --noconfirm --needed"

    run "Configuring i3" \
        "mkdir -p $_home_config/i3" \
        "cp -r $_install_config/i3/* $_home_config/i3/"
}

function installPolybar {
    run "Installing Polybar" \
        "paru -S polybar-git --noconfirm" \
        "install -Dm644 /usr/share/doc/polybar/config $_home_config/polybar/config" \
        "pacman -S ttf-font-awesome ttf-nerd-fonts-symbols --noconfirm --needed"

    run "Configuring Polybar" \
        "cp -r $_install_config/polybar/* $_home_config/polybar/"
}

function installBetterLockscreen {
    run "Removing i3lock in favor of BetterLockscreen" \
        "pacman -Rs i3lock --noconfirm"

    run "Installing BetterLockscreen" \
        "paru -S --noconfirm betterlockscreen"

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

    ./change_color.sh -o materia-dark-compact-custom <(echo -e "ROUNDNESS=0\nBG=$_background_color\nFG=eeeeee\nHDR_BG=$_background_color\nHDR_FG=$_foreground_color\nSEL_BG=$_accent_color\nMATERIA_VIEW=303030\nMATERIA_SURFACE=424242\nMATERIA_STYLE_COMPACT=True\n") 1>/dev/null

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
        "paru -S --noconfirm visual-studio-code-bin"

    run "Installing Jetbrains Toolbox" \
        "paru -S --noconfirm jetbrains-toolbox"

    run "Creating workspace" \
        "mkdir $_home/dev" \
        "chown -R ${_user}:${_user} $_home/dev"
}

function installOpenJDK {
    run "Installing OpenJDK" \
        "pacman -S jdk-openjdk --noconfirm --needed"
}

function installYarn {
    run "Installing yarn" \
        "runuser -u ${_user} -- sudo npm install -g yarn"
}

function installTypescript {
    run "Installing Typescript" \
        "pacman -S typescript --noconfirm --needed"
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
        "paru -S --noconfirm slack-desktop"
}

function installZsh {
    run "Installing zsh and oh-my-zsh" \
        "pacman -S zsh --noconfirm --needed" \
        "runuser -u ${_user} -- sh -c '$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)' '' --unattended"

    run "Cloning zsh-autosuggestions" \
        "git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-$_home/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"

    run "Cloning zsh-syntax-highlighting" \
        "git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-$_home/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"

    run "Copying .zshrc" \
        "cp $_install_config/misc/.zshrc $_home" \
        "cp $_install_config/misc/.zshenv $_home"

    echo "${_bold}Making sure that .zshrc has got the correct user$_normal"
    sed -i "s/mesch/$_user/g" "$_home/.zshrc"
}

function installAlacritty {
    run "Installing Alacritty" \
        "pacman -S alacritty --noconfirm --needed"

    run "Configuring Alacritty" \
	"mkdir -p $_home_config/alacritty" \
        "cp -r $_install_config/alacritty $_home_config/alacritty"
}

function installCLI {
    run "Installing various CLIs" \
        "paru -S tealdeer --noconfirm" \
        "pacman -S diff-so-fancy --noconfirm --needed" \
        "pacman -S bat --noconfirm --needed" \
        "pacman -S ripgrep --noconfirm --needed" \
        "pacman -S fd --noconfirm --needed" \
        "pacman -S fzf --noconfirm --needed" \
        "pacman -S exa --noconfirm --needed"

    run "Copying .gitconfig" \
        "cp $_install_config/misc/.gitconfig $_home"
}

function installTmux {
    run "Installing tmux" \
        "pacman -S tmux --noconfirm --needed"

    run "Configuring tmux" \
        "cp $_install_config/misc/.tmux.config $_home"

    run "Installing tmuxinator" \
        "paru -S tmuxinator --noconfirm"
}

function installPowerline {
    run "Installing powerline" \
        "pacman -S powerline powerline-fonts --noconfirm --needed"
}

function installOpenssh {
    run "Installing openssh" \
        "pacman -S openssh --noconfirm --needed"
}

function installMaim {
    run "Installing maim" \
        "pacman -S maim --noconfirm --needed"

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
        "paru -S ltunify-git --noconfirm"

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

function readColorsFromXresources {
    _accent_color=`awk -F '#' '/accentColor/ {print $2}' $_install_config/misc/.Xresources`
    _background_color=`awk -F '#' '/background/ {print $2}' $_install_config/misc/.Xresources`
    _foreground_color=`awk -F '#' '/foreground/ {print $2}' $_install_config/misc/.Xresources`
}

function removeInstallationFolder {
    run "Removing installation files" \
        "rm -rf $_install_root"
}
