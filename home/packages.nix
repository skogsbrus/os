{ pkgs, ... }:
{
  home.packages = [
    # dev-tools
    pkgs.aws-vault
    pkgs.awscli
    pkgs.coz
    pkgs.dconf2nix # syntax converter: dconf -> home manager
    pkgs.docker
    pkgs.gdb
    pkgs.kubectl
    pkgs.postgresql
    pkgs.ranger
    pkgs.ripgrep
    pkgs.tig
    pkgs.valgrind
    pkgs.vscode
    pkgs.zsh
    pkgs.arp-scan

    # Language servers
    pkgs.clang-tools # clangd included
    pkgs.cmake-language-server
    pkgs.elixir_ls
    pkgs.pyright
    pkgs.rnix-lsp
    pkgs.solargraph

    # build tools
    pkgs.cmake
    pkgs.gcc
    pkgs.gnumake

    # media
    pkgs.gimp
    pkgs.peek
    pkgs.spotify
    pkgs.vlc
    pkgs.mixxx

    # Local packages (unpublished)
    (pkgs.callPackage pkgs/webex {})

    # web
    pkgs.chromium
    pkgs.element-desktop
    pkgs.slack

    # gnome
    pkgs.gnome.gnome-tweaks
    pkgs.gnome.pomodoro
    pkgs.gnomeExtensions.bluetooth-quick-connect
    pkgs.gnomeExtensions.sound-output-device-chooser

    # tooling
    pkgs.wineWowPackages.stable # 32- and 64-bit
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
