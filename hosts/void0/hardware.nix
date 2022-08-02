# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [
      (modulesPath + "/installer/scan/not-detected.nix")
    ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/sda";

  boot.initrd.availableKernelModules = [ "xhci_pci" "ehci_pci" "ahci" "usbhid" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    {
      device = "/dev/disk/by-uuid/d5f7e620-729f-4d31-b25a-f37101b943d2";
      fsType = "ext4";
    };

  swapDevices =
    [{ device = "/dev/disk/by-uuid/82bf5bbe-7c50-4812-9062-58653e58dc25"; }];

  # high-resolution display
  hardware.video.hidpi.enable = lib.mkDefault true;

  # power saving options
  services.power-profiles-daemon.enable = true;

  services.xserver.extraConfig = ''
    Section "InputClass"
        Identifier         "Touchscreen catchall"
        MatchIsTouchscreen "on"

        Option "Ignore" "on"
    EndSection
  '';
}
