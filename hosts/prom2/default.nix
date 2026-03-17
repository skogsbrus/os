{ pkgs, lib, ... }:
{
  users.users.johanan = {
    name = "johanan";
    home = "/Users/johanan";
  };

  # IMPORTANT!
  programs.zsh.enable = true;
}
