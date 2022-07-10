{ config
, lib
, pkgs
, ...
}:
let
  cfg = config.skogsbrus.gnome;
  inherit (lib) types mkIf mkOption mkEnableOption;
in
{
  options.skogsbrus.gnome = {
    enable = mkEnableOption "GNOME";
  };
  config = mkIf cfg.enable {
    gtk = {
      enable = true;
      theme = {
        name = "Numix";
        package = pkgs.numix-gtk-theme;
      };
    };
    home.packages = with pkgs; [
      gnome.gnome-tweaks
      gnome.pomodoro
      gnomeExtensions.bluetooth-quick-connect
      gnomeExtensions.sound-output-device-chooser
      gnomeExtensions.material-shell
      gnomeExtensions.tray-icons-reloaded
    ];
  };
}
