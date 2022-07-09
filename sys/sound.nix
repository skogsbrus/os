{ config
, lib
, pkgs
, ...
}:
let
  cfg = config.skogsbrus.sound;
  inherit (lib) mkIf mkEnableOption;
in
{
  options.skogsbrus.sound = {
    enable = mkEnableOption "sound";
    enablePipewire = mkEnableOption "pipewire";
  };
  config = {
    sound.enable = cfg.enable && ! cfg.enablePipewire;
    hardware.pulseaudio.enable = cfg.enable && ! cfg.enablePipewire;

    # This service is activated by default and needs pipewire
    services.gnome.gnome-remote-desktop.enable = cfg.enable && cfg.enablePipewire;

    # https://nixos.wiki/wiki/PipeWire
    security.rtkit.enable = true;
    services.pipewire = {
      enable = cfg.enable && cfg.enablePipewire;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };
  };
}
