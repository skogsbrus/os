{ config, pkgs, ... }:
{
  services.grafana = {
    enable = true;
    port = 3001;
    domain = "localhost";
    protocol = "http";
    dataDir = "/var/lib/grafana";
  };
}
