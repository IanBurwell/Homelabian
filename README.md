# Homelabian - Ian's custom homelab Debian image
![to-do-badge](https://img.shields.io/endpoint?url=https://gist.githubusercontent.com/ianburwell/0ec3052f4bd1c320fa986de9ae312d59/raw/todos.json)

Scripts and configs used with `mkosi` to build a custom bare-ish bones Debian image that is quick and easy to set up on a new machine (currently targeted at an intel DFF PC).

## Usage
1. In a Linux/WSL environment, install `debian-archive-keyring` and [`mkosi v26`](https://github.com/systemd/mkosi) for the root user via pipx ([update pipx for Ubuntu 24](https://github.com/pypa/pipx/discussions/1427)):
```
sudo apt install debian-archive-keyring
sudo pipx install --global https://github.com/systemd/mkosi/archive/refs/tags/v26.tar.gz
mkosi --version
```

2. Create a `.env` to you liking (see `.env.example`). User password can be generated with `openssl passwd -6`.
3. To build, just run `sudo mkosi -f` (sudo required for custom users).
4. To quickly test in a sandbox use `mkosi boot`. To test the image in a full VM, run `sudo mkosi vm`. Note you can add `-f` to also re-build the image.


## Other helpful stuff

[`mkosi`'s man page](https://github.com/systemd/mkosi/blob/main/mkosi/resources/man/mkosi.1.md) for usage and documentation.

- `mkosi burn <device>` looks useful
- To quit a VM `Ctrl+C`+`X`
- To quit from `mkosi boot` type `CTRL+]` three times in a row
- Install `apt-cacher-ng` to cache apt packages and speed up build