#!/bin/bash
set -euo pipefail  # Fail on error, unset variables, or failed pipeline steps
set -x  # debug print script commands in build log

# This script runs after building and installing everything into the image
# In particular, it adds the custom hostname to `/etc/hosts` to prevent sudo warnings

# Extract the hostname directly from the mkosi configuration file
CONFIG_HOSTNAME=$(jq -r '.Hostname | select(. != null)' "$MKOSI_CONFIG")
if [[ -n "$CONFIG_HOSTNAME" ]]; then
    echo "127.0.1.1       $CONFIG_HOSTNAME" >> "$BUILDROOT/etc/hosts"
fi