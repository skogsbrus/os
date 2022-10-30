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
  };
}
