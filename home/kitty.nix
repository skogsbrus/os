{ config
, lib
, pkgs
, unstable
, home-manager
, ...
}:
let
  cfg = config.skogsbrus.kitty;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.skogsbrus.kitty = {
    enable = mkEnableOption "kitty";
  };

  config = mkIf cfg.enable {
    programs.kitty = {
      enable = true;
      theme = "Gruvbox Material Dark Hard";
    };
  };
}
