{ config
, lib
, ...
}:
let
  cfg = config.skogsbrus.fwupd;
  inherit (lib) mkIf mkEnableOption;
in
{
  options.skogsbrus.fwupd = {
    enable = mkEnableOption "fwupd";
  };

  config = mkIf cfg.enable {
    services.fwupd.enable = true;
  };
}
