{ config
, pkgs
, agenix
, ...
}:
{
  # System defaults for all machines
  imports = [
    ./caddy.nix
    ./authelia.nix
    ./docker.nix
    ./fwupd.nix
    ./grafana.nix
    ./kodi.nix
    ./jellyfin.nix
    ./komga.nix
    ./lidarr.nix
    ./miniflux.nix
    ./email.nix
    ./networking.nix
    ./nfs_mount.nix
    ./nix.nix
    ./paperless_ngx.nix
    ./photoprism.nix
    ./photo_organizer
    ./postgres.nix
    ./printing.nix
    ./prometheus.nix
    ./prowlarr.nix
    ./rclone_backup.nix
    ./radarr.nix
    ./router.nix
    ./samba_server.nix
    ./security.nix
    ./sonarr.nix
    ./sound.nix
    ./ssh.nix
    ./steam.nix
    ./syncthing.nix
    ./tlp.nix
    ./transmission
    ./time_machine.nix
    ./users.nix
    ./wireguard.nix
    ./xserver.nix
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
    agenix.packages.${pkgs.system}.default
  ];
}
