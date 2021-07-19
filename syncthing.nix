{ pkgs, ... }:
{
  services = {
    syncthing = {
      enable = true;
      user = "johanan";
      dataDir = "/home/johanan/syncthing";
      configDir = "/home/johanan/syncthing/.config/syncting";
    };
  };
}
