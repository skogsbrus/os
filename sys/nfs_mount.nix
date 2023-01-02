{ config
, pkgs
, lib
, ...
}:
let
  cfg = config.skogsbrus.nfs_mount;
  inherit (lib) mapAttrs' mkOption types mkIf mkEnableOption;
in
{
  options.skogsbrus.nfs_mount = {
    enable = mkEnableOption "grafana";

    server_addr = mkOption {
      type = types.str;
      example = "foobar.local";
      default = "keeper.home";
      description = "Address of the NFS server";
    };

    mountpoint = mkOption {
      type = types.str;
      example = "/mnt/foobar";
      description = "Directory where mounts are mounted";
    };

    mounts = mkOption {
      type = types.attrsOf types.str;
      example = {
        "foo" = "bar";
      };
      default = { };
      description = "Key-value pairs of mountpoint names and their server paths";
    };
  };

  config = mkIf cfg.enable {
    fileSystems = mapAttrs'
      (name: value: lib.attrsets.nameValuePair
        ("${cfg.mountpoint}/${name}")
        ({
          device = "${cfg.server_addr}:${value}";
          fsType = "nfs";
          options = [
            "nfsvers=4.2"
            "x-systemd.automount"
            "noauto"
          ];
        })
      )
      cfg.mounts;
  };
}
