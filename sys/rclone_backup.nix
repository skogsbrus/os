{ config
, lib
, pkgs
, ...
}:
let
  cfg = config.skogsbrus.rcloneBackup;
  rclone_config_entry = "backblaze-backup-prod";
  b2_bucket = "skogsbrus-bucket-prod";
  inherit (lib) mkIf mkOption mkEnableOption types mapAttrs';
in
{
  options.skogsbrus.rcloneBackup = {
    enable = mkEnableOption "Rclone Backup";
    b2_directories = mkOption {
      type = types.attrsOf types.str;
      example = {
        "/tmp/foo/source" = "/destination/path";
      };
      default = { };
      description = "Source and destination directories to back up to Backblaze B2";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.rclone
    ];

    age.secrets.backblaze_b2_backup_prod_rclone_config = {
      file = ../secrets/backblaze_b2_backup_prod_rclone_config.age;
      owner = "root";
      group = "root";
      mode = "400";
    };

    # Create a unique systemd service for each directory being backed up
    systemd.services = mapAttrs'
      (src: dst: lib.attrsets.nameValuePair
        ("b2_backup_${builtins.replaceStrings [ "/" ] [ "_" ] src}")
        ({
          enable = true;
          description = " Back up ${src} to ${dst}";
          serviceConfig = {
            # TODO: why doesn't this work without the bash wrapper? Sames error as in authelia.nix when using $CREDENTIALS_DIRECTORY
            ExecStart = "${pkgs.bash}/bin/bash -c \"${pkgs.rclone}/bin/rclone --config $CREDENTIALS_DIRECTORY/rclone.conf sync ${src} ${rclone_config_entry}:${b2_bucket}/${dst}\"";
            LoadCredential = [
              "rclone.conf:${config.age.secrets.backblaze_b2_backup_prod_rclone_config.path}"
            ];
          };
          startAt = "weekly";
        })
      )
      cfg.b2_directories;
  };
}




