{ config, pkgs, ... }:

{
  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_10;
    enableTCPIP = false;
    authentication = pkgs.lib.mkForce ''
      # Generated file; do not edit!
      # TYPE  DATABASE        USER            ADDRESS                 METHOD
      local   all             all                                     trust
      host    all             all             127.0.0.1/32            trust
      host    all             all             ::1/128                 trust
    '';
    initialScript = pkgs.writeText "backend-initScript" ''
      CREATE ROLE johanan WITH LOGIN PASSWORD 'postgres' CREATEDB;
      CREATE DATABASE johanan;
      GRANT ALL PRIVILEGES ON DATABASE johanan TO johanan;
    '';
  };
}
