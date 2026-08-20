#!/bin/bash
set -euo pipefail
set -x

# Deletes package translations for other languages which take up space and provide little value

# Extract the exact value of `Locale=`
CONFIG_LOCALE=$(jq -r '.Locale | select(. != null)' "$MKOSI_CONFIG")
if [[ -z "$CONFIG_LOCALE" ]]; then
  echo "Error: Locale= setting not found"
  exit 1
fi

# Extract just the base language code (ex "en" from "en_US.UTF-8")
LANG_PREFIX=$(echo "$CONFIG_LOCALE" | cut -d_ -f1)

# Delete extra translations in `/usr/share/locale/` 
mkosi-chroot find /usr/share/locale/ -mindepth 1 -maxdepth 1 ! -name "*${LANG_PREFIX}" ! -name '*.alias' -exec rm -rf {} +

echo "Deleted locales for everything except: ${LANG_PREFIX}"