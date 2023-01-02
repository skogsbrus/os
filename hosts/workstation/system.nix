{ config
, ...
}:
{
  imports = [
    ../../sys
  ];

  networking.hostName = "workstation";

  skogsbrus = {

    docker = {
      enable = true;
      enableNvidia = true;
      users = [ "johanan" ];
    };

    fwupd.enable = true;

    nfs_mount = {
      enable = true;
      mountpoint = "/mnt/keeper";
      mounts = {
        "backup" = "/tank/backup";
        "books" = "/tank/media/books";
        "games" = "/tank/media/games";
        "music" = "/tank/media/music";
        "photos" = "/tank/media/photos";
        "videos" = "/tank/media/videos";
      };
    };

    networking = {
      enableNetworkManager = true;
      # Allow traffic from remarkable tablet via USB C
      trustedInterfaces = [ "enp0s20f0u4u1" ];
    };

    nix = {
      allowUnfree = true;
      flakes = true;
      gc = false;
    };

    sound = {
      enable = true;
      enablePipewire = true;
    };

    ssh.enable = true;

    steam = {
      enable = true;
      users = [ "johanan" ];
    };

    syncthing = {
      enable = true;
      user = "johanan";
      expose = false;
    };

    tmux = {
      enable = true;
      awWatcher = true;
      bgColor = "orange";
      fgColor = "black";
    };

    users = {
      groups = [ "networkmanager" ];
    };

    xserver.enable = true;
    zsh.enable = true;
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.11"; # Did you read the comment?
}
