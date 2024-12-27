{ pkgs, lib, ... }:
{
  users.users.johanan = {
    name = "johanan";
    home = "/Users/johanan";
  };

  services.nix-daemon.enable = true;

  imports = [
    ../../sys/keyboard/darwin
  ];

  # IMPORTANT!
  programs.zsh.enable = true;

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "copilot.vim"
  ];

  system.stateVersion = 5;
}
