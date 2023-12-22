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
        privateKeyFile = "/home/johanan/code/os/secrets/wireguard-private.key";

        dns = mkIf (!cfg.server && !cfg.remoteVpn) [
          "${cfg.serverSubnet}.1"
        ];

        listenPort = mkIf cfg.server cfg.port;

        peers = (if cfg.server then [
          {
            # voidm
            publicKey = "UpbNJCv+/TVcdYUU8fAgaO6WWAakzuPliYY3OccVeX4=";
            presharedKeyFile = "/home/johanan/code/os/secrets/wireguard-psk-lenovop1.key";
            allowedIPs = [
              "${cfg.subnet}.2/32"
            ];
          }
          {
            # Fairphone 4
            publicKey = "4vbU0LMSSJ83Xgz5VXYe7QLE0hA648lmN97bAWHzvDE=";
            presharedKeyFile = "/home/johanan/code/os/secrets/wireguard-psk-pixel4a.key";
            allowedIPs = [
              "${cfg.subnet}.3/32"
            ];
          }
          {
            # void0
            publicKey = "tcRy0wI2Zi2gR0uhVglwZqObV1k/G4Bhn5EGCLdanmk=";
            presharedKeyFile = "/home/johanan/code/os/secrets/wireguard-psk-void0.key";
            allowedIPs = [
              "${cfg.subnet}.4/32"
            ];
          }
          {
            # airm2
            publicKey = "h4QkyuAWO7Iq3ZlHOSIjmvFGTuqCLhZSr94HDNl4xyw=";
            presharedKeyFile = "/home/johanan/code/os/secrets/wireguard-psk-airm2.key";
            allowedIPs = [
              "${cfg.subnet}.5/32"
            ];
          }
          {
            # iPhone 15
            publicKey = "yikrWPt+Ayir6aK7BTrVQQ4mlkiQpwvdMZbGEBBFrzM=";
            presharedKeyFile = "/home/johanan/code/os/secrets/wireguard-psk-iphone15.key";
            allowedIPs = [
              "${cfg.subnet}.6/32"
            ];
          }
        ] else [ ]) ++ (if !cfg.server then
          [{
            # Router
            publicKey = "+52L7ozWbO40agAyfGO1rupLp532gYUNuv5xDoNkHjI=";
            presharedKeyFile = "/home/johanan/code/os/secrets/wireguard-psk-router.key";

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

      postUp = ''
        # Allow peers from wg0 to connect via router
        ${pkgs.iproute}/bin/ip route add ${cfg.subnet}.0/24 via ${cfg.serverSubnet}.1
      '';

      preDown = ''
        ${pkgs.iproute}/bin/ip route delete ${cfg.subnet}.0/24
      '';

      privateKeyFile = "/home/johanan/code/os/secrets/wireguard-private.key";

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
            # TODO: unreachable by wireguard peers connecting through router
            "::/0"
            "0.0.0.0/0"
          ];
          endpoint = "vpn52.prd.malmo.ovpn.com:9929";
          persistentKeepalive = 25;
        }
      ];
    };
  };
}
