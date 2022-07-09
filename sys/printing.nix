{ config
, lib
, pkgs
, ...
}:
let
  cfg = config.skogsbrus.printing;
  inherit (lib) mkIf mkEnableOption;
in
{
  options.skogsbrus.printing = {
    enable = mkEnableOption "printing";
  };

  config = mkIf cfg.enable {
    services = {
      printing = {
        enable = true;
        drivers = [ pkgs.hplip ];
      };
    };
  };
}
