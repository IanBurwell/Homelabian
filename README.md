# Homelabian - Ian's custom homelab Debian image

Scripts and configs used with `mkosi` to build a custom bare-ish bones Debian image that is quick and easy to set up on a new machine (currently targeted at an intel DFF PC).


## Usage
1. In a Linux/WSL environment, install  [`mkosi v26`](https://github.com/systemd/mkosi) for the root user via pipx ([update pipx for Ubuntu 24](https://github.com/pypa/pipx/discussions/1427)):
```
sudo pipx install --global https://github.com/systemd/mkosi/archive/refs/tags/v26.tar.gz
mkosi --version
```

2. Create a `.env` to you liking (see `.env.example`). User password can be generated with `openssl passwd -6`.
3. To build, just run `sudo mkosi build` (sudo required for custom users). If you modify the `mkosi.conf` file you will need to specify `-f`.
4. To quickly test in a sandbox use `mkosi boot`. To test the image in a full VM, run `mkosi vm`. 


## Other helpful stuff

[`mkosi`'s man page](https://github.com/systemd/mkosi/blob/main/mkosi/resources/man/mkosi.1.md) for usage and documentation.

Subcommands that look useful:
```
mkosi summary  # prints summary info based on the current configs
mkosi shell    # opens the image sandboxed without booting for quick inspection
mkosi boot     # boots the image in a container
mkosi vm       # boots the image fully virtualized (boots the new kernel etc)
mkosi ssh      # SSH's into an already booted image in a VM (test SSH?)
mkosi burn <device> # Deploy image to a block device
```

- To quit a vm `Ctrl+C`+`A` then type `quit`
- To quit from `mkosi boot` type `CTRL+]` three times in a row
