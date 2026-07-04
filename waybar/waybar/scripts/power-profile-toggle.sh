#!/bin/sh

profile_file="/sys/firmware/acpi/platform_profile"
helper="${POWER_PROFILE_HELPER:-$HOME/.config/waybar/scripts/set-platform-profile}"

if [ ! -r "$profile_file" ]; then
  notify-send "Waybar" "Power profile unavailable"
  exit 1
fi

current=$(cat "$profile_file")

case "$current" in
  low-power)
    next="balanced"
    ;;
  balanced)
    next="performance"
    ;;
  performance)
    next="low-power"
    ;;
  *)
    next="balanced"
    ;;
esac

if sudo "$helper" "$next"; then
  notify-send "Waybar" "Power profile: $next"
  pkill -SIGUSR2 waybar 2>/dev/null || true
else
  notify-send "Waybar" "Failed to switch power profile"
  exit 1
fi
