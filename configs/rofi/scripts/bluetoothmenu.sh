#!/bin/bash

rofi_command="rofi -p  -no-show-icons -theme list-menu.rasi"

devices=`bluetoothctl paired-devices`
options=`echo "$devices" | cut -d ' ' -f3-`

chosen="$(echo -e "$options" | $rofi_command -dmenu)"

if [[ -n "$chosen" ]]; then
    mac=`echo "$devices" | grep $chosen | cut -d ' ' -f2`

    info=`bluetoothctl info $m`
    if echo "$info" | grep -q "Connected: yes"; then
        bluetoothctl disconnect $mac
    else
        bluetoothctl connect $mac
    fi
fi