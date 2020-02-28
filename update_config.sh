#!/bin/bash
SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"

cp ~/.config/i3/* $SCRIPTPATH/configs/i3/
cp ~/.config/polybar/* $SCRIPTPATH/configs/polybar/
cp /etc/lightdm/* $SCRIPTPATH/configs/lightdm/
cp ~/Pictures/wallpapers/* $SCRIPTPATH/configs/wallpaper/
cp ~/.bashrc $SCRIPTPATH/configs/misc/
cp ~/.gitconfig $SCRIPTPATH/configs/misc/
cp ~/.Xkbmap $SCRIPTPATH/configs/misc/
cp ~/.config/gtk-3.0/* $SCRIPTPATH/configs/gtk3
cp ~/.config/terminator/config $SCRIPTPATH/configs/terminator
cp -r ~/.config/rofi/* $SCRIPTPATH/configs/rofi/