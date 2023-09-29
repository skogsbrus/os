{ config, lib, pkgs, modulesPath, ... }:
{
  imports = [
    ./hardware.nix
    ../../sys
  ];

  networking.hostName = "vm-prom2";
  networking.nameservers = [ "8.8.8.8" ];

  skogsbrus = {

    docker = {
      enable = true;
      users = [ "johanan" ];
    };

    fwupd.enable = true;

    networking = {
      enableNetworkManager = true;
    };

    nix = {
      allowUnfree = true;
      flakes = true;
      gc = false;
    };

    postgres = {
      enable = true;
      user = "johanan";
    };

    printing.enable = true;

    sound = {
      enable = true;
      enablePipewire = true;
    };

    tlp.enable = false;

    users = {
      groups = [ "networkmanager" ];
      uid = 501;
    };

    xserver.enable = true;
  };

  programs.dconf.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
}
