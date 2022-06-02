{ config, pkgs, ... }:
{
  services.grafana = {
    enable = true;
    port = 8000;
    addr = "0.0.0.0";
    dataDir = "/var/lib/grafana";
  };
}
