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
    media = mkEnableOption "media apps";
    comms = mkEnableOption "communication apps";
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
      libreoffice
      peek
      picocom
      vscode
      xclip
    ]
    ++ (if cfg.enableAll || cfg.media then [
      gimp
      spotify
      vlc
    ] else [])
    ++ (if cfg.enableAll || cfg.comms then [
      discord
      element-desktop
      slack
    ] else []);
  };
}
