{ config
, lib
, pkgs
, ...
}:
let
  username = "kodi";
  usergroup = "users";
in
{
  imports = [
    ../../sys
  ];

  networking.hostName = "keeper";

  users.extraUsers."${username}".isNormalUser = true;

  skogsbrus = {
    fwupd.enable = true;

    kodi = {
      enable = true;
      autoLogin = true;
      user = username;
      openFirewall = true;
    };

    jellyfin = {
      enable = true;
      user = username;
      group = usergroup;
      openFirewall = true;
    };

    miniflux = {
      enable = true;
      port = 5656;
      openFirewall = true;
    };

    networking = {
      enableNetworkManager = true;
    };

    nix = {
      allowUnfree = true;
      flakes = true;
      gc = true;
      gcSchedule = "daily";
    };

    photoOrganizer = {
      enable = true;
      inputDir = "/tank/backup/input";
      outputDir = "/tank/media/photos";
    };

    radarr = {
      enable = true;
      openFirewall = true;
      user = username;
      group = usergroup;
    };

    photoprism = {
      enable = true;
      enableTensorflow = true;
      user = username;
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
      user = "johanan";
    };

    ssh.enable = true;

    sonarr = {
      enable = true;
      openFirewall = true;
      user = username;
      group = usergroup;
    };

    sound = {
      enable = true;
      enablePipewire = false;
      channels = 4;
    };

    steam = {
      steamlink = true;
    };

    syncthing = {
      enable = true;
      user = "johanan";
      expose = true;
    };

    tmux = {
      enable = true;
      bgColor = "yellow";
      fgColor = "black";
    };

    transmission = {
      enable = true;
      user = username;
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

    zsh.enable = true;
  };


  # Allow remote control
  networking.firewall = {
    allowedTCPPorts = [
      2049 # NFSv4
    ];
  };

  services.xserver.videoDrivers = [ "amdgpu" ];
  hardware.opengl.driSupport = true;
  # For 32 bit applications
  hardware.opengl.driSupport32Bit = true;
  hardware.opengl.extraPackages = with pkgs; [
    amdvlk
  ];
  # For 32 bit applications
  # Only available on unstable
  hardware.opengl.extraPackages32 = with pkgs; [
    driversi686Linux.amdvlk
  ];

  services.nfs.server.enable = true;
  services.nfs.server.exports = ''
    ${lib.concatMapStringsSep "\n" (n: "/tank/media/${n} 10.77.77.0/24(ro,no_subtree_check,nohide,fsid=2)")
    # read-only
    [
      "books"
      "games"
      "music"
      "photos"
      "videos"
    ]
    }
    ${lib.concatMapStringsSep "\n" (n: "/tank/${n} 10.77.77.0/24(rw,no_subtree_check,nohide,fsid=1)")
    # read-write
    [
      "backup"
    ]
    }
  '';

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?
}
