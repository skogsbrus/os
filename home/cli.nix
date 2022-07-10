{ config
, lib
, pkgs
, ...
}:
let
  cfg = config.skogsbrus.cli;
  inherit (lib) mkOption types;
in
{
  options.skogsbrus.cli = { };

  config = {
    # Things I want to have on all machines, regardless of their purpose
    home.packages = with pkgs; [
      # networking
      arp-scan
      curl
      dig
      iperf
      iw
      mtr
      openssl
      iputils
      traceroute
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
      usbutils
      zsh
    ];

    programs.fzf = {
      enable = true;
    };

    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };
}
