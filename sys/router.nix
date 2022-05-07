# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

{
  networking.hostName = "router";
  networking.useDHCP = false;
  networking.interfaces.enp1s0.useDHCP = true;
  networking.interfaces.enp2s0.useDHCP = true;
  networking.interfaces.wlp3s0.useDHCP = true;

  networking.wireless.enable = true;
  networking.wireless.userControlled.enable = true;
  networking.networkmanager.unmanaged = [ "interface-name:wlp3s0" ] ++ lib.optional config.services.hostapd.enable "interface-name:${config.services.hostapd.interface}";
  #services.hostapd = {
  #  enable = true;
  #  interface = "wlp3s0";
  #  hwMode = "g";
  #  ssid = "beepboop";
  #  wpaPassphrase = "foobar";
  #};

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
}

