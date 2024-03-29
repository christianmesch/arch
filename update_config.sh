#!/bin/bash
SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"

cp ~/.config/i3/* $SCRIPTPATH/configs/i3/
cp ~/.config/polybar/* $SCRIPTPATH/configs/polybar/
cp /etc/emptty/conf $SCRIPTPATH/configs/emptty
cp ~/Pictures/wallpapers/* $SCRIPTPATH/configs/wallpaper/
cp ~/.zshrc $SCRIPTPATH/configs/misc/
cp ~/.zshenv $SCRIPTPATH/configs/misc/
cp ~/.gitconfig $SCRIPTPATH/configs/misc/
cp ~/.Xkbmap $SCRIPTPATH/configs/misc/
cp ~/.Xresources $SCRIPTPATH/configs/misc/
cp ~/.tmux.conf $SCRIPTPATH/configs/misc/
cp ~/.config/gtk-3.0/gtk.css $SCRIPTPATH/configs/gtk3/
cp ~/.config/gtk-3.0/settings.ini $SCRIPTPATH/configs/gtk3/
cp ~/.config/alacritty/alacritty.yml $SCRIPTPATH/configs/alacritty
cp -r ~/.config/rofi/* $SCRIPTPATH/configs/rofi/
cp -r ~/.custom-scripts/* $SCRIPTPATH/configs/misc/.custom-scripts/
cp -r ~/.config/dunst/* $SCRIPTPATH/configs/dunst/
