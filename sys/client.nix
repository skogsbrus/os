{ pkgs, ... }:
{
  # System defaults for user-facing machines

  imports = [
    ./core.nix
    ./docker.nix
    ./postgres.nix
    ./printing.nix
    ./steam.nix
    ./syncthing.nix
    ./xserver.nix
  ];
  users.users.johanan = {
    extraGroups = [ "networkmanager" ];
  };

  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Networking
  networking.networkmanager.enable = true;
  networking.firewall.trustedInterfaces = [
    "enp0s20f0u4u1" # reMarkable via USB C
  ];
  programs.nm-applet.enable = true;
}
