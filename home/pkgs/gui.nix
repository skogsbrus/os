{ pkgs, unstable, ... }:
{
  home.packages = [
    pkgs.chromium
    pkgs.dconf2nix # syntax converter: dconf -> home manager
    pkgs.element-desktop
    pkgs.gimp
    pkgs.libreoffice
    pkgs.mixxx
    pkgs.peek
    pkgs.sc-controller
    pkgs.slack
    pkgs.spotify
    pkgs.vlc
    pkgs.vscode
    pkgs.firefox
    pkgs.alacritty
    pkgs.xclip

    # Local packages (unpublished)
    #(pkgs.callPackage pkgs/webex {})
  ];
}
