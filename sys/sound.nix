{ config
, lib
, pkgs
, ...
}:
let
  cfg = config.skogsbrus.sound;
  inherit (lib) mkIf mkOption mkEnableOption types;
in
{
  options.skogsbrus.sound = {
    enable = mkEnableOption "sound";
    channels = mkOption {
      type = types.number;
      example = 4;
      default = 2;
      description = "Number of channels";
    };
    enablePipewire = mkEnableOption "pipewire";
  };
  config = {
    hardware.pulseaudio = {
      enable = cfg.enable && ! cfg.enablePipewire;
      extraConfig = ''
        default-sample-channels=${toString cfg.channels}
      '';
    };

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
