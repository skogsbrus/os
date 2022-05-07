{ pkgs, ... }:
{
  # System defaults for all server machines

  imports = [
    ./core.nix
  ];

  services.openssh = {
    enable = true;
  };

  # Enable serial output
  boot.kernelParams = [
    "console=ttyS0,115200"
    "console=tty1"
  ];

  nix.gc = {
    automatic = true;
    dates = "weekly";
  };
}
