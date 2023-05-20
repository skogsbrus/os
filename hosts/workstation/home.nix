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
      tmuxBgColor = "green";
      tmuxFgColor = "black";
    };

    client = {
      enable = true;
      extraPackages = with pkgs; [ bitwig-studio4 ];
      activitywatch = true;
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

    neovim.awWatcher = true;
  };
}
