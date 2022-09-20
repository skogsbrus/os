{ config
, lib
, pkgs
, unstable
, ...
}:
let
  cfg = config.skogsbrus.dev;
  inherit (lib) types mkIf mkOption mkEnableOption;
in
{

  options.skogsbrus.dev = {
    enable = mkEnableOption "developer tools/applications";

    enableAll = mkEnableOption "installation of everything this module has to offer";

    aws = mkEnableOption "AWS tools";
    corporate = mkEnableOption "corporate tools";
    cuda = mkEnableOption "CUDA";
    cxx = mkEnableOption "C/C++ tools";
    k8s = mkEnableOption "kubernetes tools";
    terraform = mkEnableOption "terraform tools";
    wine = mkEnableOption "Wine";

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
      jetbrains-mono
      docker
      postgresql
      zeal
    ]
    ++ cfg.extraPackages
    ++ (if cfg.enableAll || cfg.cuda then [ pkgs.cudatoolkit_11 ] else [ ])
    ++ (if cfg.enableAll || cfg.k8s then [
      pkgs.google-cloud-sdk
      pkgs.kubectl
    ] else [ ])
    ++ (if cfg.enableAll || cfg.aws then [
      pkgs.aws-vault
      pkgs.awscli
    ] else [ ])
    ++ (if cfg.enableAll || cfg.wine then [
      pkgs.wineWowPackages.stable # 32- and 64-bit
    ] else [ ])
    ++ (if cfg.enableAll || cfg.terraform then [
      unstable.legacyPackages.${pkgs.system}.terraform
      unstable.legacyPackages.${pkgs.system}.tflint
    ] else [ ])
    ++ (if cfg.enableAll || cfg.cxx then [
      pkgs.cmake
      pkgs.coz
      pkgs.gcc
      pkgs.gdb
      pkgs.gnumake
      pkgs.valgrind
    ] else [ ])
    ++ (if cfg.enableAll || cfg.corporate then [
      pkgs.go-jira
    ] else [ ]);
  };
}
