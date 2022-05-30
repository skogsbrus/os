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
      };
    };
  };

  imports = [
      ./hostapd.nix
  ];

  networking.hostName = "router";
  networking.useDHCP = false;
  networking.interfaces.enp1s0.useDHCP = true;

  networking.nat = {
    enable = true;
    internalIPs = [
        "192.168.1.0/24"
        "192.168.2.0/24"
    ];
  };

  networking.interfaces = {
    wlp3s0 = {
      useDHCP = false;
      ipv4.addresses = [
        {
          address = "192.168.1.1";
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

  services.dnsmasq = {
    enable = true;
    servers = [ "9.9.9.9" "1.1.1.1" ];
    extraConfig = ''
      domain-needed
      dhcp-range=192.168.1.10,192.168.1.254,24h
      dhcp-range=192.168.2.10,192.168.2.254,24h
    '';
  };

  networking.firewall = {
    enable = true;
    trustedInterfaces = [ "wlp3s0" "enp2s0" ];
    allowedTCPPorts = [
      80
      443
      2222
    ];
  };
}
