{ pkgs, ... }:
{
  imports =
    [
      <home-manager/nixos>
      ./zsh.nix
      ./tmux.nix
      ./neovim.nix
      ./steam.nix
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
    home.packages = [
      pkgs.tig
      pkgs.gimp
      pkgs.zsh
      pkgs.docker
      pkgs.kubectl
      pkgs.vlc
      pkgs.ripgrep
      pkgs.direnv
      pkgs.gnomeExtensions.material-shell
      pkgs.gnome.gnome-tweaks
      pkgs.gnome.gnome-shell-extensions
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
