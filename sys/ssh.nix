{ config
, pkgs
, lib
, ...
}:
let
  cfg = config.skogsbrus.ssh;
  inherit (lib) mkIf mkEnableOption;
in
{
  options.skogsbrus.ssh = {
    enable = mkEnableOption "ssh";
  };

  config = mkIf cfg.enable {
    services.openssh = {
      enable = true;
      passwordAuthentication = false;
      permitRootLogin = "no";
    };
  };
}
