{ pkgs, ... }:
{

  users.users.johanan = {
    extraGroups = [ "input" ];
  };

  programs.steam.enable = true;
  hardware.steam-hardware.enable = true;
}
