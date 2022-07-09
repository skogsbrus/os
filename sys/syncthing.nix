{ config
, lib
, ...
}:
let
  cfg = config.skogsbrus.syncthing;
  inherit (lib) mkEnableOption mkOption mkIf types;
in
{
  options.skogsbrus.syncthing = {
    enable = mkEnableOption "syncthing";
    user = mkOption {
      description = "User to run the service under";
      type = types.str;
      example = "bob";
    };
  };

  config = mkIf cfg.enable {
    services = {
      syncthing = {
        enable = true;
        user = cfg.user;
        dataDir = "/home/${cfg.user}/syncthing";
        configDir = "/home/${cfg.user}/syncthing/.config/syncting";
      };
    };
  };
}
