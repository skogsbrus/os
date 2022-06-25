{ config, pkgs, lib, ... }:
let
  port = "666";
  wg_subnet = "10.66.66";
  private_subnet = "10.77.77";
in
{
  networking.wg-quick.interfaces =
    if config.networking.hostName == "router" then {
      wg0 = {
        address = [ "${wg_subnet}.1/32" ];
        listenPort = lib.strings.toInt (port);
        privateKeyFile = "/home/johanan/os/secrets/wireguard-private.key";

        peers = [
          {
            # Lenovo P1
            publicKey = "UpbNJCv+/TVcdYUU8fAgaO6WWAakzuPliYY3OccVeX4=";
            presharedKeyFile = "/home/johanan/os/secrets/wireguard-psk-lenovop1.key";
            allowedIPs = [
              "${wg_subnet}.2/32"
            ];
          }
          {
            # Pixel 4a
            publicKey = "2YBkwoob9RpYxN6JH5YLGJ8j2wUhE1AQ1YLEMEvBlV4=";
            presharedKeyFile = "/home/johanan/os/secrets/wireguard-psk-pixel4a.key";
            allowedIPs = [
              "${wg_subnet}.3/32"
            ];
          }
        ];
      };
    } else if config.networking.hostName == "voidm" then {
      wg0 = {
        address = [ "${wg_subnet}.2/32" ];
        privateKeyFile = "/home/johanan/os/secrets/wireguard-private.key";
        dns = [ "${private_subnet}.1" ];

        peers = [
          {
            # Router
            publicKey = "+52L7ozWbO40agAyfGO1rupLp532gYUNuv5xDoNkHjI=";
            presharedKeyFile = "/home/johanan/os/secrets/wireguard-psk-router.key";
            allowedIPs = [ "${wg_subnet}.1/32" "${private_subnet}.1/24" ];
            endpoint = "vpn.skogsbrus.xyz:${port}";
            persistentKeepalive = 25;
          }
        ];
      };
    } else { };
}
