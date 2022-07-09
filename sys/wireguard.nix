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

    port = mkOption {
      type = types.port;
      example = 1234;
      description = "Port to use";
    };

    unique_id = mkOption {
      type = types.int;
      example = 1;
      description = "ID of the peer. Must be unique. In range 0-255.";
    };

    subnet = mkOption {
      type = types.str;
      example = "10.0.0";
      description = "Subnet (/24) to use for WireGuard peers";
    };

    server_subnet = mkOption {
      type = types.str;
      example = "192.168.1.1";
      description = "Subnet (/24) reachable by the server, that should be exposed to WireGuard peers";
    };
  };

  config = mkIf cfg.enable {
    networking.wg-quick.interfaces.wg0 = {
      address = [ "${cfg.subnet}.${toString cfg.unique_id}/32" ];
      privateKeyFile = "/home/johanan/os/secrets/wireguard-private.key";

      dns = mkIf (!cfg.server) [ "${cfg.server_subnet}.1" ];
      listenPort = mkIf cfg.server cfg.port;

      peers = if (!cfg.server) then [
        # Peers reachable by clients
        {
          # Router
          publicKey = "+52L7ozWbO40agAyfGO1rupLp532gYUNuv5xDoNkHjI=";
          presharedKeyFile = "/home/johanan/os/secrets/wireguard-psk-router.key";
          allowedIPs = [ "${cfg.subnet}.1/32" "${cfg.server_subnet}.1/24" ];
          endpoint = "vpn.skogsbrus.xyz:${toString cfg.port}";
          persistentKeepalive = 25;
        }
      ] else [
        # Peers reachable by the server
        {
          # Lenovo P1
          publicKey = "UpbNJCv+/TVcdYUU8fAgaO6WWAakzuPliYY3OccVeX4=";
          presharedKeyFile = "/home/johanan/os/secrets/wireguard-psk-lenovop1.key";
          allowedIPs = [
            "${cfg.subnet}.2/32"
          ];
        }
        {
          # Pixel 4a
          publicKey = "2YBkwoob9RpYxN6JH5YLGJ8j2wUhE1AQ1YLEMEvBlV4=";
          presharedKeyFile = "/home/johanan/os/secrets/wireguard-psk-pixel4a.key";
          allowedIPs = [
            "${cfg.subnet}.3/32"
          ];
        }
      ];
    };
  };
}
