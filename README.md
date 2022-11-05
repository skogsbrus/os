# OS dotfiles for NixOS

This repository configures all of my digital devices that run ✨ NixOS ✨ !

## Help

This repository can be useful if you're relatively experienced with NixOS and
are looking for inspiration. If you are a complete beginner, I recommend
looking elsewhere first:

- https://nix.dev/
- https://nixos.org/manual/nixos/stable/
- https://ianthehenry.com/posts/how-to-learn-nix/
- https://xeiaso.net/blog/nix-flakes-1-2022-02-21
- https://xeiaso.net/blog/nix-flakes-2-2022-02-27
- https://xeiaso.net/blog/nix-flakes-3-2022-04-07

## Structure

### Hosts

A machine, such as a server or laptop, is called a *host*.

Host configurations live in the [hosts](./hosts) directory. The configuration of a  host is comprised of three parts:

1. a hardware configuration
2. a system configuration
3. a home configuration

All of these files are imported by [./flake.nix](./flake.nix).

### System services, apps, ...

Software installed on a system-level is configured in [sys](./sys). All files here are [NixOS modules](https://nixos.org/manual/nixos/stable/index.html#sec-writing-modules) and their configuration options are namespaced under `skogsbrus`. Hosts declare and configure their system modules in `./hosts/<hostname>/system.nix`.

### User services, apps, ...

Software and configuration files in user-land live in [home](./home) and is configured by [Home Manager](https://github.com/nix-community/home-manager) and are for the most part also NixOS modules.

## Adding a new device

1. Add it to `flake.nix`.
2. Add a new folder in [hosts](./hosts) with a hardware, system, and home configuration.
3. Run `make`.
4. Done!

Note that the hostname of the new device must match the name of the host in [./flake.nix](./flake.nix).
