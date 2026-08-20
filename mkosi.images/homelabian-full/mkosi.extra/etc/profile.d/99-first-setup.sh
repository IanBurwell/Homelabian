#!/bin/bash

# Only execute the script if setup hasn't been completed yet
SETUP_MARKER="/var/lib/.homelabian-setup"
if [[ -f "$SETUP_MARKER" && "$1" != "-f" ]]; then
    return 0
fi

DIM="\x1b[2m"
BOLD="\x1b[1m"
GREEN="\x1b[32m"
YELLOW="\x1b[33m"
RED="\x1b[31m"
ANSI_RESET="\x1b[0m"

log() {
    printf '%b\n' "$*"
}

info() {
    printf '%b\n' "${GREEN}${BOLD}$*${ANSI_RESET}"
}

warn() {
    printf '%b\n' "${YELLOW}$*${ANSI_RESET}"
}

error() {
    printf '%b\n' "${RED}$*${ANSI_RESET}" >&2
}

setup_password() {
    # Check if the password is default and prompt to change if so
    TEST_PASS="homelaben"
    USER_HASH=$(grep "^$SUDO_USER:" /etc/shadow | cut -d: -f2)
    TEST_HASH=$(perl -le 'print crypt($ARGV[0], $ARGV[1])' "$TEST_PASS" "$USER_HASH")
    if [ "$USER_HASH" != "$TEST_HASH" ]; then
        log "The user password is not default, no need to change"
        return 0
    fi

    # If default password is set, prompt to change
    log "Your password is default, please enter a new one: "
    passwd $SUDO_USER
}

setup_hostname() {
    local current_hostname="$(cat /etc/hostname 2>/dev/null || true)"
    local new_hostname=""

    current_hostname="${current_hostname:-homelabian}"

    read -r -p "Set hostname [${current_hostname}]: " new_hostname
    if [[ -z "$new_hostname" ]]; then
        new_hostname="$current_hostname"
    fi

    printf '%s\n' "$new_hostname" > /etc/hostname
    hostname "$new_hostname" 2>/dev/null || true
    sed -i "s/homelabian/${new_hostname}/" /etc/hosts

    log "Hostname set to ${new_hostname}"
}

setup_ssh_keys() {
    local passwd=""
    local sudo_user=""
    local home_dir=""
    local ssh_dir=""
    local uid=""
    local gid=""

    sudo_user="${SUDO_USER:-${USER:-}}"
    if [[ -z "$sudo_user" ]]; then
        error "No SUDO_USER found, must be run with sudo"
        return 0
    fi

    home_dir="/home/${sudo_user}"
    uid="$(id -u "$sudo_user")"
    gid="$(id -g "$sudo_user")"
    ssh_dir="${home_dir}/.ssh"
    install -d -m 0700 -o "$uid" -g "$gid" "$ssh_dir"
    if [[ -f "$ssh_dir/id_ed25519" ]]; then
        log "Skipping SSH keys as '${ssh_dir}/id_ed25519' already exists"
        return 0
    fi

    # Prompt and re-prompt user to put in an SSH key password
    while true; do
        read -r -s -p "Password for local SSH keys: " passwd
        printf '\n'

        if [[ -z "$passwd" ]]; then
            warn "Valid password required"
            continue
        fi

        if [[ ${#passwd} -lt 6 ]]; then
            warn "Password must be at least 6 characters"
            continue
        fi

        local confirm_passwd=""
        read -r -s -p "Confirm password: " confirm_passwd
        printf '\n'

        if [[ "$passwd" != "$confirm_passwd" ]]; then
            warn "Passwords do not match. Please try again."
            continue
        fi

        break
    done

    # Generate keys
    if ! ssh-keygen -q -t ed25519 -N "$passwd" -C "${sudo_user}@$(hostname)" -f "$ssh_dir/id_ed25519"; then
        error "Failed to generate SSH key"
        return 1
    fi

    # Ensure keys are owned by the normal user 
    chmod 600 "$ssh_dir/id_ed25519"
    chmod 644 "$ssh_dir/id_ed25519.pub"
    chown "$uid:$gid" "$ssh_dir/id_ed25519" "$ssh_dir/id_ed25519.pub"

    log "SSH key generated at ${ssh_dir}/id_ed25519"
}

setup_tailscale() {
    log "Tailscale setup: "
    if ! tailscale up; then
        error "Tailscale setup failed, run manually with 'sudo tailscale up'"
        return 1
    fi
    log "Tailscale setup, remember to disable key expiry of this server on the web interface"
    return 0
}

grow_rootfs(){
    ROOT_PART=$(findmnt -n -o SOURCE /)
    PARENT_DISK="/dev/$(lsblk -no PKNAME "$ROOT_PART")"
    PART_NUM=$(cat /sys/class/block/$(basename "$ROOT_PART")/partition 2>/dev/null)

    log "Enlarging rootfs ($ROOT_PART, $PARENT_DISK, $PART_NUM)..."
    echo -e "$DIM"
    growpart "$PARENT_DISK" "$PART_NUM"
    resize2fs "$ROOT_PART"
    echo -e "$ANSI_RESET"
}

mark_setup_complete() {
    install -d -m 0755 "$(dirname "$SETUP_MARKER")"
    printf "Configured by /etc/profile.d/99-first-setup.sh on '$(date)'\n" > "$SETUP_MARKER"
}

main() {
    if [[ ! -t 0 ]]; then
        log "Non-interactive shell detected; skipping first-run setup"
        return 0
    fi

    if [[ -f "$SETUP_MARKER" ]]; then
        warn "System has already been setup! Continue with caution"
    fi

    setup_password
    setup_hostname
    setup_ssh_keys
    setup_tailscale
    grow_rootfs
    mark_setup_complete
    info "Setup complete. Future logins will skip this script"
}


# Re-execute as root with SUDO (doesn't use exec to prevent returning 0 on err)
if [[ $EUID -ne 0 ]]; then
    info "Starting homelabian first time setup..."
    sudo ${BASH_SOURCE[0]}
else
    main
fi
