{ config
, pkgs
, lib
, ...
}:
let
  cfg = config.skogsbrus.grafana;
  inherit (lib) mkOption types mkIf mkEnableOption;
in
{
  options.skogsbrus.grafana = {
    enable = mkEnableOption "grafana";
  };

  config = mkIf cfg.enable {
    services.grafana = {
      enable = true;
      settings.server = {
        http_port = 8888;
        http_addr = "0.0.0.0";
      };
      dataDir = "/var/lib/grafana";
    };
  };
}
