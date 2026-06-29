{ pkgs, lib, ... }:
{
  users.users.johanan = {
    name = "johanan";
    home = "/Users/johanan";
  };

  nix.settings.experimental-features = "nix-command flakes";
  nix.settings.extra-nix-path = "nixpkgs=flake:nixpkgs";

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
   "copilot.vim"
  ];

  # IMPORTANT!
  programs.zsh.enable = true;

  system.stateVersion = 5;

  security.pam.services.sudo_local = {
    text = "auth sufficient pam_tid.so";
  };
}
