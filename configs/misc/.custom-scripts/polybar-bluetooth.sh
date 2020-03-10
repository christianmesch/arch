#!/usr/bin/env bash

devices=`bluetoothctl paired-devices | cut -d ' ' -f 2`
count=0

for d in $devices; do
    info=`bluetoothctl info $d`
    if echo "$info" | grep -q "Connected: yes"; then
        name=`echo "$info" | grep Alias | cut -d ' ' -f 2-`
        if [ $count -gt 0 ]; then
            printf ", %s" "$name"
        else
            printf "%s" "$name"
        fi
        count=$((counter + 1))
    fi
done

printf '\n'