{ config, ... }:
{
  imports = [
    ./client.nix
    ./cli.nix
    ./dev.nix
    ./firefox.nix
    ./gnome.nix
    ./lsp.nix
    ./neovim.nix
  ];

  config = {
    home.stateVersion = "22.11"; # TODO(bump-22.11): replace with some form of config.system.stateVersion
  };
}
