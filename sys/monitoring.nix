{ config, pkgs, ... }:
{
  # https://xeiaso.net/blog/prometheus-grafana-loki-nixos-2020-11-20
  services.grafana = {
    enable = true;
    port = 8888;
    addr = "0.0.0.0";
    dataDir = "/var/lib/grafana";
  };

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
        job_name = "chrysalis";
        static_configs = [{
          targets = [ "127.0.0.1:${toString config.services.prometheus.exporters.node.port}" ];
        }];
      }
    ];
  };
}
