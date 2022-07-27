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
      extraPackages = with pkgs; [ bitwig-studio4 ];
    };
    dev = {
      aws = true;
      cuda = true;
      cxx = true;
      terraform = true;
    };
    gnome.enable = true;
    kitty.enable = true;
    lspServers = {
      enable = true;
      enableAll = true;
    };
    neovim.awWatcher = false;
  };
}
