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
      atuin = false;
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
