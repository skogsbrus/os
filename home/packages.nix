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
    pkgs.ncspot # spotify
    pkgs.gimp
    pkgs.vlc
    pkgs.peek
    pkgs.spotify

    # Webex from local package (unpublished)
    (pkgs.callPackage ../local-pkgs/webex.nix {})

    # web
    pkgs.chromium
    pkgs.element-desktop
    pkgs.slack

    # gnome
    pkgs.gnome.gnome-tweaks
    #pkgs.gnome.gnome-shell-extensions
    pkgs.gnomeExtensions.sound-output-device-chooser
    pkgs.gnomeExtensions.bluetooth-quick-connect
  ];
  programs.fzf = {
    enable = true;
    # TODO: vim/shell integration?
  };
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    nix-direnv.enableFlakes = true;
  };
}
