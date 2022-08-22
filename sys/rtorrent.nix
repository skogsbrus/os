{ config
, lib
, pkgs
, ...
}:
let
  cfg = config.skogsbrus.rtorrentService;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.skogsbrus.rtorrentService = {
    enable = mkEnableOption "Whether to enable rtorrent or not";
  };

  config = mkIf cfg.enable {
    systemd.services.rtorrent = {
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      description = "Start rtorrent";
      serviceConfig = {
        Type = "simple";
        User = "johanan"; # TODO
        Restart = "on-failure";
        StartLimitBurst = 3;
        ExecStart = ''${pkgs.rtorrent}/bin/rtorrent'';
      };
    };
    systemd.services.flood = {
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      description = "Start flood";
      serviceConfig = {
        Type = "simple";
        User = "johanan"; # TODO
        Restart = "on-failure";
        StartLimitBurst = 3;
        ExecStart = ''${pkgs.flood}/bin/flood --rtsocket /home/johanan/rtorrent/rpc.socket -p 3000 --host 0.0.0.0'';
      };
    };
  };
}
