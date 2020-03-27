#!/bin/bash

rofi_command="rofi -p  -no-show-icons -theme list-menu.rasi"

# Create data/streams.txt and add your favorite streams
options="$(cat ~/.config/rofi/data/streams.txt)"

chosen="$(echo -e "$options" | $rofi_command -dmenu)"

if [[ -n "$chosen" ]]; then
    if [[ $chosen =~ ^[0-9]+$ ]]; then
        streamlink https://twitch.tv/videos/$chosen best --player-passthrough hls
    else
        streamlink https://twitch.tv/$chosen best
    fi
fi