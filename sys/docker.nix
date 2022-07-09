{ config
, lib
, ...
}:
let
  cfg = config.skogsbrus.docker;
  inherit (lib) mapAttrs' genAttrs mkOption types mkIf mkEnableOption;
in
{
  options.skogsbrus.docker = {
    enableNvidia = mkEnableOption "nvidia support";
    enable = mkEnableOption "docker";

    users = mkOption {
      type = types.listOf types.str;
      default = [ ];
      example = [ "user1" "user2" ];
      description = "Users to add to the 'docker' group";
    };
  };

  config = mkIf cfg.enable {

    # Add each user to the 'docker' group
    users.users = genAttrs cfg.users (name: { extraGroups = [ "docker" ]; });

    # Fails assertion unless set
    hardware.opengl.driSupport32Bit = mkIf cfg.enableNvidia true;

    virtualisation.docker.enable = cfg.enable;
    virtualisation.docker.enableNvidia = cfg.enableNvidia;
  };
}
