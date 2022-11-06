{ config
, lib
, pkgs
, ...
}:
let
  cfg = config.skogsbrus.wireguard;
  inherit (lib) mkEnableOption mkOption mkIf types;
in
{
  options.skogsbrus.wireguard = {
    localVpn = mkEnableOption "enable local VPN";
    server = mkEnableOption "server";
    killswitch = mkEnableOption "killswitch";

    # TODO: refactor this option with composable arguments instead
    remoteVpn = mkEnableOption "enable remote VPN";

    port = mkOption {
      type = types.port;
      example = 1234;
      description = "Port to use on the peer endpoint";
    };

    uniqueId = mkOption {
      type = types.int;
      example = 1;
      description = "ID of the peer. Must be unique. In range 0-255.";
    };

    subnet = mkOption {
      type = types.str;
      example = "10.0.0";
      description = "Subnet (/24) to use for WireGuard peers";
    };

    serverSubnet = mkOption {
      type = types.str;
      example = "192.168.1.1";
      description = "Subnet (/24) reachable by the server, that should be exposed to WireGuard peers";
    };
  };

  # TODO: parameterize things like presharedkey, public key
  config = {
    networking.wg-quick.interfaces.wg0 = mkIf cfg.localVpn
      {
        address = [
          "${cfg.subnet}.${toString cfg.uniqueId}/32"
        ];
        privateKeyFile = "/home/johanan/os/secrets/wireguard-private.key";

        dns = mkIf (!cfg.server && !cfg.remoteVpn) [
          "${cfg.serverSubnet}.1"
        ];

        listenPort = mkIf cfg.server cfg.port;

        peers = (if cfg.server then [
          {
            # voidm
            publicKey = "UpbNJCv+/TVcdYUU8fAgaO6WWAakzuPliYY3OccVeX4=";
            #presharedKeyFile = "/home/johanan/os/secrets/wireguard-psk-lenovop1.key";
            allowedIPs = [
              "${cfg.subnet}.2/32"
            ];
          }
          {
            # Fairphone 4
            publicKey = "4vbU0LMSSJ83Xgz5VXYe7QLE0hA648lmN97bAWHzvDE=";
            #presharedKeyFile = "/home/johanan/os/secrets/wireguard-psk-pixel4a.key";
            allowedIPs = [
              "${cfg.subnet}.3/32"
            ];
          }
          {
            # void0
            publicKey = "tcRy0wI2Zi2gR0uhVglwZqObV1k/G4Bhn5EGCLdanmk=";
            #presharedKeyFile = "/home/johanan/os/secrets/wireguard-psk-void0.key";
            allowedIPs = [
              "${cfg.subnet}.4/32"
            ];
          }
        ] else [ ]) ++ (if !cfg.server then
          [{
            # Router
            publicKey = "+52L7ozWbO40agAyfGO1rupLp532gYUNuv5xDoNkHjI=";
            #presharedKeyFile = "/home/johanan/os/secrets/wireguard-psk-router.key";

            # List of IP (v4 or v6) addresses with CIDR masks from
            # which this peer is allowed to send incoming traffic and to which
            # outgoing traffic for this peer is directed. The catch-all 0.0.0.0/0 may
            # be specified for matching all IPv4 addresses, and ::/0 may be specified
            # for matching all IPv6 addresses.
            allowedIPs = [ "${cfg.subnet}.0/24" "${cfg.serverSubnet}.0/24" ];

            endpoint = "vpn.skogsbrus.xyz:${toString cfg.port}";
            persistentKeepalive = 25;
          }] else [ ]);
      };

    networking.wg-quick.interfaces.wg1 = mkIf cfg.remoteVpn {
      address = [
        "172.17.227.39/32"
        "fd00:0000:1337:cafe:1111:1111:3470:fe26/128"
      ];

      privateKeyFile = "/home/johanan/os/secrets/wireguard-private.key";

      dns = [
        "217.64.148.33"
        "192.165.9.157"
        "2a07:a880:4601:12a0:adb::1"
        "2001:67c:750:1:adb::1"
      ];

      peers = [
        # Peers reachable by client
        {
          # OVPN
          publicKey = "ELx+DGi+E4Y+4m7Y7Bn2Y3Zo/4LuQJDR2U+WEskVigM=";

          # List of IP (v4 or v6) addresses with CIDR masks from
          # which this peer is allowed to send incoming traffic and to which
          # outgoing traffic for this peer is directed. The catch-all 0.0.0.0/0 may
          # be specified for matching all IPv4 addresses, and ::/0 may be specified
          # for matching all IPv6 addresses.
          allowedIPs = [
            "::/0"
            "0.0.0.0/0"
            # TODO: possible to interpolate bash subshell? depend on cfg.subnet
            # & cfg.serverSubnet instead
            # - `netmask -c 0.0.0.0:10.66.66.0`
            # - `netmask -c 10.66.67.0:10.77.77.0`
            # - `netmask -c 10.77.78.0:255.255.255.255`
            #"0.0.0.0/5"
            #"8.0.0.0/7"
            #"10.0.0.0/10"
            #"10.64.0.0/15"
            #"10.66.0.0/18"
            #"10.66.64.0/23"
            ##10.66.66.0/24 ignored"
            #"10.66.67.0/24"
            #"10.66.68.0/22"
            #"10.66.72.0/21"
            #"10.66.80.0/20"
            #"10.66.96.0/19"
            #"10.66.128.0/17"
            #"10.67.0.0/16"
            #"10.68.0.0/14"
            #"10.72.0.0/14"
            #"10.76.0.0/16"
            #"10.77.0.0/18"
            #"10.77.64.0/21"
            #"10.77.72.0/22"
            #"10.77.76.0/24"
            ## 10.77.77.0/24 ignored
            #"10.78.0.0/15"
            #"10.80.0.0/12"
            #"10.96.0.0/11"
            #"10.128.0.0/9"
            #"11.0.0.0/8"
            #"12.0.0.0/6"
            #"16.0.0.0/4"
            #"32.0.0.0/3"
            #"64.0.0.0/2"
            #"128.0.0.0/1"
          ];
          endpoint = "vpn52.prd.malmo.ovpn.com:9929";
          persistentKeepalive = 25;
        }
      ];

      # TODO: drops local traffic too?
      # postUp = if cfg.killswitch then ''
      #   ${pkgs.iptables}/bin/iptables -I OUTPUT ! -o wg0 -m mark ! --mark $(wg show wg0 fwmark) -m addrtype ! --dst-type LOCAL -j REJECT && ip6tables -I OUTPUT ! -o wg0 -m mark ! --mark $(wg show wg0 fwmark) -m addrtype ! --dst-type LOCAL -j REJECT
      # '' else "";

      # TODO: drops local traffic too?
      # preDown = if cfg.killswitch then ''
      #   ${pkgs.iptables}/bin/iptables -D OUTPUT ! -o wg0 -m mark ! --mark $(wg show  wg0 fwmark) -m addrtype ! --dst-type LOCAL -j REJECT && ip6tables -D OUTPUT ! -o wg0 -m mark ! --mark $(wg show  wg0 fwmark) -m addrtype ! --dst-type LOCAL -j REJECT
      # '' else "";
    };
  };
}
