{ config
, pkgs
, lib
, ...
}:
let
  cfg = config.skogsbrus.postgres;
  inherit (lib) mkOption types mkIf mkEnableOption;
in
{
  options.skogsbrus.postgres = {
    enable = mkEnableOption "postgres";

    user = mkOption {
      type = types.str;
      example = "foobar";
      description = "Admin user name";
    };

  };

  config = mkIf cfg.enable {
    services.postgresql = {
      enable = true;
      package = pkgs.postgresql_14;
      enableTCPIP = false;
      authentication = pkgs.lib.mkForce ''
        # Generated file; do not edit!
        # TYPE  DATABASE        USER            ADDRESS                 METHOD
        local   all             all                                     trust
        host    all             all             127.0.0.1/32            trust
        host    all             all             ::1/128                 trust
      '';
      initialScript = pkgs.writeText "backend-initScript" ''
        CREATE ROLE ${cfg.user} WITH LOGIN PASSWORD 'postgres' CREATEDB;
        CREATE DATABASE ${cfg.user};
        GRANT ALL PRIVILEGES ON DATABASE ${cfg.user} TO ${cfg.user};
      '';
    };
  };
}
