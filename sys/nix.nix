{ config
, pkgs
, lib
, ...
}:
let
  cfg = config.skogsbrus.nix;
  inherit (lib) mkOption types mkIf mkEnableOption;
in
{
  options.skogsbrus.nix = {
    gc = mkEnableOption "gc";
    flakes = mkEnableOption "flakes";
    allowUnfree = mkEnableOption "allowUnfree";
    optimizeStore = mkEnableOption "optimizeStore";

    enableAutoUpgrade = mkEnableOption "autoUpgrade";
    enableAutoUpgradeReboot = mkEnableOption "autoUpgrade";

    gcSchedule = mkOption {
      type = types.str;
      example = "weekly";
      default = "daily";
      description = "Garbage collection schedule";
    };
  };

  config = {
    nix.package = mkIf cfg.flakes pkgs.nixFlakes;
    nix.extraOptions = mkIf cfg.flakes ''
      experimental-features = nix-command flakes
    '';

    nix.gc = {
      automatic = cfg.gc;
      dates = cfg.gcSchedule;
    };

    nix.settings.auto-optimise-store = cfg.optimizeStore;

    # Allow installing unfree system packages
    nixpkgs.config.allowUnfree = cfg.allowUnfree;

    system.autoUpgrade.enable = cfg.enableAutoUpgrade;
    system.autoUpgrade.allowReboot = cfg.enableAutoUpgradeReboot;

  };
}
