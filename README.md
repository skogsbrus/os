# OS dotfiles for NixOS

This repository attempts to track & configure (most of) my digital devices.

## Structure

- Hardware and device-specific configurations are tracked in `hosts`. Each file in that directory represents one device.
- `flake.nix` is the entrypoint and root configuration for all hosts. Running `make` will automatically rebuild & switch configuration for the relevant host (based on hostname).
- `make install` will install dotfiles that aren't managed declaratively with Nix.
- The `home` directory comprises services & packages managed by home-manager.
- The `sys` directory comprises system services & packages.
- Many folders have a `client.nix`, and a `server.nix` file:
    - `client.nix`: Services & packages only required by devices with a graphical user interface.
    - `server.nix`: Services & packages only required by "servers", i.e. devices only reachable over serial or ssh.
