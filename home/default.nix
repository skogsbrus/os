{ config, ... }:
{
  imports = [
    ./client.nix
    ./cli.nix
    ./dev.nix
    ./gnome.nix
    ./kitty.nix
    ./lsp.nix
    ./neovim.nix
    ./photo_organizer
  ];

  config = {
    home.stateVersion = "22.11"; # TODO(bump-22.11): replace with some form of config.system.stateVersion
  };
}
