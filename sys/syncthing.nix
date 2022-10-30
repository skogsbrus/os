{ config
, lib
, ...
}:
let
  cfg = config.skogsbrus.syncthing;
  port = "8384";
  inherit (lib) mkEnableOption mkOption mkIf types;
in
{
  options.skogsbrus.syncthing = {
    enable = mkEnableOption "syncthing";
    expose = mkEnableOption "make GUI available on all interfaces";
    user = mkOption {
      description = "User to run the service under";
      type = types.str;
      example = "bob";
    };
  };

  config = mkIf cfg.enable {
    services = {
      syncthing = {
        enable = true;
        user = cfg.user;
        dataDir = "/home/${cfg.user}/syncthing";
        configDir = "/home/${cfg.user}/syncthing/.config/syncting";
        guiAddress = if cfg.expose then "0.0.0.0:${port}" else "127.0.0.1:${port}";
      };
    };
    networking.firewall = {
      allowedTCPPorts = [
        8384 # Syncthing GUI
        22000 # Syncthing protocol
      ];
      allowedUDPPorts = [
        21027 # Syncthing protocol
      ];
    };
  };
}
