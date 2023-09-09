{ config
, pkgs
, lib
, ...
}:
let
  cfg = config.skogsbrus.lidarr;
  inherit (lib) mkOption types mkIf mkEnableOption;
in
{
  options.skogsbrus.lidarr = {
    enable = mkEnableOption "lidarr";
    openFirewall = mkEnableOption "Open a port in the firewall";

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

  };

  config = mkIf cfg.enable {
    services.lidarr = {
      enable = true;
      openFirewall = true;
      user = cfg.user;
      group = cfg.group;
    };
  };
}
