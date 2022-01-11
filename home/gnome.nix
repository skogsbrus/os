{ pkgs, ... }:
{
  gtk = {
    enable = true;
    #font.name = "Victor Mono SemiBold 10";
    theme = {
      name = "Numix";
      package = pkgs.numix-gtk-theme;
    };
  };
  home.packages = [
    pkgs.gnome.gnome-tweaks
    pkgs.gnome.pomodoro
    pkgs.gnomeExtensions.bluetooth-quick-connect
    pkgs.gnomeExtensions.sound-output-device-chooser
    pkgs.gnomeExtensions.material-shell
    pkgs.gnomeExtensions.tray-icons-reloaded
  ];
}
