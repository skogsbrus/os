{ config
, lib
, pkgs
, unstable
, ...
}:
let
  cfg = config.skogsbrus.client;
  inherit (lib) types mkIf mkOption mkEnableOption;
in
{
  options.skogsbrus.client = {
    enable = mkEnableOption "client (non-server) applications";
    enableAll = mkEnableOption "installation of everything this module has to offer";
    activitywatch = mkEnableOption "activitywatch";
    corporate = mkEnableOption "corporate applications";
    extraPackages = mkOption
      {
        type = types.listOf types.package;
        default = [ ];
        example = [ pkgs.cowsay ];
        description = "List of packages to install";
      };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      chromium
      dconf2nix # syntax converter: dconf -> home manager
      element-desktop
      discord
      firefox
      gimp
      libreoffice
      peek
      picocom
      spotify
      vlc
      vscode
      xclip

      #(pkgs.callPackage pkgs/webex {})
    ]
    ++ cfg.extraPackages
    ++ (if cfg.enableAll || cfg.corporate then [
      pkgs.slack
    ] else [ ])
    ++ (if cfg.enableAll || cfg.activitywatch then [
      (pkgs.callPackage ./activitywatch { })
    ] else [ ]);
  };
}
