#!/usr/bin/env bash

set -eu

if command -v makoctl >/dev/null 2>&1; then
  makoctl mode -a do-not-disturb >/dev/null 2>&1 || true
fi

swaylock -f -c 1e1e2e

if command -v makoctl >/dev/null 2>&1; then
  makoctl mode -r do-not-disturb >/dev/null 2>&1 || true
fi
