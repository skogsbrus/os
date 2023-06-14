{ config
, pkgs
, lib
, ...
}:
let
  cfg = config.skogsbrus.router;
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

    networking = {
        firewall.extraCommands = lib.concatStrings([
        # Rewrite destination IP of of incoming HTTP(s) requests to Keeper
        # TODO: possible to get prerouting working without specifying the external IP?
        # Doesn't work with `-i enp1s0` as an alternative.
        ''
            iptables -A PREROUTING -t nat -p tcp -d 158.174.180.100 --dport 80 -j DNAT --to-destination 10.77.77.38:80
            iptables -A PREROUTING -t nat -p tcp -d 158.174.180.100 --dport 443 -j DNAT --to-destination 10.77.77.38:443
        ''
        # Forward incoming HTTP(s) requests with a destination IP to Keeper
        ''
            iptables -A FORWARD -i enp1s0 -p tcp --dport 80 -d 10.77.77.38 -j ACCEPT -m state --state NEW,RELATED,ESTABLISHED
            iptables -A FORWARD -i enp1s0 -p tcp --dport 443 -d 10.77.77.38 -j ACCEPT -m state --state NEW,RELATED,ESTABLISHED
        ''
        # Rewrite source IP of HTTP(s) requests for Keeper to Router
        ''
            iptables -A POSTROUTING -t nat -p tcp -d 10.77.77.38 --dport 80 -j SNAT --to-source 10.77.77.1
            iptables -A POSTROUTING -t nat -p tcp -d 10.77.77.38 --dport 443 -j SNAT --to-source 10.77.77.1
        '']);
        # Flush config on reload
        firewall.extraStopCommands = ''
          iptables -F
          ip6tables -F
        '';
        firewall.allowedTCPPorts = [ 80 443 ];
    };

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
            address = "${cfg.privateSubnet}.1";
            prefixLength = 24;
          }
        ];
      };
      wguest = {
        useDHCP = false;
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
        dhcp-range=${cfg.privateSubnet}.10,${cfg.privateSubnet}.254,24h
        dhcp-range=${cfg.guestSubnet}.10,${cfg.guestSubnet}.254,24h

        # static IPs
        # TODO: generalize with options
        dhcp-host=00:0d:b9:5e:22:91,${cfg.privateSubnet}.1
        dhcp-host=9c:6b:00:05:1c:b3,${cfg.privateSubnet}.38
        dhcp-host=00:11:32:33:30:5b,${cfg.privateSubnet}.65
        dhcp-host=30:9c:23:1b:a5:4d,${cfg.privateSubnet}.83
        dhcp-host=b8:27:eb:84:09:f8,${cfg.privateSubnet}.90
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
      # TODO: generalize with options
      interface = "wlp3s0";
      extraConfig = ''
        ### hostapd configuration file
        # generic
        beacon_int=100
        channel=0
        driver=nl80211
        country_code=SE
        interface=wlp3s0

        logger_syslog=127
        logger_syslog_level=2
        logger_stdout=127
        logger_stdout_level=2

        ieee80211d=1
        # Disable due to `DFS start_dfs_cac() failed, -1`
        ieee80211h=0
        ieee80211n=1
        # 'a'=5ghz, 'g'=2ghz
        hw_mode=g

        ht_capab=[HT40+][SHORT-GI-40][TX-STBC][RX-STBC1][DSSS_CCK-40]

        # private network
        ssid=morot
        auth_algs=1
        wpa_psk_file=/home/johanan/os/secrets/morot.pw
        wpa=2
        wpa_pairwise=CCMP
        wpa_key_mgmt=WPA-PSK

        bss=wguest
        ssid=icecreamiscream
        auth_algs=1
        ap_isolate=1
        wpa_psk_file=/home/johanan/os/secrets/icecreamiscream.pw
        wpa=2
        wpa_pairwise=CCMP
        wpa_key_mgmt=WPA-PSK
      '';
    };

    nixpkgs.overlays = [
      (self: super: {
        hostapd = super.hostapd.overrideAttrs (old: rec {
          patches = [ ];
          version = "2.10";
          src = (builtins.fetchGit {
            url = "http://w1.fi/hostap.git";
            ref = "main";
            rev = "72d4ca2fca983adbec82b0ef64dfcc2c9b971f5e";
          });
        });
      })
    ];
  };
}
