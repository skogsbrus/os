{ pkgs, unstable, ... }:
{
  # Packages to be installed on user-facing machines
  # Most of these will be graphical applications.

  home.packages = with pkgs; [
    alacritty
    chromium
    dconf2nix # syntax converter: dconf -> home manager
    element-desktop
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
  ];
}
