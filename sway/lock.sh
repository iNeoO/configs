#!/bin/bash
set -e

TMP_SCREEN=/tmp/lock-screen.png
TMP_BLUR=/tmp/lock-blur.png

grim "$TMP_SCREEN"
magick "$TMP_SCREEN" -blur 20x10 "$TMP_BLUR"
rm -f "$TMP_SCREEN"

swaylock --image "$TMP_BLUR"
rm -f "$TMP_BLUR"