{ config
, lib
, pkgs
, ...
}:
let
  normalUsers = [
    "emma"
    "transmission"
    "syncthing"
    "sonarr"
    "postgres-user"
    "photoprism"
    "radarr"
    "lidarr"
  ];
  systemUsers = [
    "jellyfin"
    "postgres"
  ];
  usergroup = "users";
  inherit (builtins) listToAttrs;
in
{
  imports = [
    ../../sys
  ];

  networking.hostName = "keeper";
  networking.hostId = "deadcafe";
  # NOTE: uncomment if server is moved to location without ethernet
  #networking.wireless.enable = true;
  #networking.wireless.networks.morot = {
  #  psk = "foobar";
  #};

  # Manually created users for services that don't have auto-generated systemd users
  users.extraUsers =
    listToAttrs (map (x: { name = x; value = { isNormalUser = true; }; }) normalUsers) //
    listToAttrs (map (x: { name = x; value = { isSystemUser = true; }; }) systemUsers);

  skogsbrus = {
    fwupd.enable = false;

    caddy = {
      enable = true;
      publicUrl = "vpn.skogsbrus.xyz";
      openFirewall = true;
    };

    security.enable = true;

    grafana.enable = true;
    prometheus.enable = true;

    authelia.enable = true;

    jellyfin = {
      enable = true;
      user = "jellyfin";
      group = usergroup;
      openFirewall = true;
    };

    komga = {
      enable = false;
      port = 4246;
      openFirewall = true;
    };

    miniflux = {
      enable = false;
      port = 5656;
      openFirewall = true;
    };

    lidarr = {
      enable = false;
      openFirewall = true;
      user = "lidarr";
      group = usergroup;
    };

    email.nullmailer = true;

    networking = {
      enableNetworkManager = false;
    };

    nix = {
      allowUnfree = true;
      flakes = true;
      gc = true;
      gcSchedule = "daily";
    };

    paperless_ngx.enable = false;

    photoOrganizer = {
      enable = false;
      inputDir = "/tank/backup/input";
      outputDir = "/tank/media/photos";
    };

    radarr = {
      enable = false;
      openFirewall = true;
      user = "radarr";
      group = usergroup;
    };

    rcloneBackup = {
      enable = true;
      b2_directories = {
        "/tank/media/photos" = "keeper/tank/media/photos";
        "/tank/media/books" = "keeper/tank/media/books";
        #"/var/lib/mysql" = "keeper/var/lib/mysql";
        #"/var/lib/postgresql" = "keeper/var/lib/postgresql";
        #"/var/lib/paperless" = "keeper/var/lib/paperless";
        #"/var/lib/photoprism" = "keeper/var/lib/photoprism";
        #"/var/lib/grafana" = "keeper/var/lib/grafana";
        #"/var/lib/prometheus2" = "keeper/var/lib/prometheus2";
      };
    };

    photoprism = {
      enable = false;
      enableTensorflow = true;
      user = "photoprism";
      group = usergroup;
      originalsPath = "/tank/media/photos";
      importPath = "/tank/backup/input/photos";
      storagePath = "/var/lib/photoprism";
      httpUrl = "keeper.home";
      adminUserPassword = "foobar9000";
      adminUser = "johanan";
      readonly = true;
      openFirewall = true;
    };

    postgres = {
      enable = true;
      user = "postgres-user";
    };

    sambaServer = {
      enable = true;
      openFirewall = true;
      allowedSubnet = "10.77.77.";
      enableWebServiceDiscoveryDaemon = true;
      name = "keeper";
      shares = {
        dell-xps = {
          path = "/tank/backup/windows/dell-xps/veeam";
          browseable = "yes";
          "read only" = "no";
          "guest ok" = "no";
          "create mask" = "0644";
          "directory mask" = "0755";
          "valid users" = "emma";
          "force group" = "users";
        };
      };
    };

    ssh.enable = true;

    sonarr = {
      enable = false;
      openFirewall = true;
      user = "sonarr";
      group = usergroup;
    };

    sound = {
      enable = false;
      enablePipewire = false;
      channels = 4;
    };

    syncthing = {
      enable = false;
      user = "johanan";
      expose = true;
    };

    transmission = {
      enable = false;
      user = "transmission";
      group = usergroup;
      address = "keeper.home";
      openFirewall = true;
      # Hard links don't work across different ZFS datasets (different file systems)
      # so here we need to use the same ZFS dataset as used for /tank/media/videos/{tv,movies}
      # for optimal storage
      downloadDir = "/tank/media/videos/downloads";
      rmUnregisteredTorrents = true;
    };

    time_machine = {
      enable = true;
      user = "airm2-time-machine";
      openFirewall = true;
      backupPath = "/tank/backup/time-machine";
    };

    users = {
      groups = [ "networkmanager" ];
    };

    wireguard = {
      localVpn = false;
      port = 666;
      serverSubnet = "10.77.77";
      subnet = "10.66.66";
      uniqueId = 5;

      remoteVpn = true;
    };
  };


  # Allow remote control
  networking.firewall = {
    allowedTCPPorts = [
      111
      2049
      4000
      4001
      4002
      20048
    ];
    allowedUDPPorts = [
      111
      2049
      4000
      4001
      4002
      20048
    ];
  };

  services.xserver.videoDrivers = [ "amdgpu" ];
  hardware.opengl.driSupport = true;
  hardware.opengl.extraPackages = with pkgs; [
    amdvlk
  ];

  # For 32 bit applications
  # Only available on unstable
  hardware.opengl.driSupport32Bit = true;
  hardware.opengl.extraPackages32 = with pkgs; [
    driversi686Linux.amdvlk
  ];

  services.nfs.server = {
    enable = false;
    statdPort = 4000;
    lockdPort = 4001;
    mountdPort = 4002;
    extraNfsdConfig = '''';
  };
  services.nfs.server.exports = ''
    /tank/media/books 10.77.77.0/24(ro,insecure,no_subtree_check,nohide,fsid=1)
    /tank/media/games 10.77.77.0/24(ro,insecure,no_subtree_check,nohide,fsid=2)
    /tank/media/music 10.77.77.0/24(ro,insecure,no_subtree_check,nohide,fsid=3)
    /tank/media/photos 10.77.77.0/24(ro,insecure,no_subtree_check,nohide,fsid=4)
    /tank/media/videos 10.77.77.0/24(ro,insecure,no_subtree_check,nohide,fsid=5)
    /tank/backup 10.77.77.0/24(rw,insecure,no_subtree_check,nohide,fsid=6)
  '';

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
