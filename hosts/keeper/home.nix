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
      tmuxBgColor = "blue";
      tmuxFgColor = "white";
    };

    lspServers = {
      enable = true;
      enableAll = true;
    };

    neovim = {
      allGrammars = true;
    };
  };
}
