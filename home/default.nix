{ pkgs, ... }:
{
  imports = [
    ./dconf.nix
    ./gnome.nix
    ./neovim.nix
    ./packages.nix
  ];
}
