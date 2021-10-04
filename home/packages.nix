{ pkgs, ... }:
{
  home.packages = [
    # dev-tools
    pkgs.tig
    pkgs.zsh
    pkgs.kubectl
    pkgs.docker
    pkgs.ripgrep
    pkgs.gdb
    pkgs.valgrind
    pkgs.ranger
    pkgs.vscode
    pkgs.awscli
    pkgs.aws-vault
    pkgs.dconf2nix # syntax converter: dconf -> home manager
    pkgs.postgresql

    # Language servers
    pkgs.pyright
    pkgs.elixir_ls
    pkgs.rnix-lsp
    pkgs.solargraph
    pkgs.cmake-language-server
    pkgs.clang-tools # clangd included

    # build tools
    pkgs.cmake
    pkgs.gnumake
    pkgs.gcc

    # media
    pkgs.gimp
    pkgs.vlc
    pkgs.peek
    pkgs.spotify

    # Local packages (unpublished)
    (pkgs.callPackage ../local-pkgs/webex {})

    # web
    pkgs.chromium
    pkgs.element-desktop
    pkgs.slack

    # gnome
    pkgs.gnome.gnome-tweaks
    pkgs.gnome.pomodoro
    pkgs.gnomeExtensions.sound-output-device-chooser
    pkgs.gnomeExtensions.bluetooth-quick-connect

    # misc
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
