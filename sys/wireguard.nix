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
    enable = mkEnableOption "enable";
    server = mkEnableOption "server";
    killswitch = mkEnableOption "killswitch";

    # TODO: refactor this option with composable arguments instead
    remoteVpn = mkEnableOption "remote vpn";

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
  config = mkIf cfg.enable {
    networking.wg-quick.interfaces.wg0 = {
      address =
        (if cfg.remoteVpn then [
          "172.17.227.39/32"
          "fd00:0000:1337:cafe:1111:1111:3470:fe26/128"
        ] else [
          "${cfg.subnet}.${toString cfg.uniqueId}/32"
        ]);
      privateKeyFile = "/home/johanan/os/secrets/wireguard-private.key";

      dns =
        (if (!cfg.server && !cfg.remoteVpn) then [
          "${cfg.serverSubnet}.1"
        ] else [ ]) ++
        (if (!cfg.server && cfg.remoteVpn) then [
          "217.64.148.33"
          "192.165.9.157"
          "2a07:a880:4601:12a0:adb::1"
          "2001:67c:750:1:adb::1"
        ] else [ ]);

      listenPort = mkIf cfg.server cfg.port;

      # TODO: drops local traffic too?
      postUp = if cfg.killswitch then ''
        ${pkgs.iptables}/bin/iptables -I OUTPUT ! -o wg0 -m mark ! --mark $(wg show wg0 fwmark) -m addrtype ! --dst-type LOCAL -j REJECT && ip6tables -I OUTPUT ! -o wg0 -m mark ! --mark $(wg show wg0 fwmark) -m addrtype ! --dst-type LOCAL -j REJECT
      '' else "";

      # TODO: drops local traffic too?
      preDown = if cfg.killswitch then ''
        ${pkgs.iptables}/bin/iptables -D OUTPUT ! -o wg0 -m mark ! --mark $(wg show  wg0 fwmark) -m addrtype ! --dst-type LOCAL -j REJECT && ip6tables -D OUTPUT ! -o wg0 -m mark ! --mark $(wg show  wg0 fwmark) -m addrtype ! --dst-type LOCAL -j REJECT
      '' else "";

      peers =
        if (!cfg.server) then [
          # Peers reachable by clients
          {
            # Router or remote VPN
            publicKey = (if cfg.remoteVpn then
              "ELx+DGi+E4Y+4m7Y7Bn2Y3Zo/4LuQJDR2U+WEskVigM="
            else
              "+52L7ozWbO40agAyfGO1rupLp532gYUNuv5xDoNkHjI="
            );
            presharedKeyFile = (if cfg.remoteVpn then null else "/home/johanan/os/secrets/wireguard-psk-router.key");
            allowedIPs = (if (cfg.remoteVpn) then [
              "0.0.0.0/0"
              "::/0"
            ] else [ "${cfg.subnet}.1/32" "${cfg.serverSubnet}.1/24" ]);
            endpoint = if (cfg.remoteVpn) then "vpn52.prd.malmo.ovpn.com:9929" else "vpn.skogsbrus.xyz:${toString cfg.port}";
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
          {
            # keeper
            publicKey = "5DovjTjDv07ZEiJdY7ISpunpgTdOmPZvrMXDF2VML30=";
            presharedKeyFile = "/home/johanan/os/secrets/wireguard-psk-keeper.key";
            allowedIPs = [
              "${cfg.subnet}.5/32"
            ];
          }
        ];
    };
  };
}
