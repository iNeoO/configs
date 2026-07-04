#!/bin/sh

set -eu

used="$(df -P / | awk 'NR==2 {gsub(/%/, "", $5); print $5}')"
avail="$(df -hP / | awk 'NR==2 {print $4}')"

printf '{"text":" %s%%","tooltip":"Disque / utilisé: %s%%\\nEspace libre: %s"}\n' "$used" "$used" "$avail"
