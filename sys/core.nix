{ pkgs, ... }:
{
  # System defaults for all machines
  imports = [
    ./fwupd.nix
    ./tmux.nix
    ./zsh.nix
  ];

  config.home-manager.users.johanan.programs.git = {
    enable = true;
    extraConfig.safe.directory = "/home/johanan/os/";
  };

  # Allow installing unfree system packages
  nixpkgs.config.allowUnfree = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.johanan = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # wheel -> sudo
  };

  users.extraUsers.johanan = {
    shell = pkgs.zsh;
  };

  # Set local time
  time.timeZone = "Europe/Copenhagen";

  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  # System packages
  environment.systemPackages = with pkgs; [
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
    manpages
    python3
    tmux
    vim
  ];

  system.autoUpgrade.enable = false;
  system.autoUpgrade.allowReboot = false;
}
