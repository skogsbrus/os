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
    shell = {
      zsh = true;
      tmux = true;
      tmuxBgColor = "orange";
      tmuxFgColor = "black";
    };

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
    firefox.enable = true;
    gnome.enable = true;
    lspServers = {
      enable = true;
      enableAll = true;
    };
    neovim.awWatcher = false;
  };
}
