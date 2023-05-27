{ config
, lib
, pkgs
, unstable
, skogsbrus
, ...
}:
let
  cfg = config.skogsbrus.authelia;
  authelia = unstable.legacyPackages.${pkgs.system}.authelia;
  inherit (lib) mkIf mkOption mkEnableOption types;
in
{
  options.skogsbrus.authelia = {
    enable = mkEnableOption "authelia";
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
    environment.systemPackages = [
      authelia
    ];

    age.secrets.authelia_users_yaml = {
      file = ../secrets/authelia_users_yaml.age;
      owner = "root";
      group = "root";
      mode = "444"; # TODO: make this only accessibly by root or fold into authelia config
    };

    age.secrets.authelia_cfg_yaml = {
      file = ../secrets/authelia_cfg_yaml.age;
      owner = "root";
      group = "root";
      mode = "400";
    };

    systemd.services.authelia = {
      wantedBy = [ "default.target" ];
      description = "Start Authelia";

      unitConfig = {
        StartLimitInterval = 200;
        StartLimitBurst = 3;
      };

      serviceConfig = skogsbrus.lib.secureSystemdServiceOptions {
        options = {
          # TODO: why doesn't this work without the bash wrapper? Complains about '--config' not receiving an argument
          ExecStart = "${pkgs.bash}/bin/bash -c \"${authelia}/bin/authelia --config $CREDENTIALS_DIRECTORY/config.yaml\"";
          LoadCredential = [
            "config.yaml:${config.age.secrets.authelia_cfg_yaml.path}"
          ];
          Restart = "always";
          RestartSec = 10;

          IPAddressAllow = [ "0.0.0.0/0" ];
          PrivateNetwork = false;
          #JoinsNamespaceOf = [ "caddy" "postgres" ];
          RestrictAddressFamilies = [ "AF_INET" ];
        };
        name = "authelia";
      };
    };
  };
}
