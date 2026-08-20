#!/bin/bash
set -euo pipefail  # Fail on error, unset variables, or failed pipeline steps
set -x  # debug print script commands in build log

# Allow the ping binary to use raw sockets and thus not need sudo
mkosi-chroot setcap cap_net_raw+ep /usr/bin/ping
