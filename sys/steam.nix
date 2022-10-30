{ config
, lib
, pkgs
, ...
}:
let
  cfg = config.skogsbrus.steam;
  inherit (lib) genAttrs mkOption types mkIf mkEnableOption;
  steamlink = (pkgs.callPackage ./steamlink { });
in
{

  options.skogsbrus.steam = {
    enable = mkEnableOption "steam";
    steamlink = mkEnableOption "link";
    users = mkOption {
      default = [ ];
      description = "Users to add to the 'input' group";
      example = [ "user1" "user2" ];
      type = types.listOf types.str;
    };
  };

  config = {
    users.users = genAttrs cfg.users (
      name: {
        extraGroups = [ "input" ];
      }
    );

    programs.steam.enable = cfg.enable;
    hardware.steam-hardware.enable = cfg.enable;

    environment.systemPackages = (
      if cfg.steamlink then
        [ steamlink ]
      else
        [ ]
    );
  };
}
