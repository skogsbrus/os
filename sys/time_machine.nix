{ config
, pkgs
, lib
, ...
}:
let
  cfg = config.skogsbrus.time_machine;
  inherit (lib) mkOption types mkIf mkEnableOption;
in
# TODO: make this module generic for multiple computers /users
{
  options.skogsbrus.time_machine = {
    enable = mkEnableOption "Time machine backup destination";
    openFirewall = mkEnableOption "Open necessary ports in the firewall";

    backupPath = mkOption {
      type = types.str;
      example = "/foo/bar";
      description = "Backup destination path";
    };

    user = mkOption {
      type = types.str;
      example = "bob";
      description = "User";
    };
  };

  config = mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = mkIf cfg.openFirewall [
      548 # netatalk
    ];
    networking.firewall.allowedUDPPorts = mkIf cfg.openFirewall [
      1900 # bonjour
    ];

    services = {
      netatalk = {
        enable = true;
        settings = {
          global =
            {
              "mimic model" = "TimeCapsule6,106"; # show the icon for the first gen TC
              "log level" = "default:warn";
              "log file" = "/var/log/afpd.log";
              "hosts allow" = "10.77.77.0/24 10.66.66.0/24";

            };
          airm2-time-machine = {
            "path" = cfg.backupPath;
            "valid users" = cfg.user;
            "time machine" = "yes";
            "vol size limit" = 512000;
          };
        };
      };

      avahi = {
        enable = true;
        nssmdns = true;

        publish = {
          enable = true;
          userServices = true;
        };
      };
    };
    users.extraUsers.macUser = {
        name = "${cfg.user}";
        group = "users";
        isNormalUser = true;
    };
    systemd.services.macUserSetup = {
      description = "idempotent directory setup for ${cfg.user}'s time machine";
      requiredBy = [ "netatalk.service" ];
      script = ''
        mkdir -p ${cfg.backupPath}
         chown ${cfg.user}:users ${cfg.backupPath}  # making these calls recursive is a switch
         chmod 0750 ${cfg.backupPath}           # away but probably computationally expensive
      '';
    };
  };
}
