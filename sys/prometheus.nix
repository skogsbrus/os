{ config
, pkgs
, lib
, ...
}:
let
  cfg = config.skogsbrus.prometheus;
  inherit (lib) mkOption types mkIf mkEnableOption;
in
{
  options.skogsbrus.prometheus = {
    enable = mkEnableOption "prometheus";
  };

  config = mkIf cfg.enable {
    services.prometheus = {
      enable = true;
      port = 9990;
      exporters = {
        node = {
          enable = true;
          enabledCollectors = [ "systemd" ];
          port = 9991;
        };
      };
      scrapeConfigs = [
        {
          job_name = "systemd";
          static_configs = [{
            targets = [ "127.0.0.1:${toString config.services.prometheus.exporters.node.port}" ];
          }];
        }
      ];
    };
  };
}
