#!/usr/bin/env bash

set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$HOME/.config"
BACKUP_DIR="$HOME/.config-backups/sway-$(date +%Y%m%d-%H%M%S)"

mkdir -p "$CONFIG_DIR" "$BACKUP_DIR"

copy_config() {
  local source_rel="$1"
  local target="$2"
  local source="$REPO_DIR/$source_rel"

  if [ -e "$target" ] || [ -L "$target" ]; then
    mv "$target" "$BACKUP_DIR/"
  fi

  cp -a "$source" "$target"
}

copy_config "sway" "$CONFIG_DIR/sway"
copy_config "waybar/waybar" "$CONFIG_DIR/waybar"
copy_config "wofi" "$CONFIG_DIR/wofi"
copy_config "kitty" "$CONFIG_DIR/kitty"

chmod +x "$CONFIG_DIR/sway/lock.sh"
chmod +x "$CONFIG_DIR/waybar/scripts/"*.sh

if [ -e "$HOME/.xinitrc" ] || [ -L "$HOME/.xinitrc" ]; then
  mv "$HOME/.xinitrc" "$BACKUP_DIR/.xinitrc"
fi

printf 'exec sway\n' > "$HOME/.xinitrc"

printf 'Backup created in %s\n' "$BACKUP_DIR"
printf 'Sway config installed. Next graphical start will use sway via ~/.xinitrc.\n'
