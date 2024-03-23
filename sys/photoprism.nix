{ config
, pkgs
, lib
, ...
}:
let
  cfg = config.skogsbrus.photoprism;
  inherit (lib) mkOption types mkIf mkEnableOption;
in
{
  options.skogsbrus.photoprism = {
    enable = mkEnableOption "photoprism";

    openFirewall = mkEnableOption "Open a port in the firewall";

    readonly = mkEnableOption "Enables readonly mode";

    enableTensorflow = mkEnableOption "Enables Tensorflow";

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

    adminUser = mkOption {
      type = types.str;
      example = "bob";
      description = "Admin login username";
    };

    adminUserPassword = mkOption {
      type = types.str;
      example = "bob";
      description = "Initial admin password (8+ characters)";
    };

    group = mkOption {
      type = types.str;
      example = "users";
      description = "Group that should run the service";
    };

    originalsPath = mkOption {
      type = types.str;
      example = "/foo/bar";
      description = "storage path of your original media files (photos and videos)";
    };

    importPath = mkOption {
      type = types.str;
      example = "/foo/bar";
      description = "base path from which files can be imported to originals";
    };

    storagePath = mkOption {
      type = types.str;
      example = "/foo/bar";
      description = "writable storage path for sidecar, cache, and database files";
    };

    httpUrl = mkOption {
      type = types.str;
      example = "foobar.local";
      description = "Site url";
    };

    httpPort = mkOption {
      type = types.int;
      default = 2342;
      example = 1337;
      description = "HTTP Port";
    };
  };

  config = mkIf cfg.enable {
    systemd.services.photoprism = {
      wantedBy = [ "default.target" ];
      wants = [ "graphical-session.target" ];
      description = "Start Photoprism";
      unitConfig = {
        StartLimitInterval = 200;
        StartLimitBurst = 5;
      };
      serviceConfig = {
        User = cfg.user;
        Group = cfg.group;
        ExecStart = "${pkgs.photoprism}/bin/photoprism start";
        Restart = "always";
        RestartSec = 10;
        Environment = [
          "PHOTOPRISM_DATABASE_DRIVER=mysql"
          # TODO: don't use default socket
          "PHOTOPRISM_DATABASE_SERVER=/run/mysqld/mysqld.sock"
          "PHOTOPRISM_DATABASE_USER=${cfg.user}"
          "PHOTOPRISM_AUTH_MODE=password"
          "PHOTOPRISM_ADMIN_USER='${cfg.adminUser}'"
          "PHOTOPRISM_ADMIN_PASSWORD='${cfg.adminUserPassword}'"
          "PHOTOPRISM_ORIGINALS_PATH='${cfg.originalsPath}'"
          "PHOTOPRISM_STORAGE_PATH='${cfg.storagePath}'"
          "PHOTOPRISM_HTTP_MODE=release"
          "PHOTOPRISM_IMPORT_PATH='${cfg.importPath}'"
          "PHOTOPRISM_HTTP_COMPRESSION=gzip"
          "PHOTOPRISM_READONLY=${(if cfg.readonly then "true" else "false")}"
          "PHOTOPRISM_DETECT_NSFW=${(if cfg.enableTensorflow then "true" else "false")}"
          "PHOTOPRISM_SITE_AUTHOR=skogsbrus"
          "PHOTOPRISM_SITE_URL='${cfg.httpUrl}:${toString cfg.httpPort}'"
          "PHOTOPRISM_HTTP_PORT='${toString cfg.httpPort}'"
          "PHOTOPRISM_DISABLE_TENSORFLOW=${(if cfg.enableTensorflow then "false" else "true")}"
        ];
      };
    };

    # TODO: move to separate module
    services.mysql = {
      enable = true;
      package = pkgs.mariadb_1011;
      user = cfg.user;
      group = cfg.group;
      dataDir = "/var/lib/mysql";
      # TODO: don't use default socket
      ensureUsers = [
        {
          name = cfg.user;
          ensurePermissions = {
            "*.*" = "ALL PRIVILEGES";
          };
        }
      ];
    };

    systemd.services.photoprism_index = {
      enable = true;
      description = "Index existing photos";
      serviceConfig = {
        User = cfg.user;
        Group = cfg.group;
        ExecStart = "${pkgs.photoprism}/bin/photoprism index --cleanup";
        Environment = [
          "PHOTOPRISM_ORIGINALS_PATH='${cfg.originalsPath}'"
          "PHOTOPRISM_STORAGE_PATH='${cfg.storagePath}'"
          "PHOTOPRISM_IMPORT_PATH='${cfg.importPath}'"
          "PHOTOPRISM_READONLY=${(if cfg.readonly then "true" else "false")}"
          "PHOTOPRISM_DETECT_NSFW=${(if cfg.enableTensorflow then "true" else "false")}"
          "PHOTOPRISM_DISABLE_TENSORFLOW=${(if cfg.enableTensorflow then "false" else "true")}"
          "PHOTOPRISM_DATABASE_DRIVER=mysql"
          # TODO: don't use default socket
          "PHOTOPRISM_DATABASE_SERVER=/run/mysqld/mysqld.sock"
          "PHOTOPRISM_DATABASE_USER=${cfg.user}"
          "PHOTOPRISM_AUTH_MODE=password"
          "PHOTOPRISM_ADMIN_USER='${cfg.adminUser}'"
          "PHOTOPRISM_ADMIN_PASSWORD='${cfg.adminUserPassword}'"
        ];
      };
      startAt = "daily";
    };

    networking.firewall = mkIf cfg.openFirewall {
      allowedTCPPorts = [
        cfg.httpPort
      ];
    };
  };
}
