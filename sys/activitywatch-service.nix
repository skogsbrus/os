{ config, pkgs, lib, ... }:
let
    aw = (pkgs.callPackage ../home/pkgs/activitywatch {});
in
{
  systemd.services.activitywatch = {
    wantedBy = [ "default.target" ];
    wants = [ "graphical-session.target" ];
    description = "Start Activitywatch";
    serviceConfig = {
      Type = "forking";
      User = "johanan";
      ExecStart = ''/etc/profiles/per-user/johanan/bin/aw-qt'';
      Restart = "no";
      Environment="DISPLAY=:1 XAUTHORITY=/run/user/1000/gdm/Xauthority PATH=$PATH:/run/current-system/sw/bin"; # TODO: can we avoid hardcoding this?
    };
  };
  #systemd.services.aw-server = {
  #  wantedBy = [ "default.target" ];
  #  description = "Start Activitywatch server";
  #  serviceConfig = {
  #    Type = "simple";
  #    User = "johanan";
  #    ExecStart = ''${aw}/bin/aw-server'';
  #    Restart = "always";
  #  };
  #};
  #systemd.services.aw-watcher-window = {
  #  after = [ "aw-server.service" ];
  #  wantedBy = [ "default.target" ];
  #  description = "Start Activitywatch window watcher";
  #  serviceConfig = {
  #    Type = "simple";
  #    User = "johanan";
  #    ExecStart = ''${aw}/bin/aw-watcher-window'';
  #    Environment="DISPLAY=:1"; # TODO: can we avoid hardcoding this?
  #    Restart = "always";
  #  };
  #};
  #systemd.services.aw-watcher-afk = {
  #  wantedBy = [ "default.target" ];
  #  after = [ "aw-server.service" ];
  #  description = "Start Activitywatch afk watcher";
  #  serviceConfig = {
  #    Type = "simple";
  #    User = "johanan";
  #    ExecStart = ''${aw}/bin/aw-watcher-afk'';
  #    Restart = "always";
  #  };
  #};
  #systemd.services.aw-webui = {
  #  wantedBy = [ "default.target" ];
  #  description = "Start Activitywatch web UI";
  #  serviceConfig = {
  #    Type = "forking";
  #    ExecStart = ''${aw}/bin/aw-webui'';
  #  };
  #};
}
