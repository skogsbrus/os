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
    ./jellyfin.nix
    ./komga.nix
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
    ./rclone_backup.nix
    ./router.nix
    ./samba_server.nix
    ./security.nix
    ./sound.nix
    ./ssh.nix
    ./steam.nix
    ./syncthing.nix
    ./tlp.nix
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
