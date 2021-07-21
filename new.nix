{ pkgs, ... }:
{
  imports = [
    hosts/lenovo-p1.nix
    ./tmux.nix
    ./steam.nix
    ./zsh.nix
    ./xserver.nix
  ];

  # Allow installing unfree system packages
  nixpkgs.config.allowUnfree = true;

  #home-manager.users.johanan = { pkgs, ... }: {
  #  home.packages = [
  #    # Install webex from local package (unpublished)
  #    (pkgs.callPackage ../local-pkgs/webex.nix {})
  #  ];
  #};

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.johanan = {
    isNormalUser = true;
    extraGroups = [ "wheel"  "networkmanager" "docker" ]; # wheel -> sudo
  };

  users.extraUsers.johanan = {
    shell = pkgs.zsh;
  };

  # Set local time
  time.timeZone = "Europe/Copenhagen";

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Networking
  networking.networkmanager.enable = true;
  programs.nm-applet.enable = true;

  nix = {
    package = pkgs.nixUnstable;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  # System packages
  environment.systemPackages = with pkgs; [
    vim
    tmux
    git
    dig # used in split vpn script
    htop
    wget
    curl
    busybox
    firefox
    python3
  ];

  # List services that you want to enable:
  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;
  services = {
    syncthing = {
      enable = true;
      user = "johanan";
      dataDir = "/home/johanan/syncthing";
      configDir = "/home/johanan/syncthing/.config/syncting";
    };
  };

  system.autoUpgrade.enable = true;
  system.autoUpgrade.allowReboot = false;
}
