#!/usr/bin/env bash

LAPTOP="eDP-1"

# Detect the first connected external output (anything that isn't the laptop)
EXTERNAL=$(swaymsg -t get_outputs | python3 -c "
import json, sys
outputs = json.load(sys.stdin)
for o in outputs:
    if o['name'] != 'eDP-1':
        print(o['name'])
        break
")

if [ -z "$EXTERNAL" ]; then
  choice=$(printf "Laptop only\n" | wofi --dmenu -p "Display")
else
  # Read actual resolutions from sway
  read LAPTOP_W LAPTOP_H < <(swaymsg -t get_outputs | python3 -c "
import json, sys
for o in json.load(sys.stdin):
    if o['name'] == 'eDP-1':
        print(o['current_mode']['width'], o['current_mode']['height'])
        break
")
  read EXTERNAL_W EXTERNAL_H < <(swaymsg -t get_outputs | python3 -c "
import json, sys
for o in json.load(sys.stdin):
    if o['name'] != 'eDP-1':
        print(o['current_mode']['width'], o['current_mode']['height'])
        break
")

  choice=$(printf "Extend right\nExtend left\nExtend top\nMirror\nLaptop only\nExternal only\n" | wofi --dmenu -p "Display ($EXTERNAL)")
fi

case "$choice" in
  "Laptop only")
    swaymsg output "$LAPTOP" enable
    [ -n "$EXTERNAL" ] && swaymsg output "$EXTERNAL" disable
    ;;
  "External only")
    swaymsg output "$LAPTOP" disable
    swaymsg output "$EXTERNAL" enable
    ;;
  "Mirror")
    swaymsg output "$LAPTOP" enable position 0 0
    swaymsg output "$EXTERNAL" enable position 0 0
    ;;
  "Extend right")
    swaymsg output "$LAPTOP" enable position 0 0
    swaymsg output "$EXTERNAL" enable position "$LAPTOP_W" 0
    ;;
  "Extend left")
    swaymsg output "$EXTERNAL" enable position 0 0
    swaymsg output "$LAPTOP" enable position "$EXTERNAL_W" 0
    ;;
  "Extend top")
    swaymsg output "$EXTERNAL" enable position 0 0
    swaymsg output "$LAPTOP" enable position 0 "$EXTERNAL_H"
    ;;
esac
