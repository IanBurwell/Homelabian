#!/bin/bash
set -euo pipefail  # Fail on error, unset variables, or failed pipeline steps
set -x  # debug print script commands in build log

# This script generates and sets locale variables

# Image locale
CONFIG_LOCALE=$(jq -r '.Locale | select(. != null)' "$MKOSI_CONFIG")
if [[ -z "$CONFIG_LOCALE" ]]; then
  echo "Error: Locale= setting not found"
  exit 1
fi

# Generate required locale definitions
echo "$CONFIG_LOCALE UTF-8" > "$BUILDROOT/etc/locale.gen"
mkosi-chroot locale-gen

# Explicitly set locale variable
echo "LANG=$CONFIG_LOCALE" > "$BUILDROOT/etc/locale.conf"
