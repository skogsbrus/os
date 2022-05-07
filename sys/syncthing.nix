{ pkgs, ... }:
{
  services = {
    syncthing = {
      enable = false;
      user = "johanan";
      dataDir = "/home/johanan/syncthing";
      configDir = "/home/johanan/syncthing/.config/syncting";
    };
  };
}
