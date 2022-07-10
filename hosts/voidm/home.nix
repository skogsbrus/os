{ config
, lib
, pkgs
, modulesPath
, ...
}:
{
  imports = [
    ../../home
    ../../home/dconf.nix
  ];

  skogsbrus = {
    client = {
      enable = true;
      corporate = true;
    };
    dev = {
      aws = true;
      corporate = true;
      cuda = true;
      cxx = true;
      k8s = true;
      terraform = true;
    };
    gnome.enable = true;
    kitty.enable = true;
    lspServers = {
      enable = true;
      enableAll = true;
    };
    neovim.awWatcher = true;
  };
}
