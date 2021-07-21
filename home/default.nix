{ pkgs, ... }:
{
    home.packages = [
      # dev-tools
      pkgs.tig
      pkgs.zsh
      pkgs.kubectl
      pkgs.docker
      pkgs.ripgrep
      pkgs.direnv
      pkgs.gdb
      pkgs.valgrind
      pkgs.ranger
      pkgs.vscode

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

      # gnome
      #pkgs.gnome.gnome-tweaks
      #pkgs.gnome.gnome-shell-extensions
    ];
    programs.fzf = {
      enable = true;
      # TODO: vim/shell integration?
    };
    gtk = {
      enable = true;
      #font.name = "Victor Mono SemiBold 10";
      theme = {
        name = "Numix";
        package = pkgs.numix-gtk-theme;
      };
    };
}
