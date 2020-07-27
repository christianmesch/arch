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
        sleep 1; cd ~/Pictures/scrot/; scrot '%Y-%m-%d_$wx$h_scrot.png'
        ;;
    $area)
        sleep 0.5; cd ~/Pictures/scrot/; scrot -s '%Y-%m-%d_$wx$h_scrot.png'
        ;;
    $window)
        sleep 1; cd ~/Pictures/scrot/; scrot -u '%Y-%m-%d_$wx$h_scrot.png'
        ;;
esac

