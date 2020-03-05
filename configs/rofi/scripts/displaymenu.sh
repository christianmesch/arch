#!/bin/bash

rofi_command="rofi -p  -no-show-icons -theme list-menu.rasi"

primary="$( xrandr | grep primary | cut -d ' ' -f 1 )"
options="$( xrandr | grep ' connected' | grep -v primary | cut -d ' ' -f 1 )"

chosen="$(echo -e "$options" | $rofi_command -dmenu)"
is_active="$( xrandr --listactivemonitors | awk '{print $4}' | grep -w $chosen)"

if [[ -n "$is_active" ]]; then
    notify-send "Disconnecting display $chosen"
    xrandr --output $chosen --off
elif [[ -n "$chosen" ]]; then
    notify-send "Connecting display $chosen right of $primary"
    xrandr --output $chosen --auto --right-of $primary
fi

