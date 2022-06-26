{ config
, pkgs
, ...
}:
{
  # System defaults for all machines
  imports = [
    ./fwupd.nix
    ./tmux.nix
    ./zsh.nix
    ./wireguard.nix
  ];

  config.home-manager.users.johanan.programs.git = {
    enable = true;
    extraConfig.safe.directory = "/home/johanan/os/";
  };

  # Allow installing unfree system packages
  config.nixpkgs.config.allowUnfree = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  config.users.users.johanan = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # wheel -> sudo
  };

  config.users.extraUsers.johanan = {
    shell = pkgs.zsh;
  };

  # Set local time
  config.time.timeZone = "Europe/Copenhagen";

  config.nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  # System packages
  config.environment.systemPackages = with pkgs; [
    # networking
    curl
    dig
    openssl
    wget
    # dev utils
    git
    gnumake
    htop
    man-db
    man-pages
    python3
    tmux
    vim
  ];

  config.system.autoUpgrade.enable = false;
  config.system.autoUpgrade.allowReboot = false;
}
