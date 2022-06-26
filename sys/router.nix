{ config, pkgs, lib, ... }:
let
  private_subnet = "10.77.77";
  guest_subnet = "10.88.88";
in
{
  imports = [
    ./hostapd.nix
    ./monitoring.nix
  ];

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

  services.ddclient = {
    enable = true;
    use = "web";
    protocol = "namecheap";
    server = "dynamicdns.park-your-domain.com";
    username = "skogsbrus.xyz";
    passwordFile = "/home/johanan/os/secrets/ddns.pw";
    domains = [ "vpn" "www.vpn" ];
  };

  networking.hostName = "router";
  networking.useDHCP = false;
  networking.interfaces.enp1s0.useDHCP = true;
  networking.interfaces.enp2s0.useDHCP = true;
  networking.interfaces.wlp3s0.useDHCP = true;

  networking.nat = {
    enable = true;
    internalInterfaces = [
      "br0"
      "wguest"
      "wg0" # ./wireguard.nix
    ];
    externalInterface = "enp1s0";
  };

  networking.bridges = {
    br0 = {
      interfaces = [
        "enp2s0"
        "wlp3s0"
      ];
    };
  };

  networking.interfaces = {
    br0 = {
      useDHCP = false;
      ipv4.addresses = [
        {
          address = "${private_subnet}.1";
          prefixLength = 24;
        }
      ];
    };
    wguest = {
      useDHCP = false;
      ipv4.addresses = [
        {
          address = "${guest_subnet}.1";
          prefixLength = 24;
        }
      ];
    };
  };

  networking.networkmanager.enable = false;

  services.dnsmasq = {
    enable = true;
    extraConfig = ''
      # sensible behaviours
      domain-needed
      bogus-priv
      no-resolv

      # upstream name servers
      server=9.9.9.9
      server=1.1.1.1

      # local domains
      expand-hosts
      domain=home
      local=/home/

      # Interfaces to use DNS on
      interface=br0
      interface=wguest
      interface=wg0

      # subnet IP blocks to use DHCP on
      dhcp-range=${private_subnet}.10,${private_subnet}.254,24h
      dhcp-range=${guest_subnet}.10,${guest_subnet}.254,24h

      # static IPs
      dhcp-host=00:0d:b9:5e:22:91,${private_subnet}.1
      dhcp-host=b8:27:eb:84:09:f8,${private_subnet}.90
      dhcp-host=00:11:32:33:30:5b,${private_subnet}.65
      dhcp-host=30:9c:23:1b:a5:4d,${private_subnet}.83
    '';
  };

  # Define host names to make dnsmasq resolve them, e.g. http://router.home
  networking.extraHosts =
    ''
      ${private_subnet}.1 router
      ${private_subnet}.90 kodi
      ${private_subnet}.65 choklad
      ${private_subnet}.83 workstation
    '';

  networking.firewall = {
    enable = true;
    trustedInterfaces = [ "br0" "wg0" ];

    interfaces = {
      enp1s0 = {
        allowedTCPPorts = [ ];
        allowedUDPPorts = [
          # Wireguard
          666
        ];
      };
      # https://serverfault.com/a/424226
      wguest = {
        allowedTCPPorts = [
          # DNS
          53
          # HTTP(S)
          80
          443
          110
          # Email (pop3, pop3s)
          995
          114
          # Email (imap, imaps)
          993
          # Email (SMTP Submission RFC 6409)
          587
          # Git
          2222
        ];
        allowedUDPPorts = [
          # https://serverfault.com/a/424226
          # DNS
          53
          # DHCP
          67
          68
          # NTP
          123
          # Wireguard
          666
        ];
      };
    };
  };
  # Prevent sshd from opening port 22 (circumventing the firewall)
  services.openssh.openFirewall = false;
}
