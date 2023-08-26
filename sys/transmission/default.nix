{ config
, pkgs
, lib
, ...
}:
let
  rmUnregisteredTorrents = (pkgs.callPackage ./rm_unregistered_torrents.nix { });
  cfg = config.skogsbrus.transmission;
  inherit (lib) mkOption types mkIf mkEnableOption;
in
{
  options.skogsbrus.transmission = {
    enable = mkEnableOption "transmission";
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

    rmUnregisteredTorrents = mkEnableOption "remove unregistered torrents";

  };

  config = mkIf cfg.enable {
    services.transmission = {
      enable = true;
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
      credentialsFile = "/home/johanan/code/os/secrets/transmission.json";
    };

    environment.systemPackages = mkIf cfg.rmUnregisteredTorrents [
      rmUnregisteredTorrents
    ];

    systemd.services.rm_unregistered_torrents = mkIf cfg.rmUnregisteredTorrents {
      enable = true;
      description = "Remove unregistered torrents";
      serviceConfig = {
        ExecStart = "${rmUnregisteredTorrents}/bin/rm_unregistered_torrents.py --host localhost --port 9091";
      };
      startAt = "daily";
    };
  };
}
