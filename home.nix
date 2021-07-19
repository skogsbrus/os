{ pkgs, ... }:
{
  imports =
    [
      <home-manager/nixos>
      ./zsh.nix
      ./tmux.nix
      ./neovim.nix
      ./steam.nix
      ./syncthing.nix
    ];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.johanan = {
    isNormalUser = true;
    extraGroups = [ "wheel"  "networkmanager" "docker" ]; # wheel -> sudo
  };

  users.extraUsers.johanan = {
    shell = pkgs.zsh;
  };

  home-manager.users.johanan = { pkgs, ... }: {
    nixpkgs.config.allowUnfree = true;
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

      # build tools
      pkgs.cmake
      pkgs.gnumake
      pkgs.

      # media
      pkgs.ncspot # spotify
      pkgs.gimp
      pkgs.vlc
      pkgs.peek

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
    gtk = {
      enable = true;
      font.name = "Victor Mono SemiBold 10";
      theme = {
        name = "Numix";
        package = pkgs.numix-gtk-theme;
      };
    };
  };
}
