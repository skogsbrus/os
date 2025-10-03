{ config
, unstable
, pkgs
, lib
, skogsbrus
, ...
}:
let
  cfg = config.skogsbrus.immich;
  inherit (lib) mkOption types mkIf mkEnableOption;
in
{
  options.skogsbrus.immich = {
    enable = mkEnableOption "immich";

    originalsPath = mkOption {
      type = types.str;
      example = "/foo/bar";
      description = "storage path of your original media files (photos and videos)";
    };

    storagePath = mkOption {
      type = types.str;
      example = "/foo/bar";
      description = "writable storage path for sidecar, cache, and database files";
    };

    httpPort = mkOption {
      type = types.int;
      default = 5555;
      example = 1337;
      description = "HTTP Port";
    };
  };

  config = mkIf cfg.enable {
    systemd.services."immich-symlink" = {
      description = "Creates a symlink for immich's library directory";
      before = [ "immich-server.service" ];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pkgs.coreutils}/bin/ln -sfn ${cfg.originalsPath}/immich ${cfg.storagePath}/library";
      };
      wantedBy = [ "multi-user.target" ];
    };
    services.immich = {
        enable = true;
        port = cfg.httpPort;
        mediaLocation = cfg.storagePath;
        package = with unstable.legacyPackages.${pkgs.system}; immich;
        settings = {
          server = {
            externalDomain = "https://share.media.vpn.skogsbrus.xyz";
          };
        };
    };
  };
}
