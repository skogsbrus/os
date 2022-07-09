{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "ehci_pci" "sd_mod" "sdhci_pci" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/sda";

  fileSystems."/" =
    {
      device = "/dev/disk/by-uuid/16c7c007-d1ad-4899-8208-99a18e3cdb45";
      fsType = "ext4";
    };

  swapDevices =
    [{ device = "/dev/disk/by-uuid/3f91e2e3-2c8a-4a07-83a8-29e94dd349b0"; }];

  # Enable serial output
  boot.kernelParams = [
    "console=ttyS0,115200"
    "console=tty1"
  ];

  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
