{ config
, pkgs
, lib
, ...
}:
let
  cfg = config.skogsbrus.users;
  inherit (lib) mkOption types mkIf mkEnableOption;
in
{
  options.skogsbrus.users = {
    groups = mkOption {
      type = types.listOf types.str;
      example = [ "networkmanager" ];
      default = [ ];
      description = "Groups to add the user to";
    };
  };

  # TODO: parameterize users
  config.home-manager.users.johanan.programs.git = {
    enable = true;
    extraConfig.safe.directory = "/home/johanan/os/";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  config.users.users.johanan = {
    isNormalUser = true;
    extraGroups = [ "wheel" ] ++ cfg.groups;
  };

  config.users.extraUsers.johanan = {
    shell = pkgs.zsh;
  };
}
