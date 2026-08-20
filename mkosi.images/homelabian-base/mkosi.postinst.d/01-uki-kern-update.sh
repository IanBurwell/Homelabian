#!/bin/bash
set -euo pipefail  # Fail on error, unset variables, or failed pipeline steps
set -x  # debug print script commands in build log

# This script tells the debian/systemd kernel to build an install a new UKI when
# apt downloads a new kernel. mkosi's README suggests this can be done with 
# mkosi itself, but that is overkill when Debian can built the initfs itself
echo -e "layout=uki" > "$BUILDROOT/etc/kernel/install.conf"
