#!/usr/bin/env bash

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

primary="$( xrandr | grep primary | cut -d ' ' -f 1 )"

# Launch polybar
echo "---" | tee -a /tmp/polybar.log
for m in $(polybar --list-monitors | cut -d":" -f1); do
    tray_position="right"
    if [[ "$m" != "$primary" ]]; then
        tray_position="none"
    fi

    MONITOR=$m TRAY=$tray_position polybar --reload poly >>/tmp/polybar.log 2>&1 &
done

echo "Bar launched..."
