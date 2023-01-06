{ config
, lib
, ...
}:
let
  username = "kodi";
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

    networking = {
      enableNetworkManager = true;
    };

    nix = {
      allowUnfree = true;
      flakes = true;
      gc = true;
      gcSchedule = "daily";
    };

    radarr = {
      enable = true;
      openFirewall = true;
      user = username;
      group = "users";
    };

    ssh.enable = true;

    sonarr = {
      enable = true;
      openFirewall = true;
      user = username;
      group = "users";
    };

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

    transmission = {
      enable = true;
      user = username;
      group = "users";
      address = "keeper.home";
      openFirewall = true;
      # Hard links don't work across different ZFS datasets (different file systems)
      # so here we need to use the same ZFS dataset as used for /tank/media/videos/{tv,movies}
      # for optimal storage
      downloadDir = "/tank/media/videos/downloads";
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

  services.postfix = {
    enable = true;
  };

  # Allow remote control
  networking.firewall = {
    allowedTCPPorts = [
      2049 # NFSv4
    ];
  };

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
