{ config
, lib
, ...
}:
let
  cfg = config.skogsbrus.syncthing;
  port = "8384";
  url = "syncthing.${config.skogsbrus.caddy.publicUrl}";
  inherit (lib) mkEnableOption mkOption mkIf types;
in
{
  options.skogsbrus.syncthing = {
    enable = mkEnableOption "syncthing";
    enableCaddy = mkEnableOption "expose service through caddy";
    guiAddress = mkOption {
      description = "GUI address";
      type = types.str;
      example = "foo.bar.com";
    };
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
        guiAddress = if cfg.enableCaddy then "0.0.0.0:${port}" else "127.0.0.1:${port}";
      };
    };

    networking.firewall = {
      allowedTCPPorts = [
        22000 # Syncthing protocol
      ];
      allowedUDPPorts = [
        21027 # Syncthing protocol
      ];
    };

    services.caddy.virtualHosts = mkIf cfg.enableCaddy {
      "syncthing.${config.skogsbrus.caddy.publicUrl}" = {
        extraConfig = ''
          forward_auth localhost:9999 {
              uri /api/verify?rd=https://auth.${config.skogsbrus.caddy.publicUrl}/
              copy_headers Remote-User Remote-Groups Remote-Name Remote-Email
          }
          reverse_proxy localhost:${port} { }
        '';
      };
    };
  };
}
