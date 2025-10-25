{ config
, pkgs
, lib
, private
, ...
}:
let
  cfg = config.skogsbrus.router;
  dhcpLease = "infinite";
  externalEthInterfaceId = "enp2s0";
  internalEthInterfaceId = "enp3s0";
  dnsMasqFormatDhcpHost = key: value: "${value.mac},${vlanIpConfigs.${value.vlan}.base}.${value.ipSuffix}";
  formatHostName = key: value: "${vlanIpConfigs.${value.vlan}.base}.${value.ipSuffix} ${key}";
  mergeAttrSets = attrsets: builtins.foldl' lib.recursiveUpdate { } attrsets;

  dnsEnabledInterfaces = [
    #"vlan10trusted"
    "vlan20work"
    "vlan30iot"
    "wg0"
    "br0"
    "wlp4s0"
    "wlp1s0-1"
  ];
  dhcpEnabledIpSubnets = [
    "br0,${vlanIpConfigs.trusted.start},${vlanIpConfigs.trusted.end},infinite"
    "wlp1s0-1,${vlanIpConfigs.work.start},${vlanIpConfigs.work.end},infinite"
    "wlp4s0,${vlanIpConfigs.iot.start},${vlanIpConfigs.iot.end},infinite"
  ];
  staticIps = lib.mapAttrsToList dnsMasqFormatDhcpHost cfg.hosts;

  vlanIpConfigs = {
    trusted = {
      start = "10.77.77.2";
      end = "10.77.77.127";
      base = "10.77.77";
      cidr = "10.77.77.0/25";
    };
    work = {
      start = "10.88.88.2";
      end = "10.88.88.127";
      base = "10.88.88";
      cidr = "10.88.88.0/25";
    };
    iot = {
      start = "10.99.99.2";
      end = "10.99.99.127";
      base = "10.99.99";
      cidr = "10.99.99.0/25";
    };
  };

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

    publicIp = mkOption {
      type = types.str;
      example = "192.168.1.1";
      description = "Public IP of the router";
    };

    privateSubnet = mkOption {
      type = types.str;
      example = "192.168.1";
      description = "IP block (/24) to use for the private subnet";
    };

    hosts = mkOption {
      type = types.attrsOf (types.attrsOf types.str);
      default = { };
      example = {
        bobsPhone = {
          ipSuffix = "1";
          mac = "00:00:00:00";
          vlan = "foobar";
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

    age.secrets.ddclient_pw = {
      file = ../secrets/ddclient.age;
      owner = "root";
      group = "root";
      mode = "400";
    };

    services.ddclient = {
      enable = true;
      use = "web, web=checkip.amazonaws.com, web-skip=''";
      protocol = "namecheap";
      server = "dynamicdns.park-your-domain.com";
      username = "skogsbrus.xyz";
      passwordFile = config.age.secrets.ddclient_pw.path;
      domains = [ "vpn" "www.vpn" ];
    };

    networking.hostName = "router";
    networking.useDHCP = false;

    # request an IP from ISP
    networking.interfaces.enp2s0.useDHCP = true;

    networking.firewall = {
      enable = true;
      extraCommands = lib.concatStrings ([
        # Keeper NAT rules
        ''
          # External access to Keeper via public domain (WAN --> router --> Keeper)
          iptables -A PREROUTING -t nat -i ${externalEthInterfaceId} -p tcp -m addrtype --dst-type LOCAL --dport 80 -j DNAT --to-destination ${vlanIpConfigs.trusted.base}.${cfg.hosts.keeper.ipSuffix}:80
          iptables -A PREROUTING -t nat -i ${externalEthInterfaceId} -p tcp -m addrtype --dst-type LOCAL --dport 443 -j DNAT --to-destination ${vlanIpConfigs.trusted.base}.${cfg.hosts.keeper.ipSuffix}:443

          # Hairpin NAT for trusted VLAN to reach Keeper via public domain
          iptables -A PREROUTING -t nat -i br0 -p tcp -m addrtype --dst-type LOCAL --dport 80 -j DNAT --to-destination ${vlanIpConfigs.trusted.base}.${cfg.hosts.keeper.ipSuffix}:80
          iptables -A PREROUTING -t nat -i br0 -p tcp -m addrtype --dst-type LOCAL --dport 443 -j DNAT --to-destination ${vlanIpConfigs.trusted.base}.${cfg.hosts.keeper.ipSuffix}:443

          # Forward external requests to Keeper (public services)
          iptables -A FORWARD -i ${externalEthInterfaceId} -p tcp --dport 80 -d ${vlanIpConfigs.trusted.base}.${cfg.hosts.keeper.ipSuffix} -j ACCEPT -m state --state NEW,RELATED,ESTABLISHED
          iptables -A FORWARD -i ${externalEthInterfaceId} -p tcp --dport 443 -d ${vlanIpConfigs.trusted.base}.${cfg.hosts.keeper.ipSuffix} -j ACCEPT -m state --state NEW,RELATED,ESTABLISHED

          # SNAT for Keeper requests (source NAT for return traffic)
          iptables -A POSTROUTING -t nat -p tcp -d ${vlanIpConfigs.trusted.base}.${cfg.hosts.keeper.ipSuffix} --dport 80 -j SNAT --to-source ${vlanIpConfigs.trusted.base}.${cfg.hosts.router.ipSuffix}
          iptables -A POSTROUTING -t nat -p tcp -d ${vlanIpConfigs.trusted.base}.${cfg.hosts.keeper.ipSuffix} --dport 443 -j SNAT --to-source ${vlanIpConfigs.trusted.base}.${cfg.hosts.router.ipSuffix}
        ''

        # VLAN Isolation Rules
        ''
          # VLAN 10 (Trusted): Can access all VLANs
          #iptables -A FORWARD -i br0 -s ${vlanIpConfigs.trusted.cidr} -d ${vlanIpConfigs.trusted.cidr} -j ACCEPT
          #iptables -A FORWARD -i br0 -d ${vlanIpConfigs.trusted.cidr} -s ${vlanIpConfigs.trusted.cidr} -j ACCEPT
          #iptables -A FORWARD -i br0 -s ${vlanIpConfigs.trusted.cidr} -d ${vlanIpConfigs.work.cidr}    -j ACCEPT
          #iptables -A FORWARD -i br0 -s ${vlanIpConfigs.trusted.cidr} -d ${vlanIpConfigs.work.cidr}    -j ACCEPT
          #iptables -A FORWARD -i br0 -d ${vlanIpConfigs.trusted.cidr} -s ${vlanIpConfigs.iot.cidr}     -j ACCEPT
          #iptables -A FORWARD -i br0 -d ${vlanIpConfigs.trusted.cidr} -s ${vlanIpConfigs.iot.cidr}     -j ACCEPT

          ## VLAN 20 (Work): Isolated from all other VLANs
          #iptables -A FORWARD -i br0 -s ${vlanIpConfigs.work.cidr} -d ${vlanIpConfigs.trusted.cidr} -j DROP
          #iptables -A FORWARD -i br0 -s ${vlanIpConfigs.work.cidr} -d ${vlanIpConfigs.iot.cidr}     -j DROP
          #iptables -A FORWARD -i br0 -d ${vlanIpConfigs.work.cidr} -s ${vlanIpConfigs.trusted.cidr} -j DROP
          #iptables -A FORWARD -i br0 -d ${vlanIpConfigs.work.cidr} -s ${vlanIpConfigs.iot.cidr}     -j DROP

          ## VLAN 30 (IoT): Isolated from all other VLANs
          #iptables -A FORWARD -i br0 -s ${vlanIpConfigs.iot.cidr} -d ${vlanIpConfigs.trusted.cidr} -j DROP
          #iptables -A FORWARD -i br0 -s ${vlanIpConfigs.iot.cidr} -d ${vlanIpConfigs.work.cidr}     -j DROP
          #iptables -A FORWARD -i br0 -d ${vlanIpConfigs.iot.cidr} -s ${vlanIpConfigs.trusted.cidr} -j DROP
          #iptables -A FORWARD -i br0 -d ${vlanIpConfigs.iot.cidr} -s ${vlanIpConfigs.work.cidr}     -j DROP

          # WireGuard: can access all VLANs
          iptables -A FORWARD -i wg0 -d ${vlanIpConfigs.trusted.cidr} -j ACCEPT
          iptables -A FORWARD -o wg0 -s ${vlanIpConfigs.trusted.cidr} -j ACCEPT
          iptables -A FORWARD -i wg0 -d ${vlanIpConfigs.iot.cidr} -j ACCEPT
          iptables -A FORWARD -o wg0 -s ${vlanIpConfigs.iot.cidr} -j ACCEPT
          iptables -A FORWARD -i wg0 -d ${vlanIpConfigs.work.cidr} -j ACCEPT
          iptables -A FORWARD -o wg0 -s ${vlanIpConfigs.work.cidr} -j ACCEPT

          # Allow all VLANs internet access
          iptables -A FORWARD -s ${vlanIpConfigs.trusted.cidr} -o ${externalEthInterfaceId} -j ACCEPT
          iptables -A FORWARD -i ${externalEthInterfaceId} -d ${vlanIpConfigs.trusted.cidr} -m state --state RELATED,ESTABLISHED -j ACCEPT
          iptables -A FORWARD -s ${vlanIpConfigs.work.cidr} -o ${externalEthInterfaceId} -j ACCEPT
          iptables -A FORWARD -i ${externalEthInterfaceId} -d ${vlanIpConfigs.work.cidr} -m state --state RELATED,ESTABLISHED -j ACCEPT
          iptables -A FORWARD -s ${vlanIpConfigs.iot.cidr} -o ${externalEthInterfaceId} -j ACCEPT
          iptables -A FORWARD -i ${externalEthInterfaceId} -d ${vlanIpConfigs.iot.cidr} -m state --state RELATED,ESTABLISHED -j ACCEPT
        ''
      ]);

      # Flush config on reload
      extraStopCommands = ''
        iptables -F
        iptables -t nat -F
        ip6tables -F
        ip6tables -t nat -F || true
      '';

      trustedInterfaces = [
        "br0"
        "wg0"
        #"vlan10trusted"
      ];
      interfaces = {
        "${externalEthInterfaceId}" = {
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
        #"vlan10trusted"
        "vlan20work"
        "vlan30iot"
      ];
      externalInterface = externalEthInterfaceId;
    };

    networking.bridges = {
      br0 = {
        interfaces = [
          internalEthInterfaceId
          # wireless interface added by hostapd
        ];
      };
    };

    # VLAN Configuration for Network Isolation
    networking.vlans = {
      # VLAN 10: Trusted Devices
      #vlan10trusted = {
      #  id = 10;
      #  interface = "br0";
      #};

      # VLAN 20: Work Devices
      vlan20work = {
        id = 20;
        interface = "wlp1s0-1";
      };

      # VLAN 30: IoT Devices and guests
      vlan30iot = {
        id = 30;
        interface = "wlp4s0";
      };

    };

    networking.interfaces = {
      br0.ipv4.addresses = [
        {
          address = "${vlanIpConfigs.trusted.start}";
          prefixLength = 25;
        }
      ];
      #vlan10trusted.ipv4.addresses = [
      #  {
      #    address = "${vlanIpConfigs.trusted.start}";
      #    prefixLength = 25;
      #  }
      #];
      vlan20work.ipv4.addresses = [
        {
          address = "${vlanIpConfigs.work.start}";
          prefixLength = 25;
        }
      ];
      vlan30iot.ipv4.addresses = [
        {
          address = "${vlanIpConfigs.iot.start}";
          prefixLength = 25;
        }
      ];
    };

    networking.networkmanager.enable = false;

    services.dnsmasq = {
      enable = true;
      settings = mergeAttrSets [
          {
            # sensible behaviours
            domain-needed = true;
            bogus-priv = true;
            no-resolv = true;

            # upstream name servers
            server = [ "9.9.9.9" "1.1.1.1" ];
            expand-hosts = true;

            # local domains
            domain = "home";
            local = "/home/";
          }
          { interface = dnsEnabledInterfaces; }
          { dhcp-range = dhcpEnabledIpSubnets; }
          { dhcp-host = staticIps; }
      ];
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
            # TODO: 20MHz instead?
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
                mode = "wpa2-sha1";
              };
              logLevel = 2;
              apIsolate = true;
              settings = {
                bridge = "vlan30iot";
              };
            };
          };
          settings = {
            # Country code and 80211d are set manually to avoid 80211h when
            # countryCode is set (NIC seems to freak out when doing DFS)
            country_code = "SE";
            ieee80211d = true;
          };
        };
        # Compex WLE600VX
        wlp1s0 = {
          channel = 36;
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
              # BSSID is hidden to prevent geo-lookup from WiFi databases
              # At the time of writing, the hostapd module requires manually
              # set BSSIDs for interfaces with multiple networks
              bssid = private.router.bssids.wlp1s0;
              authentication = {
                wpaPasswordFile = config.age.secrets.morot_pw.path;
                mode = "wpa2-sha1";
              };
              logLevel = 2;
              settings = {
                bridge = "br0";
              };
            };
            wlp1s0-1 = {
              ssid = "cybercorp";
              # BSSID is hidden to prevent geo-lookup from WiFi databases
              # At the time of writing, the hostapd module requires manually
              # set BSSIDs for interfaces with multiple networks
              bssid = private.router.bssids.wlp1s01;
              authentication = {
                wpaPasswordFile = config.age.secrets.cybercorp_pw.path;
                mode = "wpa2-sha1";
              };
              logLevel = 2;
              settings = {
                bridge = "vlan20work";
              };
            };
          };
          settings = {
            # Country code and 80211d are set manually to avoid 80211h when
            # countryCode is set (NIC seems to freak out when doing DFS)
            country_code = "SE";
            ieee80211d = false;
          };
        };
      };
    };
  };
}
