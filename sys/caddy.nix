{ config
, pkgs
, lib
, skogsbrus
, ...
}:
let
  cfg = config.skogsbrus.caddy;
  inherit (lib) mapAttrs' genAttrs nameValuePair mkOption types mkIf mkEnableOption;
in
{
  options.skogsbrus.caddy = {
    enable = mkEnableOption "caddy";

    publicUrl = mkOption {
      type = types.str;
      example = "foo.bar";
      description = "Domain name to use";
    };

    openFirewall = mkEnableOption "Open firewall";
  };

  # TODO:
  # Options for auth location
  # Option list for services behind auth
  config = mkIf cfg.enable {
    services.caddy = {
      enable = true;
      virtualHosts = {
        # TODO: Make this smarter
        "photos.${cfg.publicUrl}" = {
          extraConfig = ''
            forward_auth localhost:9999 {
                uri /api/verify?rd=https://auth.${cfg.publicUrl}/
                copy_headers Remote-User Remote-Groups Remote-Name Remote-Email
            }
            reverse_proxy localhost:2342 { }
          '';
        };
        "stream.${cfg.publicUrl}" = {
          extraConfig = ''
            forward_auth localhost:9999 {
                uri /api/verify?rd=https://auth.${cfg.publicUrl}/
                copy_headers Remote-User Remote-Groups Remote-Name Remote-Email
            }
            reverse_proxy localhost:8096 { }
          '';
        };
        "auth.${cfg.publicUrl}" = {
          extraConfig = ''
            reverse_proxy localhost:9999 { }
          '';
        };
        "rss.${cfg.publicUrl}" = {
          extraConfig = ''
            forward_auth localhost:9999 {
                uri /api/verify?rd=https://auth.${cfg.publicUrl}/
                copy_headers Remote-User Remote-Groups Remote-Name Remote-Email
            }
            reverse_proxy localhost:5656 { }
          '';
        };
        "kodi.${cfg.publicUrl}" = {
          extraConfig = ''
            forward_auth localhost:9999 {
                uri /api/verify?rd=https://auth.${cfg.publicUrl}/
                copy_headers Remote-User Remote-Groups Remote-Name Remote-Email
            }
            reverse_proxy localhost:8080 { }
          '';
        };
        "syncthing.${cfg.publicUrl}" = {
          extraConfig = ''
            forward_auth localhost:9999 {
                uri /api/verify?rd=https://auth.${cfg.publicUrl}/
                copy_headers Remote-User Remote-Groups Remote-Name Remote-Email
            }
            reverse_proxy localhost:8384 { }
          '';
        };
        "shows.${cfg.publicUrl}" = {
          extraConfig = ''
            forward_auth localhost:9999 {
                uri /api/verify?rd=https://auth.${cfg.publicUrl}/
                copy_headers Remote-User Remote-Groups Remote-Name Remote-Email
            }
            reverse_proxy localhost:8989 { }
          '';
        };
        "movies.${cfg.publicUrl}" = {
          extraConfig = ''
            forward_auth localhost:9999 {
                uri /api/verify?rd=https://auth.${cfg.publicUrl}/
                copy_headers Remote-User Remote-Groups Remote-Name Remote-Email
            }
            reverse_proxy localhost:7878 { }
          '';
        };
      };
    };
    systemd.services.caddy = {
      serviceConfig = skogsbrus.lib.overrideSystemdServiceOptions {
        name = "caddy";
        current = config.systemd.services.caddy.serviceConfig;
        options = {
          # Need capabilities to bind port 80 & 443
          CapabilityBoundingSet = "CAP_NET_BIND_SERVICE";
          AmbientCapabilities = "CAP_NET_BIND_SERVICE";

          # Private users have no capabilities on host --> we can't enable this
          # AND bind privileged ports on host
          PrivateUsers = false;

          # Since PrivatUsers=false, we need access to the host's /var/run folder
          BindPaths = [
            "/var/run/caddy"
          ];

          # Needs to be able to reach outside services such as let's encrypt
          PrivateNetwork = false;
          RestrictAddressFamilies = [ "AF_INET" "AF_INET6" "AF_UNIX" ];
          IPAddressAllow = [ "0.0.0.0/0" "::/0" ];
          IPAddressDeny = [ ];
          Environment = [
            "HOME=/var/run/caddy"
          ];
        };
      };
    };
    networking.firewall = mkIf cfg.openFirewall {
      allowedTCPPorts = [ 80 443 ];
    };
  };
}
