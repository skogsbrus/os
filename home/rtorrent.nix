{ config
, lib
, pkgs
, ...
}:
let
  cfg = config.skogsbrus.rtorrent;
  inherit (lib) concatStrings mkEnableOption mkOption mkIf types;
  defaultSettings = ''
    throttle.min_peers.normal.set = 40
    throttle.max_peers.normal.set = 52

    throttle.min_peers.seed.set = 10
    throttle.max_peers.seed.set = 52

    throttle.max_uploads.set = 8

    throttle.global_down.max_rate.set = 200
    throttle.global_up.max_rate.set = 28

    # Limits for file handle resources, this is optimized for
    # an `ulimit` of 1024 (a common default). You MUST leave
    # a ceiling of handles reserved for rTorrent's internal needs!
    network.http.max_open.set = 50
    network.max_open_files.set = 600
    network.max_open_sockets.set = 300

    # Memory resource usage (increase if you have a large number of items loaded,
    # and/or the available resources to spend)
    pieces.memory.max.set = 1800M
    network.xmlrpc.size_limit.set = 4M

    dht.mode.set = disable
    protocol.pex.set = no
    trackers.use_udp.set = no

    protocol.encryption.set = require,require_RC4,allow_incoming,try_outgoing

    pieces.hash.on_completion.set = yes
    session.path.set = ~/.rtorrent.session

    network.port_range.set = 49169-49169

    # Run headless
    system.daemon.set = true

    # Remote control
    network.scgi.open_local = ~/rtorrent/rpc.socket
    schedule2 = scgi_permission,0,0,"execute.nothrow=chmod,\"g+w,o=\",~/rtorrent/rpc.socket"
  '';
in
{
  options.skogsbrus.rtorrent = {
    enable = mkEnableOption "Whether to enable rtorrent or not";
    extraConfig = mkOption
      {
        type = types.lines;
        default = '''';
        description = "Corresponds to rtorrent.rc";
      };
  };

  config = mkIf cfg.enable {
    programs.rtorrent = {
      enable = true;
      settings = concatStrings ([
        defaultSettings
        cfg.extraConfig
      ]);
    };
    home.packages = with pkgs; [
      flood
    ];
  };
}
