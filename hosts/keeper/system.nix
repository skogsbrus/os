{ config
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

    tmux = {
      enable = true;
      bgColor = "yellow";
      fgColor = "black";
    };

    users = {
      groups = [ "networkmanager" ];
    };

    zsh.enable = true;
  };

  # TODO: move kodi logic to modules
  users.extraUsers.kodi.isNormalUser = true;

  services.xserver = {
    desktopManager.kodi.enable = true;
    enable = true;
    displayManager.autoLogin.enable = true;
    displayManager.autoLogin.user = "kodi";
    xkbOptions = "caps:escape";
  };

  # Allow remote control
  networking.firewall = {
    allowedTCPPorts = [ 8080 ];
    allowedUDPPorts = [ 8080 ];
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?
}
