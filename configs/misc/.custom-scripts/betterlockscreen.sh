#!/bin/bash

# Create lock screen background if not exist
if [ ! -f ~/.cache/i3lock/current/l_dim.png ]; then
    betterlockscreen -u ~/Pictures/wallpapers/cristofer-jeschke-VIqCeAwQ1rU-unsplash.jpg
fi
