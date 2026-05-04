#!/usr/bin/env bash

choice=$(printf "Lock\nLogout\nReboot\nShutdown\n" | wofi --dmenu -p "Power")

case "$choice" in
  "Lock")
    ~/.config/sway/lock.sh
    ;;
  "Logout")
    swaymsg exit
    ;;
  "Reboot")
    systemctl reboot
    ;;
  "Shutdown")
    systemctl poweroff
    ;;
esac
