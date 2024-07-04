{ config
, pkgs
, lib
, skogsbrus
, ...
}:
let
  cfg = config.skogsbrus.photoprism;
  importPath = "/mnt/import";
  storagePath = "/mnt/storage";
  originalsPath = "/mnt/originals";
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

      serviceConfig = skogsbrus.lib.secureSystemdServiceOptions {
        name = "photoprism";
        options = {
          # TODO: why doesn't this work without the bash wrapper? Complains about '--config' not receiving an argument
          #ExecStart = "${pkgs.bash}/bin/bash -c \"${authelia}/bin/authelia --config $CREDENTIALS_DIRECTORY/config.yaml\"";
          #LoadCredential = [
          #  "config.yaml:${config.age.secrets.authelia_cfg_yaml.path}"
          #];
          ExecStart = "${pkgs.photoprism}/bin/photoprism start";
          #ExecStart = "${pkgs.bash}/bin/bash -c 'ls -lt ${storagePath} ${$mportPath} ${originalsPath}'";
          Restart = "always";
          RestartSec = 10;

          Environment = [
            "PHOTOPRISM_DATABASE_DRIVER=mysql"
            # TODO: don't use default socket
            "PHOTOPRISM_DATABASE_SERVER=/run/mysqld/mysqld.sock"
            "PHOTOPRISM_DATABASE_USER=${cfg.user}"
            "PHOTOPRISM_DATABASE_PASSWORD=''"
            "PHOTOPRISM_AUTH_MODE=password"
            "PHOTOPRISM_ADMIN_USER='${cfg.adminUser}'"
            "PHOTOPRISM_ADMIN_PASSWORD='${cfg.adminUserPassword}'"
            "PHOTOPRISM_ORIGINALS_PATH='${originalsPath}'"
            "PHOTOPRISM_STORAGE_PATH='${storagePath}'"
            "PHOTOPRISM_HTTP_MODE=release"
            "PHOTOPRISM_IMPORT_PATH='${importPath}'"
            "PHOTOPRISM_HTTP_COMPRESSION=gzip"
            "PHOTOPRISM_READONLY=${(if cfg.readonly then "true" else "false")}"
            "PHOTOPRISM_DETECT_NSFW=${(if cfg.enableTensorflow then "true" else "false")}"
            "PHOTOPRISM_SITE_AUTHOR=skogsbrus"
            "PHOTOPRISM_SITE_URL='${cfg.httpUrl}:${toString cfg.httpPort}'"
            "PHOTOPRISM_HTTP_PORT='${toString cfg.httpPort}'"
            "PHOTOPRISM_DISABLE_TENSORFLOW=${(if cfg.enableTensorflow then "false" else "true")}"
          ];

          BindReadOnlyPaths = [
            "/nix/store"
            "${cfg.importPath}:${importPath}"
            "${cfg.originalsPath}:${originalsPath}"
          ];

          BindPaths = [
            "/run/mysqld" # Allow binding of mysqld
            "${cfg.storagePath}:${storagePath}"
          ];

          PrivateNetwork = false;
          RestrictAddressFamilies = [ "AF_INET" "AF_INET6" "AF_UNIX" ];

          # Needed by a dependency for ML models that use a JIT compiler
          MemoryDenyWriteExecute = false;
        };
      };
    };

    # TODO: move to separate module
    services.mysql = {
      enable = true;
      package = pkgs.mariadb_1011;
      dataDir = "/var/lib/mysql";
      # TODO: set this up with nix
      # sudo mysql
      # CREATE DATABASE photoprism;
      # CREATE USER photoprism@localhost IDENTIFIED BY '';
      # GRANT ALL PRIVILEGES ON photoprism.* TO photoprism@localhost;
      # FLUSH PRIVILEGES;
    };

    systemd.services.mysql = {
      serviceConfig = skogsbrus.lib.overrideSystemdServiceOptions {
        name = "mysqld";
        current = config.systemd.services.mysql.serviceConfig;
        options = {
          RestrictAddressFamilies = [ "AF_UNIX" ];
          PrivateUsers = false;
          BindPaths = [
            "/var/run/mysqld"
            "/run/mysqld"
            "/var/lib/mysql"
          ];
        };
      };
    };

    systemd.services.photoprism_index = {
      enable = true;
      description = "Index existing photos";
      startAt = "daily";

      serviceConfig = skogsbrus.lib.secureSystemdServiceOptions {
        name = "photoprism_index";
        options = {
          ExecStart = "${pkgs.photoprism}/bin/photoprism index --cleanup";
          Environment = [
            "PHOTOPRISM_ORIGINALS_PATH='${originalsPath}'"
            "PHOTOPRISM_STORAGE_PATH='${storagePath}'"
            "PHOTOPRISM_IMPORT_PATH='${importPath}'"
            "PHOTOPRISM_READONLY=${(if cfg.readonly then "true" else "false")}"
            "PHOTOPRISM_DETECT_NSFW=${(if cfg.enableTensorflow then "true" else "false")}"
            "PHOTOPRISM_DISABLE_TENSORFLOW=${(if cfg.enableTensorflow then "false" else "true")}"
            "PHOTOPRISM_DATABASE_DRIVER=mysql"
            "PHOTOPRISM_DATABASE_SERVER=/run/mysqld/mysqld.sock"
            "PHOTOPRISM_DATABASE_USER=${cfg.user}"
            "PHOTOPRISM_DATABASE_PASSWORD=''"
            "PHOTOPRISM_AUTH_MODE=password"
          ];

          DynamicUser = false;
          User = cfg.user;
          Group = cfg.group;

          BindReadOnlyPaths = [
            "/nix/store"
            "${cfg.importPath}:${importPath}"
            "${cfg.originalsPath}:${originalsPath}"
          ];

          # Needed by a dependency for ML models that use a JIT compiler
          MemoryDenyWriteExecute = false;

          BindPaths = [
            "/run/mysqld" # Allow binding of mysqld
            "${cfg.storagePath}:${storagePath}"
          ];
        };
      };
    };

    networking.firewall = mkIf cfg.openFirewall {
      allowedTCPPorts = [
        cfg.httpPort
      ];
    };
  };
}
