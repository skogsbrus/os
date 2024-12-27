{ config
, pkgs
, lib
, skogsbrus
, ...
}:
let
  cfg = config.skogsbrus.sambaServer;
  inherit (lib) mkIf mkEnableOption mkOption types;
in
{
  options.skogsbrus.sambaServer = {
    enable = mkEnableOption "enable samba server";
    openFirewall = mkEnableOption "Open firewall";
    enableWebServiceDiscoveryDaemon = mkEnableOption "Enable WSDD";
    allowedSubnet = mkOption {
      type = types.str;
      example = "10.0.0";
      description = "Subnet (/24) to use for WireGuard peers";
    };
    name = mkOption {
      type = types.str;
      example = "foobar";
      description = "The service name";
    };
    workgroup = mkOption {
      type = types.str;
      example = "foobar";
      default = "WORKGROUP";
      description = "The workgroup name";
    };
    shares = mkOption {
      type = types.attrsOf types.attrs;
      description = "Shares to expose through samba";
    };
  };

  config = mkIf cfg.enable {
    # make shares visible for windows 10 clients
    services.samba-wsdd.enable = mkIf
      cfg.enableWebServiceDiscoveryDaemon
      true;

    networking.firewall.allowedTCPPorts = mkIf cfg.openFirewall [
      5357 # wsdd
    ];
    networking.firewall.allowedUDPPorts = mkIf cfg.openFirewall [
      3702 # wsdd
    ];

    services.samba = {
      enable = true;
      openFirewall = true;
      settings = cfg.shares // {
        global = {
          "workgroup" = cfg.workgroup;
          "server string" = cfg.name;
          "netbios name" = cfg.name;
          "security" = "user";

          # note: localhost is the ipv6 localhost ::1
          "hosts allow" = "${cfg.allowedSubnet} 127.0.0.1 localhost";
          "hosts deny" = "0.0.0.0/0";
          "guest account" = "nobody";
          "map to guest" = "bad user";

          "winbind nss info" = "template";
          "winbind enum users" = "Yes";
          "winbind enum groups" = "Yes";
          "winbind use default domain" = "yes";
          "min protocol" = "SMB2";
          "max protocol" = "SMB3";
          "client min protocol" = "SMB2";
          "client max protocol" = "SMB3";
          "client ipc min protocol" = "SMB2";
          "client ipc max protocol" = "SMB3";
          "server min protocol" = "SMB2";
          "server max protocol" = "SMB3";
        };
      };
    };
  };
}

