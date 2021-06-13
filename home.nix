
{ pkgs, ... }:

{
  imports = [ <home-manager/nixos> ];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.johanan = {
    isNormalUser = true;
    extraGroups = [ "wheel"  "networkmanager" "docker" ]; # wheel -> sudo
  };

  users.extraUsers.johanan = {
    shell = pkgs.zsh;
  };

  programs.zsh.enable = true;

  home-manager.users.johanan = { pkgs, ... }: {
    home.packages = [
      pkgs.neovim
      pkgs.gimp
      pkgs.zsh
      pkgs.docker
      pkgs.kubectl
      pkgs.vlc
      pkgs.ripgrep
    ];
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
