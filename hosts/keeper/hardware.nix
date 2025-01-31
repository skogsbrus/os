# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [
      (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.supportedFilesystems = [ "zfs" ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelModules = [ "igb" "r8169" ];
  boot.extraModulePackages = [ ];

  # https://bbs.archlinux.org/viewtopic.php?id=254383
  boot.kernelParams = [ "amdgpu.dc=0" ];

  boot.initrd = {
    availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" ];
    kernelModules = [ "kvm-amd" ];
  };

  nixpkgs.config.packageOverrides = pkgs: {
    zfsStable = pkgs.zfsStable.override { enableMail = true; };
  };

  fileSystems."/" =
    { device = "rpool/root";
      fsType = "zfs";
    };

  fileSystems."/home" =
    { device = "rpool/home";
      fsType = "zfs";
    };

  fileSystems."/nix" =
    { device = "rpool/nix";
      fsType = "zfs";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/B9EE-3D2E";
      fsType = "vfat";
    };

  # NOTE: use `zfs set mountpoint=legacy DATASET` and then add it here

  fileSystems."/tank/media/documents" =
    {
      device = "tank/media/documents";
      fsType = "zfs";
    };

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

  swapDevices = [ ];


  # Recommended settings from Dan Langille's "ZFS For Newbies",
  # https://www.youtube.com/watch?v=3oG-1U5AI9A
  services.zfs.autoScrub.enable = true;
  services.zfs.autoScrub.interval = "Wed *-*-1/4 11:00:00";
  services.zfs.trim.enable = true;
  # zfs set atime=off <POOL>

  services.zfs.zed.enableMail = true;
  services.zfs.zed.settings = {
    ZED_NOTIFY_INTERVAL_SECS = 3600;
    ZED_SCRUB_AFTER_RESILVER = true;
    ZED_EMAIL_ADDR = [ "bot+zfs@skogsbrus.xyz" ];
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
}
