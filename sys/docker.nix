{ pkgs, ... }:
{
  users.users.johanan = {
    extraGroups = [ "docker" ];
  };
  virtualisation.docker.enable = true;
  virtualisation.docker.enableNvidia = true;
}
