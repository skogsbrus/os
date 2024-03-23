{ config
, pkgs
, lib
, ...
}:
let
  cfg = config.skogsbrus.security;
  inherit (lib) mkIf mkEnableOption;
in
{
  options.skogsbrus.security = {
    enable = mkEnableOption "enable security module";
  };

  config = mkIf cfg.enable {
    security.sudo.enable = true;
    security.sudo.wheelNeedsPassword = true;
  };
}
