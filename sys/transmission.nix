{ config
, pkgs
, lib
, ...
}:
let
  cfg = config.skogsbrus.radarr;
  inherit (lib) mkOption types mkIf mkEnableOption;
in
{
  options.skogsbrus.radarr = {
    enable = mkEnableOption "radarr";
    openFirewall = mkEnableOption "Open a port in the firewall";

    address = mkOption {
      type = types.str;
      example = "/tmp/foo/bar";
      description = "Domain name address to allow access from";
    };

    downloadDir = mkOption {
      type = types.str;
      example = "/tmp/foo/bar";
      description = "Download directory";
    };

    user = mkOption {
      type = types.str;
      example = "bob";
      description = "User that should run the service";
    };

    group = mkOption {
      type = types.str;
      example = "users";
      description = "Group that should run the service";
    };

  };

  config = mkIf cfg.enable {
    services.transmission = {
      user = cfg.user;
      group = cfg.group;
      openRPCPort = cfg.openFirewall;
      settings = {
        rpc-bind-address = (if cfg.openFirewall then "0.0.0.0" else "127.0.0.1");
        rpc-whitelist-enabled = false;
        rpc-host-whitelist = cfg.address;
        download-dir = cfg.downloadDir;
        incomplete-dir-enabled = false;
      };
    };
  };
}
