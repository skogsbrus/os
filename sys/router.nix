{ config
, pkgs
, lib
, ...
}:
let
  cfg = config.skogsbrus.router;
  externalIp = "78.82.197.99";
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
    networking.interfaces.enp2s0.useDHCP = true;
    networking.interfaces.enp3s0.useDHCP = true;
    networking.interfaces.wlp1s0.useDHCP = true;

    networking.firewall = {
      enable = true;
      trustedInterfaces = [ "br0" "wg0" "wlp4s0" ];

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

      interfaces = {
        enp2s0 = {
          allowedTCPPorts = [ 80 443 ];
          allowedUDPPorts = [
            # Wireguard
            666
          ];
        };
        # https://serverfault.com/a/424226
        #wlp4s0 = {
        #  allowedTCPPorts = [
        #    # DNS
        #    53
        #    # HTTP(S)
        #    80
        #    443
        #    110
        #    # Email (pop3, pop3s)
        #    995
        #    114
        #    # Email (imap, imaps)
        #    993
        #    # Email (SMTP Submission RFC 6409)
        #    587
        #    # Git
        #    2222
        #    # Roborock
        #    8883
        #  ];
        #  allowedUDPPorts = [
        #    # https://serverfault.com/a/424226
        #    # DNS
        #    53
        #    # DHCP
        #    67
        #    68
        #    # NTP
        #    123
        #    # Wireguard
        #    666
        #    # Roborock
        #    58866
        #  ];
        #};
      };
    };

    # Prevent sshd from opening port 22 (circumventing the firewall)
    services.openssh.openFirewall = false;

    networking.nat = {
      enable = true;
      internalInterfaces = [
        "br0"
        "wlp4s0"
        "wg0" # ./wireguard.nix
      ];
      externalInterface = "enp2s0";
    };

    networking.bridges = {
      br0 = {
        interfaces = [
          "enp3s0"
          # Wireless interfaces should be added by hostapd ('bridge=1')
        ];
      };
    };

    networking.interfaces = {
      br0 = {
        useDHCP = false;
        ipv4.addresses = [
          {
            address = "${cfg.privateSubnet}.1";
            prefixLength = 24;
          }
        ];
      };
      wlp4s0 = {
        useDHCP = true;
        ipv4.addresses = [
          {
            address = "${cfg.guestSubnet}.1";
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
        server=8.8.8.8
        server=9.9.9.9
        server=1.1.1.1

        # local domains
        expand-hosts
        domain=home
        local=/home/

        # Interfaces to use DNS on
        interface=br0
        interface=wlp4s0
        interface=wg0

        # subnet IP blocks to use DHCP on
        dhcp-range=${cfg.privateSubnet}.10,${cfg.privateSubnet}.254,24h
        dhcp-range=${cfg.guestSubnet}.10,${cfg.guestSubnet}.254,24h

        # static IPs
        # TODO: generalize with options
        dhcp-host=00:0d:b9:5e:22:91,${cfg.privateSubnet}.1
        dhcp-host=9c:6b:00:05:1c:b3,${cfg.privateSubnet}.38
        dhcp-host=00:11:32:33:30:5b,${cfg.privateSubnet}.65
        dhcp-host=30:9c:23:1b:a5:4d,${cfg.privateSubnet}.83
        dhcp-host=b8:27:eb:84:09:f8,${cfg.privateSubnet}.90
        # roborock
        dhcp-host=9a:f1:c3:61:03:a0,${cfg.guestSubnet}.19
      '';
    };

    # Define host names to make dnsmasq resolve them, e.g. http://router.home
    # TODO: generalize with options
    networking.extraHosts =
      ''
        ${cfg.privateSubnet}.1 router
        ${cfg.privateSubnet}.38 keeper
        ${cfg.privateSubnet}.65 choklad
        ${cfg.privateSubnet}.83 workstation
        ${cfg.privateSubnet}.90 kodi
      '';

    services.hostapd = {
      enable = true;
      radios = {
        # Compex WLE200NX
        wlp4s0 = {
          countryCode = "SE";
          channel = 0;
          band = "2g";
          settings = {
            logger_syslog = 127;
            logger_syslog_level = 1;
            logger_stdout = 127;
            logger_stdout_level = 1;
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
                mode = "wpa2-sha256";
              };
              logLevel = 2;
              settings = {
                ieee80211w = 0;
                wmm_enabled = false;
                sae_require_mfp = false;
              };
            };
          };
        };
        # Compex WLE600VX
        wlp1s0 = {
          countryCode = "SE";
          channel = 0;
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
              authentication = {
                wpaPasswordFile = config.age.secrets.morot_pw.path;
                mode = "wpa2-sha256";
              };
              logLevel = 2;
              settings = {
                # Add to bridge once AP is live
                bridge = "br0";
              };
            };
          };
        };
      };
    };
  };
}
