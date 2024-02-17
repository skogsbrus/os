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

  home.packages = with pkgs; [
    openscad
  ];

  nix.package = lib.mkForce pkgs.nixFlakes;
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';
  nixpkgs.config.allowUnfree = true;

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
      autoDarkMode = true;
      allGrammars = true;
    };
  };
}
