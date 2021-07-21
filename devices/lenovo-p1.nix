{ config, pkgs, ... }:
{
  imports = [
      ./lenovo-p1-hw.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Encryption setup
  boot.initrd.luks.devices = {
    crypted = {
      device = "/dev/nvme0n1p2";
      preLVM = true;
    };
  };

  boot.kernelParams = [ "processor.max_cstate=4" "amd_iomu=soft" "idle=nomwait" "intel_pstate=disable" ];
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.wlp0s20f3.useDHCP = true;
  networking.hostName = "voidm"; # Define your hostname.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # for vpn
  services.strongswan = {
    enable = true;
    secrets = [
      "ipsec.d/ipsec.nm-l2tp.secrets"
    ];
  };

  home-manager.users.johanan = { pkgs, ... }: {
    home.packages = [
      # Install webex from local package (unpublished)
      (pkgs.callPackage ../local-pkgs/webex.nix {})
    ];
  };

  services.logind.extraConfig = ''
    # Enable docking with closed lid
    HandleLidSwitchDocked=ignore
  '';

  # Maybe prevents crash?
  # Jul 20 11:17:33 voidm kernel: nouveau 0000:01:00.0: fifo: fault 01 [VIRT_WRITE] at 0000000008000000 engine 40 [gr] client 13 [GPC0/PROP_0] reason 00 [PDE] on channel 6 [00feff3000 Xwayland[1859]]
  services.xserver.videoDrivers = [ "modesetting" ];

  # power saving options
  services.power-profiles-daemon.enable = false;
  services.tlp = {
    enable = true;
    settings.START_CHARGE_THRESH_BAT0=75;
    settings.STOP_CHARGE_THRESH_BAT0=80;

    settings.CPU_SCALING_GOVERNOR_ON_AC="schedutil";
    settings.CPU_SCALING_GOVERNOR_ON_BAT="schedutil";

    settings.CPU_SCALING_MIN_FREQ_ON_AC=800000;
    settings.CPU_SCALING_MAX_FREQ_ON_AC=3500000;
    settings.CPU_SCALING_MIN_FREQ_ON_BAT=800000;
    settings.CPU_SCALING_MAX_FREQ_ON_BAT=2300000;

    # Enable audio power saving for Intel HDA, AC97 devices (timeout in secs).
    # A value of 0 disables, >=1 enables power saving (recommended: 1).
    # Default: 0 (AC), 1 (BAT)
    settings.SOUND_POWER_SAVE_ON_AC=0;
    settings.SOUND_POWER_SAVE_ON_BAT=1;

    # Runtime Power Management for PCI(e) bus devices: on=disable, auto=enable.
    # Default: on (AC), auto (BAT)
    settings.RUNTIME_PM_ON_AC="on";
    settings.RUNTIME_PM_ON_BAT="auto";

    # Battery feature drivers: 0=disable, 1=enable
    # Default: 1 (all)
    settings.NATACPI_ENABLE=1;
    settings.TPACPI_ENABLE=1;
    settings.TPSMAPI_ENABLE=1;
  };
}