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
    dev = {
      enable = true;
      aws = true;
      cxx = true;
      k8s = true;
      terraform = true;
    };
    lspServers = {
      enable = true;
      enableAll = true;
    };
    darwin = {
      enable = true;
    };
  };
}
