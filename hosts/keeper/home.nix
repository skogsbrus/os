{ config
, lib
, pkgs
, modulesPath
, ...
}:
{
  imports = [
    ../../home
  ];

  skogsbrus = {
    lspServers = {
      enable = true;
      enableAll = true;
    };

    cli = {
      photo_organizer = true;
    };
  };
}
