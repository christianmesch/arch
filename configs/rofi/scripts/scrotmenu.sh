#!/bin/bash

rofi_command="rofi -no-show-icons -theme scrot-menu.rasi"

### Options ###
screen=""
area=""
window=""

# Variable passed to rofi
options="$screen\n$area\n$window"

chosen="$(echo -e "$options" | $rofi_command -dmenu -selected-row 1)"
case $chosen in
    $screen)
        sleep 1; scrot '%Y-%m-%d_$wx$h_scrot.png' -e 'mv $f ~/Pictures/scrot/'
        ;;
    $area)
        scrot -s '%Y-%m-%d_$wx$h_scrot.png' -e 'mv $f ~/Pictures/scrot/'
        ;;
    $window)
        sleep 1; scrot -u '%Y-%m-%d_$wx$h_scrot.png' -e 'mv $f ~/Pictures/scrot/'
        ;;
esac

