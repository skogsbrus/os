{ config
, lib
, pkgs
, modulesPath
, ...
}:
{
  imports = [
    ../../home
  ];

  skogsbrus = {
    lspServers = {
      enable = true;
      enableAll = true;
    };

    rtorrent = {
      enable = true;
      extraConfig = ''
        directory.default.set = ~/rtorrent/downloads

        # https://rtorrent-docs.readthedocs.io/en/latest/cmd-ref.html#term-schedule2
        schedule2 = tied_directory,5,5,start_tied=
        schedule2 = untied_directory,5,5,remove_untied=
        schedule2 = watch_directory_movies,5,5,"load.start=~/rtorrent/watch/movies/*.torrent,d.directory.set=/mnt/media/movies,d.custom1.set=movies"
        schedule2 = watch_directory_tv,5,5,"load.start=~/rtorrent/watch/tv/*.torrent,d.directory.set=/mnt/media/tv,d.custom1.set=tv"
        schedule2 = low_diskspace,5,60,((close_low_diskspace,5G))
      '';
    };
  };
}
