{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" ];
  boot.initrd.kernelModules = [ "dm-snapshot" ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  boot.loader.grub = {
    enable = true;
    version = 2;
    efiSupport = true;
    enableCryptodisk = true;
    device = "nodev";
    useOSProber = true;
  };

  # Encryption setup
  boot.initrd.luks.devices = {
    crypted = {
      device = "/dev/disk/by-uuid/d9e29ce6-a8ca-423e-ae67-ea36df87ec4f";
      preLVM = true;
    };
  };

  fileSystems."/" =
    {
      device = "/dev/disk/by-uuid/85e42b7e-cdb2-43d5-b8b9-45246ff96006";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    {
      device = "/dev/disk/by-uuid/7CEF-102A";
      fsType = "vfat";
    };

  swapDevices =
    [{ device = "/dev/disk/by-uuid/38f1afc0-e3d0-4389-91f3-227d44b75911"; }];

  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  # high-resolution display
  hardware.video.hidpi.enable = lib.mkDefault true;

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp35s0.useDHCP = true;
  networking.interfaces.wlp39s0.useDHCP = true;

  services.xserver.videoDrivers = [ "nvidia" ];
}
