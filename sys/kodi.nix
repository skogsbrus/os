{ config
, pkgs
, lib
, ...
}:
let
  cfg = config.skogsbrus.kodi;
  inherit (lib) mkOption types mkIf mkEnableOption;
in
{
  options.skogsbrus.kodi = {
    enable = mkEnableOption "kodi";
    autoLogin = mkEnableOption "Automatically log in with Kodi";
    openFirewall = mkEnableOption "Open the firewall for remote control";

    user = mkOption {
      type = types.str;
      example = "bob";
      description = "User that should run the service";
    };
  };

  config = mkIf cfg.enable {
    # Hack for CEC to work
    users.extraUsers."${cfg.user}".extraGroups = [ "dialout" ];

    services.xserver = {
      desktopManager.kodi.enable = true;
      displayManager.autoLogin.enable = cfg.autoLogin;
      displayManager.autoLogin.user = cfg.user;
      # I always want this option set :)
      xkbOptions = "caps:escape";
    };

    networking.firewall = mkIf cfg.openFirewall {
      allowedTCPPorts = [
        8080 # Kodi
      ];
      allowedUDPPorts = [
        8080 # Kodi
      ];
    };
  };
}
