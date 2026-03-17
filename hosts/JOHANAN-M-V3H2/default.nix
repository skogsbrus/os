{ pkgs, lib, ... }:
{
  users.users.johanan = {
    name = "johanan";
    home = "/Users/johanan";
  };

  nix.settings.experimental-features = "nix-command flakes";
  nix.settings.extra-nix-path = "nixpkgs=flake:nixpkgs";

  stdenv.hostPlatform.system.stateVersion = 5;

  # IMPORTANT!
  programs.zsh.enable = true;
}
