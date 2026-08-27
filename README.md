# Homelabian - Ian's custom homelab Debian image

<div align="center">
  <a href="https://github.com/IanBurwell/Homelabian"><img src="https://img.shields.io/badge/Debian-A81D33?logo=debian&logoColor=fff" alt="Debian"></a>
  <a href="https://github.com/IanBurwell/Homelabian"><img src="https://img.shields.io/endpoint?url=https://gist.githubusercontent.com/ianburwell/0ec3052f4bd1c320fa986de9ae312d59/raw/todos.json" alt="to-do-badge"></a>
  <a href="https://github.com/IanBurwell/Homelabian"><img src="https://img.shields.io/endpoint?url=https://gist.githubusercontent.com/ianburwell/0ec3052f4bd1c320fa986de9ae312d59/raw/img-size.json" alt="img-size-badge"></a>
  <a href="https://github.com/IanBurwell/Homelabian"><img src="https://img.shields.io/endpoint?url=https://gist.githubusercontent.com/ianburwell/0ec3052f4bd1c320fa986de9ae312d59/raw/mini-size.json" alt="mini-size-badge"></a>
  <a href="https://github.com/IanBurwell/Homelabian/actions"><img src="https://img.shields.io/github/actions/workflow/status/IanBurwell/Homelabian/mkosi-build.yml" alt="GitHub Actions Workflow Status"></a>
  <a href="https://github.com/IanBurwell/Homelabian/commits/main"><img src="https://img.shields.io/github/last-commit/IanBurwell/Homelabian" alt="GitHub last commit"></a>
</div>


Scripts and configs used with `mkosi` to build a custom bare-ish bones Debian image that is quick and easy to set up on a new homelab server, including a simple first time setup routine that runs the user though initial steps such as generating SSH keys and setting up tailscale.

## Usage
1. In a Linux/WSL environment, install `debian-archive-keyring` and [`mkosi v26`](https://github.com/systemd/mkosi) for the root user via pipx ([update pipx for Ubuntu 24](https://github.com/pypa/pipx/discussions/1427)):
```
sudo apt install debian-archive-keyring
sudo pipx install --global https://github.com/systemd/mkosi/archive/refs/tags/v26.tar.gz
mkosi --version
```

2. Create a `.env` to you liking (see `.env.example`). User password can be generated with `openssl passwd -6`.
3. To build, just run `sudo mkosi -f` (sudo required for custom users).
4. To quickly test the rootfs in a sandbox use `sudo systemd-nspawn --boot --image build/homelabian-mini_*.img` (use `CTRL+]]]` to exit).
5. To test in a vm, install `qemu-system-x86` and run the below (exit with `CTRL-A`+`X`):
  ```bash
  sudo qemu-system-x86_64 \
    -m 2G \
    -machine q35 \
    -bios /usr/share/ovmf/OVMF.fd \
    -drive file=$(ls build/homelabian-flasher_*.img | head -n 1),format=raw,if=virtio
  ```

## Other helpful stuff

- [`mkosi`'s man page](https://github.com/systemd/mkosi/blob/main/mkosi/resources/man/mkosi.1.md) for usage and documentation.
- To update an OS image in-place, one can use `kexec` to boot an new kernel/initramfs. [NixOS has a nice way to do this](https://github.com/nix-community/nixos-images#kexec-tarballs), and after booting the server into it you can SCP over a new homelabian image and `dd` it to the main disk.