# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [
      (modulesPath + "/installer/scan/not-detected.nix")
    ];

  # Required by ZFS
  networking.hostId = "f30d0712";

  boot.supportedFilesystems = [ "zfs" ];
  boot.kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;

  boot.loader.grub.enable = true;
  boot.loader.grub.useOSProber = true;
  boot.loader.grub.devices = [
    "/dev/disk/by-id/ata-WD_Green_M.2_2280_240GB_22126W805272"
  ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" ];
  boot.initrd.kernelModules = [ "kvm-amd" ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  nixpkgs.config.packageOverrides = pkgs: {
    zfsStable = pkgs.zfsStable.override { enableMail = true; };
  };

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/86e123ec-c715-4e54-8401-f88e9076ceef";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/3e3afe60-3a92-46dc-81f9-95c0b28c92ec";
      fsType = "ext4";
    };

  fileSystems."/home" =
    { device = "/dev/disk/by-uuid/b6cbf7e1-35a5-42c9-8565-4ba3c0fcbc9e";
      fsType = "ext4";
    };

  fileSystems."/nix" =
    { device = "/dev/disk/by-uuid/d04f4a64-c14e-4252-9161-d6b18ec6c0be";
      fsType = "ext4";
    };

  fileSystems."/var" =
    { device = "/dev/disk/by-uuid/db16e57d-d6c6-48c1-ae8c-8f5a340d0e42";
      fsType = "ext4";
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/c9b3ed7c-17aa-488d-9a7b-dcc47bacfd73"; }
    ];

  # NOTE: use `zfs set mountpoint=legacy DATASET` and then add it here

  fileSystems."/tank/media/music" =
    {
      device = "tank/media/music";
      fsType = "zfs";
    };

  fileSystems."/tank/media/videos" =
    {
      device = "tank/media/videos";
      fsType = "zfs";
    };

  fileSystems."/tank/media/photos" =
    {
      device = "tank/media/photos";
      fsType = "zfs";
    };

  fileSystems."/tank/media/books" =
    {
      device = "tank/media/books";
      fsType = "zfs";
    };

  fileSystems."/tank/media/games" =
    {
      device = "tank/media/games";
      fsType = "zfs";
    };

  fileSystems."/tank/backup" =
    {
      device = "tank/backup";
      fsType = "zfs";
    };


  # Recommended settings from Dan Langille's "ZFS For Newbies",
  # https://www.youtube.com/watch?v=3oG-1U5AI9A
  services.zfs.autoScrub.enable = true;
  services.zfs.trim.enable = true;
  # zfs set atime=off <POOL>

  services.zfs.zed.enableMail = true;
  services.zfs.zed.settings = {
    ZED_EMAIL_PROG = "${pkgs.mailutils}/bin/mail";
    ZED_NOTIFY_INTERVAL_SECS = 3600;
    ZED_SCRUB_AFTER_RESILVER = true;
    ZED_EMAIL_ADDR = [ "johan+zfs@skogsbrus.xyz" ];
    ZED_DEBUG_LOG = "/tmp/zed.debug.log";
    ZED_NOTIFY_VERBOSE = true;
  };


  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp3s0.useDHCP = lib.mkDefault true;

  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  hardware.video.hidpi.enable = lib.mkDefault true;
}
