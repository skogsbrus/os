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
      corporate = true;
    };

    dev = {
      enable = true;
      aws = true;
      corporate = true;
      cuda = true;
      cxx = true;
      k8s = true;
      terraform = true;
    };

    firefox.enable = true;
    gnome.enable = true;

    lspServers = {
      enable = true;
      enableAll = true;
    };
  };
}
