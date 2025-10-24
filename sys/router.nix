{ config
, pkgs
, lib
, private
, ...
}:
let
  cfg = config.skogsbrus.router;
  dhcpLease = "infinite";
  dnsMasqFormatDhcpHost = key: value: "${key},${value.ip}";
  formatHostName = key: value: "${value.ip} ${value.name}";
  dnsMasqFormatDhcpRange = x:  "${x}.10,${x}.245,${dhcpLease}";
  mergeAttrSets = attrsets: builtins.foldl' lib.recursiveUpdate { } attrsets;

  dnsEnabledInterfaces = ["vlan10trusted" "vlan20work" "vlan30iot" "wg0" ];
  dhcpEnabledIpSubnets = [
    "10.77.77.10,10.77.77.126,infinite"  # VLAN 10: Trusted (10.77.77.10-126)
    "10.77.77.130,10.77.77.212,infinite"  # VLAN 20: Work (10.77.77.130-212)
    "10.77.77.215,10.77.77.254,infinite"  # VLAN 30: IoT (10.77.77.215-254)
  ];
  staticIps = lib.mapAttrsToList dnsMasqFormatDhcpHost cfg.hosts;

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
      trustedInterfaces = [ "br0" "wg0" ];

      extraCommands = lib.concatStrings ([
        # Keeper NAT rules (Keeper hosts public services on trusted VLAN)
        ''
          # External access to Keeper via public domain (WAN --> router --> Keeper)
          iptables -A PREROUTING -t nat -i enp2s0 -p tcp -m addrtype --dst-type LOCAL --dport 80 -j DNAT --to-destination 10.77.77.38:80
          iptables -A PREROUTING -t nat -i enp2s0 -p tcp -m addrtype --dst-type LOCAL --dport 443 -j DNAT --to-destination 10.77.77.38:443

          # Hairpin NAT for trusted VLAN to reach Keeper via public domain
          iptables -A PREROUTING -t nat -i vlan10trusted -p tcp -m addrtype --dst-type LOCAL --dport 80 -j DNAT --to-destination 10.77.77.38:80
          iptables -A PREROUTING -t nat -i vlan10trusted -p tcp -m addrtype --dst-type LOCAL --dport 443 -j DNAT --to-destination 10.77.77.38:443

          # Forward external requests to Keeper (public services)
          iptables -A FORWARD -i enp2s0 -p tcp --dport 80 -d 10.77.77.38 -j ACCEPT -m state --state NEW,RELATED,ESTABLISHED
          iptables -A FORWARD -i enp2s0 -p tcp --dport 443 -d 10.77.77.38 -j ACCEPT -m state --state NEW,RELATED,ESTABLISHED

          # SNAT for Keeper requests (source NAT for return traffic)
          iptables -A POSTROUTING -t nat -p tcp -d 10.77.77.38 --dport 80 -j SNAT --to-source 10.77.77.1
          iptables -A POSTROUTING -t nat -p tcp -d 10.77.77.38 --dport 443 -j SNAT --to-source 10.77.77.1
        ''

        # VLAN Isolation Rules (within trusted interfaces)
        ''
          # VLAN 10 (Trusted): Can access all VLANs (10.77.77.1-126)
          iptables -A FORWARD -i br0 -s 10.77.77.1/25 -d 10.77.77.0/24 -j ACCEPT
          iptables -A FORWARD -i br0 -d 10.77.77.1/25 -s 10.77.77.0/24 -j ACCEPT

          # VLAN 20 (Work): Completely isolated from all other VLANs (10.77.77.129-212)
          # Note: Cisco Meraki (68:3a:1e:34:32:38) is part of the work network
          iptables -A FORWARD -i br0 -s 10.77.77.129/25 -d 10.77.77.1/25 -j DROP
          iptables -A FORWARD -i br0 -s 10.77.77.129/25 -d 10.77.77.214/26 -j DROP
          iptables -A FORWARD -i br0 -d 10.77.77.129/25 -s 10.77.77.1/25 -j DROP
          iptables -A FORWARD -i br0 -d 10.77.77.129/25 -s 10.77.77.214/26 -j DROP

          # VLAN 30 (IoT): Isolated from all other VLANs (10.77.77.214-254)
          iptables -A FORWARD -i br0 -s 10.77.77.214/26 -d 10.77.77.1/25 -j DROP
          iptables -A FORWARD -i br0 -s 10.77.77.214/26 -d 10.77.77.129/25 -j DROP
          iptables -A FORWARD -i br0 -d 10.77.77.214/26 -s 10.77.77.1/25 -j DROP
          iptables -A FORWARD -i br0 -d 10.77.77.214/26 -s 10.77.77.129/25 -j DROP

          # Allow WireGuard to access all VLANs
          iptables -A FORWARD -i wg0 -d 10.77.77.0/24 -j ACCEPT
          iptables -A FORWARD -o wg0 -s 10.77.77.0/24 -j ACCEPT

          # Allow all VLANs internet access
          iptables -A FORWARD -s 10.77.77.0/24 -o enp2s0 -j ACCEPT
          iptables -A FORWARD -i enp2s0 -d 10.77.77.0/24 -m state --state RELATED,ESTABLISHED -j ACCEPT
        ''

        # Device-specific isolation rules (by MAC address)
        ''
          # Cisco Meraki (68:3a:1e:34:32:38): Isolated from personal networks
          # Block Meraki from accessing Trusted VLAN (including Keeper at 10.77.77.38)
          iptables -A FORWARD -i br0 -m mac --mac-source 68:3a:1e:34:32:38 -d 10.77.77.1/25 -j DROP
          iptables -A FORWARD -i br0 -d 10.77.77.1/25 -m mac --mac-destination 68:3a:1e:34:32:38 -j DROP

          # Block Meraki from accessing IoT VLAN
          iptables -A FORWARD -i br0 -m mac --mac-source 68:3a:1e:34:32:38 -d 10.77.77.214/26 -j DROP
          iptables -A FORWARD -i br0 -d 10.77.77.214/26 -m mac --mac-destination 68:3a:1e:34:32:38 -j DROP

          # Allow Meraki internet access
          iptables -A FORWARD -i br0 -m mac --mac-source 68:3a:1e:34:32:38 -o enp2s0 -j ACCEPT
          iptables -A FORWARD -i enp2s0 -o br0 -m mac --mac-destination 68:3a:1e:34:32:38 -m state --state RELATED,ESTABLISHED -j ACCEPT
        ''
      ]);

      # Flush config on reload
      extraStopCommands = ''
        iptables -F
        iptables -t nat -F
        ip6tables -F
        ip6tables -t nat -F || true
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
        "vlan10trusted"
        "vlan20work"
        "vlan30iot"
      ];
      externalInterface = "enp2s0";
    };

    networking.bridges = {
      br0 = {
        interfaces = [
          "enp3s0"
          # wireless interface added by hostapd
        ];
      };
    };

    # VLAN Configuration for Network Isolation
    networking.vlans = {
      # VLAN 10: Trusted Devices (10.77.77.1/24 - 10.77.77.85/24)
      vlan10trusted = {
        id = 10;
        interface = "br0";
      };

      # VLAN 20: Work Devices (10.77.77.129/25 - 10.77.77.213/25)
      vlan20work = {
        id = 20;
        interface = "wlp1s0-1";
      };

      # VLAN 30: IoT Devices (10.77.77.214/26 - 10.77.77.255/26)
      vlan30iot = {
        id = 30;
        interface = "wlp4s0";
      };

    };

    # Legacy interface configurations (kept for compatibility)
    # These will be replaced by VLAN configurations above
    networking.interfaces = {
      vlan10trusted.ipv4.addresses = [
        {
          address = "10.77.77.1";
          prefixLength = 25;
        }
      ];
      vlan20work.ipv4.addresses = [
        {
          address = "10.77.77.129";
          prefixLength = 25;
        }
      ];
      vlan30iot.ipv4.addresses = [
        {
          address = "10.77.77.214";
          prefixLength = 26;
        }
      ];
      # br0 will be managed by VLAN 10 (trusted)
      # wlp4s0 will be managed by VLAN 30 (IoT)
      # wlp1s0-1 will be managed by VLAN 20 (work)
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
                # Assign to VLAN 30 (IoT)
                vlan_bridge = "br0";
                vlan_tagged_interface = "br0";
                vlan_naming = 1;
                dynamic_vlan = 1;
                vlan_file = "/etc/hostapd/vlan";
                # Default VLAN for icecreamiscream network
                default_vlan = 30;
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
                # Assign to VLAN 10 (Trusted)
                vlan_bridge = "br0";
                vlan_tagged_interface = "br0";
                vlan_naming = 1;
                dynamic_vlan = 1;
                vlan_file = "/etc/hostapd/vlan";
                # Default VLAN for morot network
                default_vlan = 10;
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
                # tmp hack to allow setting WPA-PSK auth
                # TODO: contribute to nixpkgs (allow WPA-PSK)
                mode = "none";
              };
              logLevel = 2;
              # Remove apIsolate to allow work devices to communicate with each other
              # apIsolate = true;
              settings = {
                wpa = 2;
                wpa_key_mgmt = "WPA-PSK";
                wpa_pairwise = "CCMP";
                # Assign to VLAN 20 (Work)
                vlan_bridge = "br0";
                vlan_tagged_interface = "br0";
                vlan_naming = 1;
                dynamic_vlan = 1;
                vlan_file = "/etc/hostapd/vlan";
                # Default VLAN for cybercorp network
                default_vlan = 20;
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

    # Create VLAN configuration file for hostapd
    environment.etc."hostapd/vlan" = {
      text = ''
        # VLAN configuration for hostapd
        # Format: MAC_ADDRESS VLAN_ID
        #
        # Default VLAN assignments by network:
        # - morot network (wlp1s0): default_vlan = 10 (Trusted)
        # - cybercorp network (wlp1s0-1): default_vlan = 20 (Work)
        # - icecreamiscream network (wlp4s0): default_vlan = 30 (IoT)
        #
        # All devices connecting to each network will automatically
        # be assigned to the corresponding VLAN unless overridden below.

        # Override specific devices (uncomment and modify as needed):
        # 48:e1:5c:6c:3f:5a 10  # Apple device -> Force Trusted VLAN
        # 68:3a:1e:34:32:38 20  # Cisco Meraki -> Force Work VLAN
        # 7e:4f:5a:95:c1:f2 30  # Unknown device -> Force IoT VLAN
        # d8:8c:79:1c:d4:00 30  # Google device -> Force IoT VLAN
      '';
      mode = "0644";
    };
  };
}
