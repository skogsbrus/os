{ config
, lib
, pkgs
, ...
}:
let
  cfg = config.skogsbrus.steam;
  inherit (lib) genAttrs mkOption types mkIf mkEnableOption;
in
{

  options.skogsbrus.steam = {
    enable = mkEnableOption "steam";
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
  };
}
