{ config
, pkgs
, lib
, skogsbrus
, ...
}:
let
  cfg = config.skogsbrus.email;
  inherit (lib) mkIf mkEnableOption;
in
{
  options.skogsbrus.email = {
    nullmailer = mkEnableOption "enable nullmailer";
  };

  config = mkIf cfg.nullmailer {
    age.secrets.nullmailer_remotes = {
      file = ../secrets/nullmailer_remotes.age;
      path = "/etc/nullmailer/remotes";
      owner = "nullmailer";
      group = "nullmailer";
      mode = "400";
    };

    services.nullmailer = {
      enable = cfg.nullmailer;
      setSendmail = true;
      config = {
        adminaddr = "bot@skogsbrus.xyz";
        me = config.networking.hostName;
      };
    };
  };
}

