{ pkgs, ... }:
{
  imports = [
    ./dconf.nix
    ./gnome.nix
    ./pkgs
  ];
}
