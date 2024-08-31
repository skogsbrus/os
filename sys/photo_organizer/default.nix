{ config
, lib
, pkgs
, ...
}:
let
  photoOrganizer = (pkgs.callPackage ./derivation.nix { });
  cfg = config.skogsbrus.photoOrganizer;
  inherit (lib) mkIf mkOption mkEnableOption types;
in
{
  options.skogsbrus.photoOrganizer = {
    enable = mkEnableOption "photo_organizer";
    deleteAfterCopy = mkEnableOption "Delete the processed input files after they have been copied";
    inputDir = mkOption {
      type = types.str;
      example = "/tmp/foo/bar";
      description = "Input directory";
    };
    outputDir = mkOption {
      type = types.str;
      example = "/tmp/foo/bar";
      description = "Output directory";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      photoOrganizer
    ];

    systemd.services.photo_organizer_import = {
      enable = true;
      description = "Organize photos by date";
      serviceConfig = {
        ExecStart = "${photoOrganizer}/bin/photo_organizer.py ${if cfg.deleteAfterCopy then "--delete-after-copy" else ""} --dir '${cfg.inputDir}' --out '${cfg.outputDir}' --silent";
        ExecStartPost = "systemctl start photoprism_index"; # Hacky dependency to auto-trigger indexing once import is complete
      };
      startAt = "*-*-* 10,18:00:00";
    };
  };
}

