{ config
, pkgs
, ...
}:
{
  # System defaults for all machines
  imports = [
    ./docker.nix
    ./fwupd.nix
    ./grafana.nix
    ./networking.nix
    ./nfs_mount.nix
    ./nix.nix
    ./postgres.nix
    ./printing.nix
    ./router.nix
    ./sound.nix
    ./ssh.nix
    ./steam.nix
    ./syncthing.nix
    ./tlp.nix
    ./tmux.nix
    ./users.nix
    ./wireguard.nix
    ./xserver.nix
    ./zsh.nix
  ];

  # Set local time
  config.time.timeZone = "Europe/Copenhagen";

  # System packages
  config.environment.systemPackages = with pkgs; [
    # dev utils
    git
    gnumake
    htop
    mailutils
    man-db
    man-pages
    python3
    tmux
    vim
  ];
}
