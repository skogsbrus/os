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

  boot.kernelModules = [ "igb" "r8169" ];
  boot.extraModulePackages = [ ];

  # https://bbs.archlinux.org/viewtopic.php?id=254383
  boot.kernelParams = [ "amdgpu.dc=0" ];

  #boot.kernelParams = [
  #  # See https://www.kernel.org/doc/Documentation/filesystems/nfs/nfsroot.txt for syntax
  #  "ip=10.77.77.38::10.77.77.1::keeper::off" # Needs to be in sync with IP assigned by router
  #];

#  boot.initrd.secrets = {
#  "/etc/secrets/initrd/ssh_host_ed25519_key" = null;
# };

  boot.initrd = {
    availableKernelModules = [ "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" "igb" ];
    kernelModules = [ "kvm-amd" "igb" "r8169" ];
    network = {
      # This will use udhcp to get an ip address.
      # Make sure you have added the kernel module for your network driver to `boot.initrd.availableKernelModules`,
      # so your initrd can load it!
      enable = true;
      # NOTE: currently doesn't work
      ssh = {
        enable = true;
        # To prevent ssh clients from freaking out because a different host key is used,
        # a different port for ssh is useful (assuming the same host has also a regular sshd running)
        port = 2222;
        # hostKeys paths must be unquoted strings, otherwise you'll run into issues with boot.initrd.secrets
        # the keys are copied to initrd from the path specified; multiple keys can be set
        # you can generate any number of host keys using
        # `ssh-keygen -t ed25519 -N "" -f /path/to/ssh_host_ed25519_key`
        hostKeys = [ /boot/intrd_ssh_host_ed25519_key ];
        # public ssh key used for login
        authorizedKeys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINug6YZP5It5utF3UALqq+Wq93Taj+xtzaOMv6qwVfWc contact@skogsbrus.xyz" ];
      };

      # this will automatically load the zfs password prompt on login
      # and kill the other prompt so boot can continue
      # source: https://carjorvaz.com/posts/installing-nixos-with-root-on-tmpfs-and-encrypted-zfs-on-a-netcup-vps/
      postCommands = ''
        zpool import -a
        echo "zfs load-key -a; killall zfs" >> /root/.profile
      '';
    };
  };

  nixpkgs.config.packageOverrides = pkgs: {
    zfsStable = pkgs.zfsStable.override { enableMail = true; };
  };

  fileSystems."/" =
    {
      device = "/dev/disk/by-uuid/86e123ec-c715-4e54-8401-f88e9076ceef";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    {
      device = "/dev/disk/by-uuid/3e3afe60-3a92-46dc-81f9-95c0b28c92ec";
      fsType = "ext4";
    };

  fileSystems."/home" =
    {
      device = "/dev/disk/by-uuid/b6cbf7e1-35a5-42c9-8565-4ba3c0fcbc9e";
      fsType = "ext4";
    };

  fileSystems."/nix" =
    {
      device = "/dev/disk/by-uuid/d04f4a64-c14e-4252-9161-d6b18ec6c0be";
      fsType = "ext4";
    };

  fileSystems."/var" =
    {
      device = "/dev/disk/by-uuid/db16e57d-d6c6-48c1-ae8c-8f5a340d0e42";
      fsType = "ext4";
    };

  swapDevices =
    [{ device = "/dev/disk/by-uuid/c9b3ed7c-17aa-488d-9a7b-dcc47bacfd73"; }];

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
