{ config
, pkgs
, lib
, ...
}:
let
  cfg = config.skogsbrus.router;
  formatDhcpHost = key: value: "dhcp-host=${key},${value.ip}";
  formatHostName = key: value: "${value.ip} ${value.name}";
  formatDhcpRange = x: "dhcp-range=${x}.10,${x}.245,24h";
  formatDnsInterface = x: "interface=${x}";
  externalIp = "78.82.197.99";

  allowedUdpPorts = [
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
  allowedTcpPorts = [
    # https://serverfault.com/a/424226
    # SSH
    22
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
  inherit (lib) mapAttrs' genAttrs nameValuePair mkOption types mkIf mkEnableOption;
in
{
  options.skogsbrus.router = {
    enable = mkEnableOption "router";

    privateSubnet = mkOption {
      type = types.str;
      example = "192.168.1";
      description = "IP block (/24) to use for the private subnet";
    };

    guestSubnet = mkOption {
      type = types.str;
      example = "192.168.2";
      description = "IP block (/24) to use for the guest subnet";
    };

    workSubnet = mkOption {
      type = types.str;
      example = "192.168.2";
      description = "IP block (/24) to use for the work subnet.";
    };

    hosts = mkOption {
      type = types.attrsOf (types.attrsOf types.str);
      default = { };
      example = {
        "00:00:00:00:00:00" = {
          ip = "192.168.1.1";
          name = "Bob's phone";
        };
      };
      description = "Known hosts that should be assigned a static IP";
    };
  };

  # TODO: parameterize things like interfaces, hosts, domains, ...
  config = mkIf cfg.enable {
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

    age.secrets.morot_pw = {
      file = ../secrets/morot.age;
      owner = "root";
      group = "root";
      mode = "400";
    };

    age.secrets.cybercorp_pw = {
      file = ../secrets/cybercorp.age;
      owner = "root";
      group = "root";
      mode = "400";
    };

    age.secrets.icecream_pw = {
      file = ../secrets/icecreamiscream.age;
      owner = "root";
      group = "root";
      mode = "400";
    };

    services.ddclient = {
      enable = true;
      use = "web";
      protocol = "namecheap";
      server = "dynamicdns.park-your-domain.com";
      username = "skogsbrus.xyz";
      passwordFile = "/home/johanan/code/os/secrets/ddns.pw";
      domains = [ "vpn" "www.vpn" ];
    };

    networking.hostName = "router";
    networking.useDHCP = false;

    # request an IP from ISP
    networking.interfaces.enp2s0.useDHCP = true;

    networking.firewall = {
      enable = true;
      trustedInterfaces = [ "br0" "wg0" ];

      extraCommands = lib.concatStrings ([
        # Rewrite destination IP of of incoming HTTP(s) requests to Keeper
        # TODO: possible to get prerouting working without specifying the external IP?
        # Doesn't work with `-i enp2s0` as an alternative.
        ''
          iptables -A PREROUTING -t nat -p tcp -d ${externalIp} --dport 80 -j DNAT --to-destination 10.77.77.38:80
          iptables -A PREROUTING -t nat -p tcp -d ${externalIp} --dport 443 -j DNAT --to-destination 10.77.77.38:443
        ''
        # Forward incoming HTTP(s) requests with a destination IP to Keeper
        ''
          iptables -A FORWARD -i enp2s0 -p tcp --dport 80 -d 10.77.77.38 -j ACCEPT -m state --state NEW,RELATED,ESTABLISHED
          iptables -A FORWARD -i enp2s0 -p tcp --dport 443 -d 10.77.77.38 -j ACCEPT -m state --state NEW,RELATED,ESTABLISHED
        ''
        # Rewrite source IP of HTTP(s) requests for Keeper to Router
        ''
          iptables -A POSTROUTING -t nat -p tcp -d 10.77.77.38 --dport 80 -j SNAT --to-source 10.77.77.1
          iptables -A POSTROUTING -t nat -p tcp -d 10.77.77.38 --dport 443 -j SNAT --to-source 10.77.77.1
        ''
      ]);

      # Flush config on reload
      extraStopCommands = ''
        iptables -F
        ip6tables -F
      '';

      # TODO: add VLANs
      interfaces = {
        enp2s0 = {
          allowedTCPPorts = [ 80 443 ];
          allowedUDPPorts = [
            # Wireguard
            666
          ];
        };
        wlp4s0 = {
          allowedTCPPorts = allowedTcpPorts;
          allowedUDPPorts = allowedUdpPorts;
        };
        wlp1s0-1 = {
          allowedTCPPorts = allowedTcpPorts;
          allowedUDPPorts = allowedUdpPorts;
        };
      };
    };

    # Prevent sshd from opening port 22 (circumventing the firewall)
    services.openssh.openFirewall = false;

    networking.nat = {
      enable = true;
      internalInterfaces = [
        "br0"
        "wlp4s0"
        "wlp1s0-1"
        "wg0" # ./wireguard.nix
      ];
      externalInterface = "enp2s0";
    };

    networking.bridges = {
      br0 = {
        interfaces = [
          "enp3s0"

          # This should be added by hostapd, but seems like there's an issue
          # when there are multiple BSSIDs on the same interface.
          "wlp1s0"
        ];
      };
    };

    networking.interfaces = {
      br0 = {
        ipv4.addresses = [
          {
            address = "${cfg.privateSubnet}.1";
            prefixLength = 24;
          }
        ];
      };
      wlp4s0 = {
        ipv4.addresses = [
          {
            address = "${cfg.guestSubnet}.1";
            prefixLength = 24;
          }
        ];
      };
      wlp1s0-1 = {
        ipv4.addresses = [
          {
            address = "${cfg.workSubnet}.1";
            prefixLength = 24;
          }
        ];
      };
    };

    networking.networkmanager.enable = false;

    services.dnsmasq = {
      enable = true;
      # TODO: extraConfig deprecated in favor of settings attribute set
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
        ${lib.concatStringsSep "\n" (map formatDnsInterface ["br0" "wlp4s0" "wlp1s0-1" "wg0"])}

        # subnet IP blocks to use DHCP on
        ${lib.concatStringsSep "\n" (map formatDhcpRange [cfg.privateSubnet cfg.guestSubnet cfg.workSubnet ])}

        # static IPs
        ${lib.concatStringsSep "\n" (lib.mapAttrsToList formatDhcpHost cfg.hosts)}
      '';
    };

    # Define host names to make dnsmasq resolve them, e.g. http://router.home
    networking.extraHosts =
      lib.concatStringsSep "\n" (lib.mapAttrsToList formatHostName cfg.hosts);

    # Some notes:
    # 2.4ghz network is for guests / IOT devices that don't need LAN discoverability
    # Work network is essentially also a guest network, but 5ghz (interference on 2.4ghz is too much for video calls)
    services.hostapd = {
      enable = true;
      radios = {
        # Compex WLE200NX
        wlp4s0 = {
          countryCode = "SE";
          channel = 6;
          band = "2g";
          settings = {
            logger_syslog = 127;
            logger_syslog_level = 2;
            logger_stdout = 127;
            logger_stdout_level = 2;
          };
          wifi4 = {
            enable = true;
            capabilities = [ "HT40+" "SHORT-GI-40" "TX-STBC" "RX-STBC1" "DSSS_CCK-40" ];
            require = false;
          };
          wifi5 = {
            enable = false;
          };
          networks = {
            wlp4s0 = {
              ssid = "icecreamiscream";
              authentication = {
                wpaPasswordFile = config.age.secrets.icecream_pw.path;
                # tmp hack to allow setting WPA-PSK auth
                # TODO: contribute to nixpkgs (allow WPA-PSK)
                mode = "none";
              };
              logLevel = 2;
              apIsolate = true;
              settings = {
                wpa = 2;
                wpa_key_mgmt = "WPA-PSK";
                wpa_pairwise = "CCMP";
              };
            };
          };
        };
        # Compex WLE600VX
        wlp1s0 = {
          countryCode = "SE";
          channel = 124;
          band = "5g";
          settings = {
            logger_syslog = 127;
            logger_syslog_level = 2;
            logger_stdout = 127;
            logger_stdout_level = 2;
          };
          wifi4 = {
            enable = true;
            capabilities = [ "HT40+" "SHORT-GI-40" "TX-STBC" "RX-STBC1" "DSSS_CCK-40" ];
            require = false;
          };
          networks = {
            wlp1s0 = {
              ssid = "morot";
              # As per comments from the hostapd module,
              # bssid is set to the interface MAC with the second character being incremented
              # 2, 6, A, ...
              bssid = "06:f0:21:b2:52:07";
              authentication = {
                wpaPasswordFile = config.age.secrets.morot_pw.path;
                mode = "none";
                # tmp hack to allow setting WPA-PSK auth
                # TODO: contribute to nixpkgs (allow WPA-PSK)
              };
              logLevel = 2;
              settings = {
                # Add to bridge once AP is live
                bridge = "br0";

                wpa = 2;
                wpa_key_mgmt = "WPA-PSK";
                wpa_pairwise = "CCMP";
              };
            };
            wlp1s0-1 = {
              ssid = "cybercorp";
              # As per comments from the hostapd module,
              # bssid is set to the interface MAC with the second character being incremented
              # 2, 6, A, ...
              bssid = "0a:f0:21:b2:52:07";
              authentication = {
                wpaPasswordFile = config.age.secrets.cybercorp_pw.path;
                # tmp hack to allow setting WPA-PSK auth
                # TODO: contribute to nixpkgs (allow WPA-PSK)
                mode = "none";
              };
              logLevel = 2;
              apIsolate = true;
              settings = {
                wpa = 2;
                wpa_key_mgmt = "WPA-PSK";
                wpa_pairwise = "CCMP";
              };
            };
          };
        };
      };
    };
  };
}
