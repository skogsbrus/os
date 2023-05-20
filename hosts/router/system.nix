{ config
, ...
}:
{
  imports = [
    ../../sys
  ];

  networking.hostName = "router";

  skogsbrus = {
    fwupd.enable = true;
    grafana.enable = true;

    nix = {
      allowUnfree = true;
      flakes = true;
      gc = true;
      gcSchedule = "daily";
    };

    router = {
      enable = true;
      privateSubnet = "10.77.77";
      guestSubnet = "10.88.88";
    };

    ssh.enable = true;
    sound.enable = false;

    users = {
      # TODO: parameterize user names etc
    };

    wireguard = {
      localVpn = true;
      server = true;
      port = 666;
      subnet = "10.66.66";
      serverSubnet = "10.77.77";
      uniqueId = 1;
    };

  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.11"; # Did you read the comment?
}
