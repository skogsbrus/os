# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

{

  # https://github.com/mdlayher/homelab/blob/391cfc0de06434e4dee0abe2bec7a2f0637345ac/nixos/routnerr-2/configuration.nix#L38
  # https://serverfault.com/questions/248841/ip-forwarding-when-and-why-is-this-required
  boot = {
    kernel = {
      sysctl = {
        # Forward on all interfaces.
        "net.ipv4.conf.all.forwarding" = true;
        "net.ipv6.conf.all.forwarding" = true;

        # By default, not automatically configure any IPv6 addresses.
        #"net.ipv6.conf.all.accept_ra" = 0;
        #"net.ipv6.conf.all.autoconf" = 0;
        #"net.ipv6.conf.all.use_tempaddr" = 0;

        # On WAN, allow IPv6 autoconfiguration and tempory address use.
        #"net.ipv6.conf.${name}.accept_ra" = 2;
        #"net.ipv6.conf.${name}.autoconf" = 1;
      };
    };
  };

  networking.hostName = "router";
  networking.useDHCP = false;
  networking.interfaces.enp1s0.useDHCP = true;
  #networking.nameservers = [ "127.0.0.1" "9.9.9.9" ];

  networking.nat = {
    enable = true;
    internalIPs = [ "192.168.2.0/24" "192.168.3.0/24" ];
  };

  networking.interfaces = {
    wlp3s0 = {
      useDHCP = false;
      ipv4.addresses = [
        {
          address = "192.168.3.1";
          prefixLength = 24;
        }
      ];
    };
    enp2s0 = {
      useDHCP = false;
      ipv4.addresses = [
        {
          address = "192.168.2.1";
          prefixLength = 24;
        }
      ];
    };
  };

  networking.networkmanager.enable = false;
  services.hostapd = {
    enable = true;
    interface = "wlp3s0";
    # Experiments:
    # g: ~3Mbit/s
    # a: ~10Mbit/s
    ssid = "beepboop";
    extraConfig = ''
      beacon_int=100
      channel=36
      country_code=SE
      driver=nl80211
      hw_mode=a
      #ieee80211ac=1
      #ieee80211n=1
      wpa_key_mgmt=WPA-PSK
      wpa_passphrase=foobar123
      wpa_pairwise=CCMP
      logger_syslog=1 # debug
      require_vht=1
      #vht_capab=[MAX-MPDU-11454][SHORT-GI-80][TX-STBC-12][RX-STBC-1][SU-BEAMFORMEE][HTC-VHT]
      vht_oper_centr_freq_seg0_idx=42
      wmm_enabled=1
    '';
  };

  services.dnsmasq = {
    enable = true;
    servers = [ "9.9.9.9" "1.1.1.1" ];
    extraConfig = ''
      interface=enp2s0
      interface=wlp3s0
      bind-interfaces
      dhcp-range=192.168.2.10,192.168.2.254,24h
      dhcp-range=192.168.3.10,192.168.3.254,24h
    '';
  };

  networking.firewall = {
    enable = true;
    trustedInterfaces = [ "wlp3s0" ];
    allowedTCPPorts = [
      80
      443
      2222
    ];
  };
}
