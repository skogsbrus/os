{ pkgs, unstable, ... }:
{
  imports = [
    ./neovim.nix
  ];
  # Things I want to have on all machines, regardless of their purpose
  home.packages = with pkgs; [
    # networking
    arp-scan
    curl
    dig
    mtr
    openssl
    ping
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
    manpages
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
    nix-direnv.enableFlakes = true;
  };
}
