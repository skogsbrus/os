{ config
, lib
, pkgs
, ...
}:
let
  cfg = config.skogsbrus.networking;
  inherit (lib) mkEnableOption mkOption mkIf types;
in
{
  options.skogsbrus.networking = {
    enableNetworkManager = mkEnableOption "networkmanager";
    trustedInterfaces = mkOption {
      type = types.listOf types.str;
      default = [ ];
      example = "wlan0";
      description = "Network interfaces to allow any traffic from";
    };
  };

  config = {
    networking.firewall.trustedInterfaces = cfg.trustedInterfaces;

    networking.networkmanager.enable = cfg.enableNetworkManager;
    programs.nm-applet.enable = cfg.enableNetworkManager;

    environment.systemPackages = with pkgs; [
      curl
      dig
      openssl
      wget
    ];
  };
}
