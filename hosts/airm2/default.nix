{ pkgs, lib, ... }:
{
  users.users.johanan = {
    name = "johanan";
    home = "/Users/johanan";
  };

  imports = [
    ../../sys/keyboard/darwin
  ];

  # IMPORTANT!
  programs.zsh.enable = true;

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "copilot.vim"
  ];

  system.stateVersion = 5;
  ids.gids.nixbld = 30000;

  security.pam.services.sudo_local = {
    text = "auth sufficient pam_tid.so";
  };
}
