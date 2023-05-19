{ config
, lib
, pkgs
, ...
}:
let
  cfg = config.skogsbrus.firefox;
  inherit (lib) mkIf;
in
{
  options.skogsbrus.firefox = {
    enable = lib.mkEnableOption "firefox";
  };

  config = mkIf cfg.enable {
    programs.firefox = {
      enable = true;
      profiles.johanan = {
        settings = {
          # Don't trigger search if query ends with .home
          "browser.fixup.domainsuffixwhitelist.home" = true;
        };
      };
    };
  };
}
