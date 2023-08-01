{ pkgs, ... }:
{
  users.users.johanan = {
    name = "johanan";
    home = "/Users/johanan";
  };

  services.nix-daemon.enable = true;

  # IMPORTANT!
  programs.zsh.enable = true;
}
