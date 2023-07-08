{ config
, lib
, pkgs
, skogsbrus
, ...
}:
let
  cfg = config.skogsbrus.komga;
  inherit (lib) mkIf mkOption mkEnableOption types;
in
{
  options.skogsbrus.komga = {
    enable = mkEnableOption "komga";
    port = mkOption {
      type = types.int;
      example = 1234;
      description = "Port to expose the service on";
    };

    openFirewall = mkEnableOption "Open firewall";

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
    services.komga = {
      enable = true;
      port = cfg.port;
      openFirewall = cfg.openFirewall;
      stateDir = "/tank/media/books/komga";
    };
    # TODO: secure the service. Bindpaths don't seem to work.
    #systemd.services.komga = {
    #  serviceConfig = skogsbrus.lib.overrideSystemdServiceOptions {
    #    name = "komga";
    #    current = config.systemd.services.komga.serviceConfig;
    #    options = {
    #      #BindPaths = [
    #      #  "/tank/media/komga:/var/lib/komga"
    #      #];

    #      # Fixes 'Failed to mark memory page as executable - check if grsecurity/PaX
    #      # is enabled'
    #      MemoryDenyWriteExecute = false;
    #      RestrictAddressFamilies = [ "AF_INET" "AF_INET6" "AF_UNIX" ];

    #      BindPaths = [
    #        "/tank/media/books"
    #      ];
    #    };
    #  };
    #};
  };
}
