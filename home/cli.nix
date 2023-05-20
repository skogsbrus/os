{ config
, lib
, pkgs
, ...
}:
let
  cfg = config.skogsbrus.cli;
  inherit (lib) mkOption mkEnableOption types;
  linuxPackages = with pkgs; [
    iputils    # Not supported on Darwin (22-05-19)
    traceroute # Not supported on Darwin (22-05-19)
    usbutils   # Not supported on Darwin (22-05-19)
    iw         # Not supported on Darwin (22-05-19)
  ];
in
{
  config = {
    # Things I want to have on all machines, regardless of their purpose
    home.packages = with pkgs; [
      # networking
      arp-scan
      curl
      dig
      iperf
      mtr
      openssl
      wget

      # build tools
      gnumake

      # dev tools
      git
      vim
      python3

      # monitoring
      htop
      pciutils

      # cli tools
      jq
      man-db
      man-pages
      ranger
      ripgrep
      tig
      tmux

      # misc
      zsh
    ] ++ (if stdenv.isLinux then linuxPackages else []);


    programs.fzf = {
      enable = true;
    };

    programs.atuin = {
      enable = true;
      enableZshIntegration = true;
    };

    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };
}
