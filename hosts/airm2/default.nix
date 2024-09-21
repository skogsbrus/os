{ pkgs, ... }:
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
}
