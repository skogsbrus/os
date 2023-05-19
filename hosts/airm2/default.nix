{ pkgs, ... }:
{
  services.nix-daemon.enable = true;
  programs.zsh.enable = true;
}
