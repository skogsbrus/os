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
      gimp
      libreoffice
      xfce.xfce4-terminal
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
      pkgs.taskwarrior
      pkgs.python39Packages.bugwarrior
    ] else [ ])
    ++ (if cfg.enableAll || cfg.activitywatch then [
      (pkgs.callPackage ./activitywatch { })
    ] else [ ]);

    pkgs.overlays = mkIf cfg.corporate [
      (self: super: {
        python39Packages.taskw = super.python39Packages.taskw.overrideAttrs (old: rec {
        version = "2.0.0";
        src = fetchPypi {
          inherit pname version;
          sha256 = "1a68e49cac2d4f6da73c0ce554fd6f94932d95e20596f2ee44a769a28c12ba7d";
        });
        });
      })
    ];
  };
}
