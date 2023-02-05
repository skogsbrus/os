{ config
, lib
, pkgs
, ...
}:
{
  options.skogsbrus.firefox = {
    enable = lib.mkEnableOption "firefox";
  };

  config = {
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
