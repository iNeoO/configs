#!/bin/sh

profile_file="/sys/firmware/acpi/platform_profile"

if [ ! -r "$profile_file" ]; then
  printf '%s\n' '{"text":"PWR","tooltip":"Power profile unavailable","class":"unknown"}'
  exit 0
fi

profile=$(cat "$profile_file")

case "$profile" in
  performance)
    text=" PERF"
    ;;
  balanced)
    text=" BAL"
    ;;
  low-power|power-saver)
    text=" ECO"
    ;;
  *)
    text="PWR $profile"
    ;;
esac

printf '{"text":"%s","tooltip":"Power profile: %s","class":"%s"}\n' "$text" "$profile" "$profile"
