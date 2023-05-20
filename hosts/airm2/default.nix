{ pkgs, ... }:
{
  users.users.johanan = {
    name = "johanan";
    home = "/Users/johanan";
  };

  services.nix-daemon.enable = true;
  programs.zsh.enable = true;
}
