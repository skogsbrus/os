{ pkgs, lib, ... }:
{
  users.users.johanan = {
    name = "johanan";
    home = "/Users/johanan";
  };

  nix.settings.experimental-features = "nix-command flakes";
  nix.settings.extra-nix-path = "nixpkgs=flake:nixpkgs";

  system.stateVersion = 5;
  services.nix-daemon.enable = true;

  # IMPORTANT!
  programs.zsh.enable = true;
}
