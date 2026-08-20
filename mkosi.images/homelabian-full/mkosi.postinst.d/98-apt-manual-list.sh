#!/bin/bash
set -euo pipefail  # Fail on error, unset variables, or failed pipeline steps
set -x  # debug print script commands in build log

# Manually generate initial list of installed apt packages for etckeeper tracking
mkosi-chroot apt-mark showmanual > "$BUILDROOT/etc/apt-manual-packages.list"
