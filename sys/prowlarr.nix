{ config
, pkgs
, lib
, ...
}:
let
  cfg = config.skogsbrus.prowlarr;
  inherit (lib) mkOption types mkIf mkEnableOption;
in
{
  options.skogsbrus.prowlarr = {
    enable = mkEnableOption "prowlarr";
    openFirewall = mkEnableOption "Open a port in the firewall";

  };

  config = mkIf cfg.enable {
    services.prowlarr = {
      enable = true;
      openFirewall = cfg.openFirewall;
    };
  };
}
