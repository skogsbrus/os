{ config, lib, pkgs, modulesPath, ... }:
{
  imports = [
    ./hardware.nix
    ../../sys
  ];

  networking.hostName = "voidm";

  # for VPN
  services.strongswan = {
    enable = true;
    secrets = [
      "ipsec.d/ipsec.nm-l2tp.secrets"
    ];
  };

  skogsbrus = {

    docker = {
      enable = true;
      enableNvidia = true;
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

    sound = {
      enable = true;
      enablePipewire = true;
    };

    tmux = {
      enable = true;
      awWatcher = true;
      bgColor = "blue";
    };

    tlp.enable = false;

    users = {
      groups = [ "networkmanager" ];
    };

    wireguard = {
      enable = true;
      port = 666;
      subnet = "10.66.66";
      serverSubnet = "10.77.77";
      uniqueId = 2;
    };

    xserver.enable = true;
    zsh.enable = true;
  };

  services.udev.extraRules = ''
    SUBSYSTEM=="usb", ATTR{idVendor}=="4255", ATTR{idProduct}=="0012" MODE="0666"
    SUBSYSTEM=="usb", ATTR{idVendor}=="4255", ATTR{idProduct}=="0014" MODE="0666"
    SUBSYSTEM=="usb", ATTR{idVendor}=="4255", ATTR{idProduct}=="0001" MODE="0666"
    SUBSYSTEM=="usb", ATTR{idVendor}=="0403", ATTR{idProduct}=="6010" MODE="0666"
  '';

  virtualisation.libvirtd.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;
  programs.dconf.enable = true;
  environment.systemPackages = with pkgs; [ virt-manager ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.05";
}
