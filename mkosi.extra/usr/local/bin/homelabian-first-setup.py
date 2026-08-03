#!/usr/bin/env python3

"""Simple first-run setup helper for Homelabian.

This script runs through a set of initial setup steps that are unique per-image
such as setting a unique hostname and generating SSH keys
"""

import os
import sys

SETUP_MARKER = "/var/lib/.homelabian-setup"
DIM = "\x1b[2m"
BOLD = "\x1b[1m"
BLINK = "\x1b[5m"
GREEN = "\x1b[32m"
YELLOW = "\x1b[33m"
RED = "\x1b[31m"
ANSI_RESET = "\x1b[0m"


def log(message: str) -> None:
    print(f"{DIM}[homelabian] {message}{ANSI_RESET}")


def confirm(prompt: str) -> bool:
    answer = ""
    while answer.lower() not in ["y", "yes", "n", "no"]:
        answer = input(f"{prompt} [y/n]: ").strip().lower()
    
    return answer in {"y", "yes"}


def setup_hostname() -> None:
    log("Hostname setup placeholder")
    hostname = input("Enter a unique hostname (leave blank to skip): ").strip()
    if hostname:
        log(f"Would configure hostname to: {hostname}")
        # TODO: implement hostname setup here


def setup_tailscale() -> None:
    log("Tailscale setup placeholder")
    if confirm("Would you like to configure Tailscale?"):
        auth_key = input("Paste a Tailscale auth key (leave blank to skip): ").strip()
        if auth_key:
            log("Would start Tailscale setup with the provided auth key")
        else:
            log("No auth key supplied; skipping Tailscale setup")


def setup_ssh_keys() -> None:
    log("SSH key setup placeholder")
    if confirm("Would you like to generate SSH keys?"):
        email = input("Enter an email for the key comment (optional): ").strip()
        log(f"Would generate SSH keys with comment: {email or 'default'}")
        # TODO: implement ssh-keygen setup here


def mark_setup_complete() -> None:
    try:
        with open(SETUP_MARKER, "w", encoding="utf-8") as handle:
            handle.write("configured by homelabian-first-setup.py\n")
    except OSError as exc:
        log(f"Could not create {SETUP_MARKER}: {exc}")


def main() -> None:
    if (os.path.exists(SETUP_MARKER) and 
        not confirm("System has already been setup, continue?")):
        return

    if not sys.stdin.isatty():
        log("Non-interactive shell detected; skipping first-run setup")
        return

    log("Starting first-run setup")
    print("Time to setup our new instance!")

    if confirm("Set a unique hostname?"):
        setup_hostname()

    if confirm("Configure Tailscale?"):
        setup_tailscale()

    if confirm("Generate SSH keys?"):
        setup_ssh_keys()

    mark_setup_complete()
    log("Setup complete. Future logins will skip this script.")


if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        print("\nSetup aborted.")
    except Exception as exc:  # pragma: no cover - defensive fallback
        log(f"Setup hit an unexpected error: {exc}")
        sys.exit(1)

