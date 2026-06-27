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
    age.secrets.grafana = {
      file = ../secrets/grafana.age;
      owner = "root";
      group = "root";
      mode = "400";
    };
    services.grafana = {
      enable = true;
      settings = {
        server = {
          http_port = 8888;
          http_addr = "0.0.0.0";
        };
        security = {
          secret_key = "$__file{${config.age.secrets.grafana.path}}";
        };
      };
      dataDir = "/var/lib/grafana";
    };
  };
}
