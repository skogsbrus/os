{ pkgs, unstable, ... }:
{
  # Packages to be installed on user-facing machines
  # Most of these will be graphical applications.

  imports = [
    ./alacritty.nix
    ./kitty.nix
    ./gnome.nix
    ./dconf.nix
  ];

  home.packages = with pkgs; [
    chromium
    dconf2nix # syntax converter: dconf -> home manager
    element-desktop
    discord
    firefox
    gimp
    libreoffice
    mixxx
    peek
    picocom
    sc-controller
    slack
    spotify
    vlc
    vscode
    xclip

    # Local packages (unpublished)
    #(pkgs.callPackage pkgs/webex {})
    (pkgs.callPackage ./activitywatch { })
  ];
}
