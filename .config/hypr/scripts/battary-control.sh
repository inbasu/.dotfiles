#!/bin/bash


# Variables
MONITOR="eDP-1"
LAST=""


while true; do
    STATUS=$(cat /sys/class/power_supply/BAT0/status 2>/dev/null || echo "Unknown")

    if [ "$STATUS" != "$LAST" ]; then
        LAST="$STATUS"

        if [ "$STATUS" = "Discharging" ]; then
            MODE="3120x2080@60"
        else
            MODE="3120x2080@120"
        fi

        hyprctl eval "hl.monitor({ output = \"$MONITOR\", mode = \"$MODE\", position = \"auto\", scale = \"auto\" })"
    fi

    sleep 5
done
