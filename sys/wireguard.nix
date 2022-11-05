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
    networking.wg-quick.interfaces.wg0 = mkIf cfg.localVpn {
      address = [
        "${cfg.subnet}.${toString cfg.uniqueId}/32"
      ];
      privateKeyFile = "/home/johanan/os/secrets/wireguard-private.key";

      dns = mkIf (!cfg.server) [
        "${cfg.serverSubnet}.1"
      ];

      listenPort = mkIf cfg.server cfg.port;

      peers =
        if (!cfg.server) then [
          # Peers reachable by clients
          {
            # Router
            publicKey = "+52L7ozWbO40agAyfGO1rupLp532gYUNuv5xDoNkHjI=";
            presharedKeyFile = "/home/johanan/os/secrets/wireguard-psk-router.key";
            allowedIPs = [ "${cfg.subnet}.1/32" "${cfg.serverSubnet}.1/24" ];
            endpoint = "vpn.skogsbrus.xyz:${toString cfg.port}";
            persistentKeepalive = 25;
          }
        ] else [
          # Peers reachable by the server
          {
            # voidm
            publicKey = "UpbNJCv+/TVcdYUU8fAgaO6WWAakzuPliYY3OccVeX4=";
            presharedKeyFile = "/home/johanan/os/secrets/wireguard-psk-lenovop1.key";
            allowedIPs = [
              "${cfg.subnet}.2/32"
            ];
          }
          {
            # Fairphone 4
            publicKey = "4vbU0LMSSJ83Xgz5VXYe7QLE0hA648lmN97bAWHzvDE=";
            presharedKeyFile = "/home/johanan/os/secrets/wireguard-psk-pixel4a.key";
            allowedIPs = [
              "${cfg.subnet}.3/32"
            ];
          }
          {
            # void0
            publicKey = "tcRy0wI2Zi2gR0uhVglwZqObV1k/G4Bhn5EGCLdanmk=";
            presharedKeyFile = "/home/johanan/os/secrets/wireguard-psk-void0.key";
            allowedIPs = [
              "${cfg.subnet}.4/32"
            ];
          }
        ];
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
          allowedIPs = [
            # Tunnel everything except local traffic
            "0.0.0.0/5"
            "8.0.0.0/7"
            "11.0.0.0/8"
            "12.0.0.0/6"
            "16.0.0.0/4"
            "32.0.0.0/3"
            "64.0.0.0/2"
            "128.0.0.0/3"
            "160.0.0.0/5"
            "168.0.0.0/6"
            "172.0.0.0/12"
            "172.17.0.0/16" # VPN's block (estimate)
            "185.86.0.0/16" # VPN's block (estimate)
            "172.64.0.0/10"
            "172.128.0.0/9"
            "173.0.0.0/8"
            "174.0.0.0/7"
            "176.0.0.0/4"
            "192.0.0.0/9"
            "192.128.0.0/11"
            "192.160.0.0/13"
            "192.169.0.0/16"
            "192.170.0.0/15"
            "192.172.0.0/14"
            "192.176.0.0/12"
            "192.192.0.0/10"
            "193.0.0.0/8"
            "194.0.0.0/7"
            "196.0.0.0/6"
            "200.0.0.0/5"
            "208.0.0.0/4"
            "224.0.0.0/5"
            "232.0.0.0/7"
            "::/0" # Assume we don't have ipV6 on LAN
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
