{ ... }:
{
  imports = [
    ./hardware.nix
    ./system.nix
  ];

  programs.zsh.enable = true;
}
