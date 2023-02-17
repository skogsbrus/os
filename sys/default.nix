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
    ./kodi.nix
    ./jellyfin.nix
    ./miniflux.nix
    ./networking.nix
    ./nfs_mount.nix
    ./nix.nix
    ./photoprism.nix
    ./photo_organizer
    ./postgres.nix
    ./printing.nix
    ./radarr.nix
    ./router.nix
    ./sonarr.nix
    ./sound.nix
    ./ssh.nix
    ./steam.nix
    ./syncthing.nix
    ./tlp.nix
    ./tmux.nix
    ./transmission.nix
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
