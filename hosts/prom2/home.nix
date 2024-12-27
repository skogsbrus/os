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

    shell = {
      zsh = true;
      tmux = true;
      atuin = false;
      tmuxBgColor = "yellow";
      tmuxFgColor = "black";
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
