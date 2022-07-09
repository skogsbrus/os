# OS dotfiles for NixOS

This repository attempts to track & configure (most of) my digital devices.

## Structure

### Hosts

Host configurations live in [hosts](./hosts). A host is a combination of two things:

1. a hardware configuration
2. a software configuration

### System services, apps, ...

Software installed on a system-level is configured in [sys](./sys). All files here are [NixOS modules](https://nixos.org/manual/nixos/stable/index.html#sec-writing-modules) and their configuration options are namespaced under `skogsbrus`.

### User services, apps, ...

Software running on in user-land lives in [home](./home) and is configured by [Home Manager](https://github.com/nix-community/home-manager).

TODO: configure it like [sys](./sys) with NixOS modules.

## Adding a new device

1. Add it to `flake.nix`.
2. Add a new folder in [hosts](./hosts) with a hardware and software configuration
3. Run `make`
4. Done!
