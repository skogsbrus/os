{ nixpkgs
}:
let
  inherit nixpkgs;

  secureSystemdServiceOptions = { options, name }: (
    nixpkgs.lib.recursiveUpdate
      {
        DynamicUser = "yes";
        PrivateUsers = true;
        UMask = "077";
        SystemCallArchitectures = "native";
        SystemCallFilter = [ "@system-service" "~@resources" "~@privileged" ];
        SystemCallErrorNumber = "EBADRQC";

        # Only allow loopback communication by default
        IPAddressAllow = [ "127.0.0.1/32" "::1" ];
        IPAddressDeny = [ "0.0.0.0/0" ];

        CapabilityBoundingSet = "";

        PrivateTmp = true;
        PrivateNetwork = true;
        RestrictNamespaces = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectControlGroups = true;
        ProtectKernelModules = true;
        MemoryDenyWriteExecute = true;
        LockPersonality = true;
        ProtectClock = true;
        ProtectKernelTunables = true;
        RestrictAddressFamilies = [ "AF_UNIX" ];
        NoNewPrivileges = true;
        ProtectHome = true;
        RestrictRealtime = true;
        PrivateDevices = true;
        ProtectProc = "invisible";
        ProcSubset = "pid";
        RuntimeDirectory = name;
        RootDirectory = "/run/${name}";
        ReadWritePaths = [
          "/var/run/${name}"
          "/run/${name}"
        ];
        BindReadOnlyPaths = [
          "/nix/store"
          "/run/agenix" # TODO: bind /run/agenix/name instead
          "/etc/" # Needed for e.g. /etc/resolv.conf
        ];
      }
      options
  );

  overrideSystemdServiceOptions =
    { options, current, name }:
    (
      nixpkgs.lib.recursiveUpdate
        (secureSystemdServiceOptions
          { inherit name; options = { }; })
        options
    );

  lib = {
    inherit
      overrideSystemdServiceOptions
      secureSystemdServiceOptions;
  };
in
lib
