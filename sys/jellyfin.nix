{ config
, pkgs
, lib
, ...
}:
let
  cfg = config.skogsbrus.jellyfin;
  inherit (lib) mkOption types mkIf mkEnableOption;
in
{
  options.skogsbrus.jellyfin = {
    enable = mkEnableOption "jellyfin";
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
    services.jellyfin = {
      enable = true;
      user = cfg.user;
      group = cfg.group;
      openFirewall = cfg.openFirewall;
    };
  };
}
