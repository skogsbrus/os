{ config
, lib
, pkgs
, unstable
, skogsbrus
, ...
}:
let
  cfg = config.skogsbrus.paperless;
  inherit (lib) mkIf mkOption mkEnableOption types;
in
{
  options.skogsbrus.paperless = {
    enable = mkEnableOption "paperless";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.paperless-ngx
    ];

    services.paperless = {
      enable = true;
      dataDir = "/var/lib/paperless";
      mediaDir = "/tank/media/documents/paperless-meta";
      consumptionDir = "/tank/backup/input/documents";
      consumptionDirIsPublic = true;
      port = 8000;
      address = "localhost";
      settings = {
        PAPERLESS_OCR_LANGUAGE = "swe+eng";
        PAPERLESS_DBENGINE = "postgresql";
        PAPERLESS_DBHOST = "/run/postgresql";
        PAPERLESS_DBPORT = "5432";
        PAPERLESS_DBNAME = "paperless";
        PAPERLESS_DBUSER = "postgres";
        PAPERLESS_DBPASS = "postgres";
        PAPERLESS_DBSSLMODE= "allow";
        PAPERLESS_OCR_USER_ARGS="{\"invalidate_digital_signatures\": true}";
        HOME = "/tmp"; # Prevent GNUPG home dir error
      };
      user = "johanan";
    };
  };
}
