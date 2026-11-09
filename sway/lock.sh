#!/bin/bash
set -e

TMP_BLUR=/tmp/lock-blur.png

# Raw PPM via pipe + blur on a downscaled copy: ~0.3s instead of ~6s at 3000x1876.
grim -t ppm - | magick - -scale 10% -blur 0x2.5 -scale 1000% \
  -define png:compression-level=1 "$TMP_BLUR"

swaylock --image "$TMP_BLUR"
rm -f "$TMP_BLUR"
