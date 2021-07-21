{ pkgs, ... }:
{
  imports =
    [
      ./zsh.nix
      ./tmux.nix
      ./neovim.nix
      ./steam.nix
    ];

  nixpkgs.config.allowUnfree = true;
  home-manager.packages = [
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

    # build tools
    pkgs.cmake
    pkgs.gnumake
    pkgs.

    # media
    pkgs.ncspot # spotify
    pkgs.gimp
    pkgs.vlc
    pkgs.peek
    pkgs.spotify

    # web
    #pkgs.google-chrome
    pkgs.chromium

    # gnome
    #pkgs.gnomeExtensions.material-shell
    #pkgs.gnome.gnome-tweaks
    #pkgs.gnome.gnome-shell-extensions
  ];
  programs.fzf = {
    enable = true;
    # TODO: vim/shell integration?
  };
  #gtk = {
  #  enable = true;
  #  font.name = "Victor Mono SemiBold 10";
  #  theme = {
  #    name = "Numix";
  #    package = pkgs.numix-gtk-theme;
  #  };
  #};
}
