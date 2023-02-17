{ config
, pkgs
, lib
, ...
}:
let
  cfg = config.skogsbrus.miniflux;
  inherit (lib) mkOption types mkIf mkEnableOption;
in
{
  options.skogsbrus.miniflux = {
    enable = mkEnableOption "miniflux";

    port = mkOption {
      type = types.int;
      example = 1234;
      description = "Port to expose the service on";
    };

    openFirewall = mkOption {
      type = types.bool;
      default = false;
      description = lib.mdDoc ''
        Open the default ports in the firewall for the media server. The
        HTTP/HTTPS ports can be changed in the Web UI, so this option should
        only be used if they are unchanged.
      '';
    };

  };

  config = mkIf cfg.enable {
    services.miniflux = {
      enable = true;
      config = {
        LISTEN_ADDR = "0.0.0.0:${toString cfg.port}";
      };
      adminCredentialsFile = "/home/johanan/os/secrets/miniflux.env";
    };

    networking.firewall = mkIf cfg.openFirewall {
      allowedTCPPorts = [ 5656 ];
    };
  };
}
