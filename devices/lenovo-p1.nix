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

  boot.kernelParams = [ "processor.max_cstate=4" "amd_iomu=soft" "idle=nomwait"];
  boot.kernelPackages = pkgs.linuxPackages_latest;
  #boot.extraModulePackages = [ config.boot.kernelPackages.nvidia_x11 ];

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
}
