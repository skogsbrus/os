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
    shell = {
      zsh = true;
      tmux = true;
      tmuxBgColor = "red";
      tmuxFgColor = "black";
    };

    lspServers = {
      enable = true;
    };
  };
}
