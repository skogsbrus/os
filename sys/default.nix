{ pkgs, ... }:
{
  imports = [
    ./pipewire.nix
    ./steam.nix
    ./tmux.nix
    ./xserver.nix
    ./zsh.nix
    ./postgres.nix
    ./fwupd.nix
  ];

  # Allow installing unfree system packages
  nixpkgs.config.allowUnfree = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.johanan = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "docker" "input" ]; # wheel -> sudo
  };

  # docker settings
  virtualisation.docker.enable = true;
  #virtualisation.docker.enableNvidia = true;


  users.extraUsers.johanan = {
    shell = pkgs.zsh;
  };

  # Set local time
  time.timeZone = "Europe/Copenhagen";

  # Networking
  networking.networkmanager.enable = true;
  networking.nameservers = [ "1.1.1.1" "9.9.9.9" ];
  networking.firewall.trustedInterfaces = [
    "enp0s20f0u4u1" # reMarkable via USB C
  ];
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
    man-db
    manpages
    openssl
  ];

  # List services that you want to enable:
  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;
  services = {
    syncthing = {
      enable = false;
      user = "johanan";
      dataDir = "/home/johanan/syncthing";
      configDir = "/home/johanan/syncthing/.config/syncting";
    };
    printing = {
      enable = true;
      drivers = [ pkgs.hplip ];
    };
  };

  system.autoUpgrade.enable = false;
  system.autoUpgrade.allowReboot = false;
}
