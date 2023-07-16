{ config
, lib
, pkgs
, unstable
, skogsbrus
, ...
}:
let
  cfg = config.skogsbrus.paperless_ngx;
  inherit (lib) mkIf mkOption mkEnableOption types;
in
{
  options.skogsbrus.paperless_ngx = {
    enable = mkEnableOption "paperless_ngx";
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
      services.paperless = {
        enable = true;
      };

    #age.secrets.authelia_users_yaml = {
    #  file = ../secrets/authelia_users_yaml.age;
    #  owner = "root";
    #  group = "root";
    #  mode = "444"; # TODO: make this only accessibly by root or fold into authelia config
    #};
  };
}
