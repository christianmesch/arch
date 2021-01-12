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
        sleep 0.5 && maim -u ~/Pictures/scrot/$(date +"%F_%T.%N")_scrot.png && notify-send Screenshot "Screenshot captured!"
        ;;
    $area)
        maim -su ~/Pictures/scrot/$(date +"%F_%T.%N")_scrot.png && notify-send Screenshot "Screenshot captured!"
        ;;
    $window)
        maim -su ~/Pictures/scrot/$(date +"%F_%T.%N")_scrot.png && notify-send Screenshot "Screenshot captured!"
        ;;
esac

