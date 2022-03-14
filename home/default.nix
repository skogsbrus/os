{ pkgs, ... }:
{
  imports = [
    ./neovim.nix
    ./packages.nix
  ];

  programs.autorandr.enable = true;
}
