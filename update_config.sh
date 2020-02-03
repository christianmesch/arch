#!/bin/bash
SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"

cp ~/.config/i3/* $SCRIPTPATH/configs/i3/
cp ~/.config/polybar/* $SCRIPTPATH/configs/polybar/
cp /etc/lightdm/* $SCRIPTPATH/configs/lightdm/
cp ~/Pictures/wallpapers/* $SCRIPTPATH/configs/wallpaper/
cp ~/.bashrc $SCRIPTPATH/configs/misc/