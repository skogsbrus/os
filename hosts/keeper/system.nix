{ config
, lib
, ...
}:
{
  imports = [
    ../../sys
  ];

  networking.hostName = "keeper";

  skogsbrus = {
    fwupd.enable = true;

    networking = {
      enableNetworkManager = true;
    };

    nix = {
      allowUnfree = true;
      flakes = true;
      gc = true;
      gcSchedule = "daily";
    };

    ssh.enable = true;

    sound = {
      enable = true;
      enablePipewire = true;
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

  # TODO: move kodi logic to modules
  users.extraUsers.kodi.isNormalUser = true;
  users.extraUsers.kodi.extraGroups = [ "dialout" ];

  services.postfix = {
    enable = true;
  };

  services.xserver = {
    desktopManager.kodi.enable = true;
    enable = true;
    displayManager.autoLogin.enable = true;
    displayManager.autoLogin.user = "kodi";
    xkbOptions = "caps:escape";
  };

  services.radarr = {
    enable = true;
    openFirewall = true;
    user = "kodi";
    group = "users";
  };

  services.sonarr = {
    enable = true;
    openFirewall = true;
    user = "kodi";
    group = "users";
  };

  services.transmission = {
    enable = true;
    user = "kodi";
    group = "users";
    settings = {
      rpc-bind-address = "0.0.0.0";
      rpc-whitelist-enabled = false;
      rpc-host-whitelist = "keeper.home";
      # Hard links don't work across different ZFS datasets (different file systems)
      # so here we need to use the same ZFS dataset as used for /tank/media/videos/{tv,movies}
      # for optimal storage
      download-dir = "/tank/media/videos/downloads";
      incomplete-dir-enabled = false;
    };
    openRPCPort = true;
  };

  # Allow remote control
  networking.firewall = {
    allowedTCPPorts = [
      8080 # Kodi
      #2049 # # TODO: NFSv4
    ];
    allowedUDPPorts = [
      8080 # Kodi
    ];
  };

  # TODO: enable NFS
  #services.nfs.server.enable = true;
  #services.nfs.server.exports = ''
  #  /tank *(rw,fsid=root,no_subtree_check,all_squash)
  #  ${lib.concatMapStringsSep "\n" (n: "/tank/media/${n} 10.77.77.0/24(ro,no_subtree_check,nohide)")
  #    # read-only
  #    [
  #      "videos/tv"
  #      "videos/movies"
  #      "music"
  #      "photos"
  #      "books"
  #    ]
  #  }
  #  ${lib.concatMapStringsSep "\n" (n: "/tank/${n} 10.77.77.0/24(rw,no_subtree_check,nohide)")
  #    # read-write
  #    [
  #      "backup"
  #    ]
  #  }
  #'';

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?
}
