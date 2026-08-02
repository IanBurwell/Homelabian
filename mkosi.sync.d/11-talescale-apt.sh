#!/bin/bash
set -euo pipefail
set -x

# Updates the apt sources for tailscale VPN and adds the GPG key to the image
# While these are tracked in git, they may be updated in the future, so this 
# script ensures that the latest versions are used when building the image

# Based on https://tailscale.com/install.sh

TRACK="stable"
OS="${DISTRIBUTION}"
VERSION="${RELEASE}"

curl -fsSL "https://pkgs.tailscale.com/$TRACK/$OS/$VERSION.noarmor.gpg" \
  -o mkosi.extra/usr/share/keyrings/tailscale-archive-keyring.gpg
chmod 0644 mkosi.extra/usr/share/keyrings/tailscale-archive-keyring.gpg

curl -fsSL "https://pkgs.tailscale.com/$TRACK/$OS/$VERSION.tailscale-keyring.list" \
  -o mkosi.extra/etc/apt/sources.list.d/tailscale.list
chmod 0644 mkosi.extra/etc/apt/sources.list.d/tailscale.list
