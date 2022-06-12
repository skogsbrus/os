{ config, pkgs, lib, ... }:
{
  services.hostapd = {
    enable = true;
    interface = "wlp3s0";
    extraConfig = ''
      ### hostapd configuration file
      # generic
      beacon_int=100
      channel=0
      driver=nl80211
      country_code=SE
      interface=wlp3s0

      logger_syslog=127
      logger_syslog_level=2
      logger_stdout=127
      logger_stdout_level=2

      ieee80211d=1
      # Disable due to `DFS start_dfs_cac() failed, -1`
      ieee80211h=0
      ieee80211n=1
      # 'a'=5ghz, 'g'=2ghz
      hw_mode=g

      ht_capab=[HT40+][SHORT-GI-40][TX-STBC][RX-STBC1][DSSS_CCK-40]

      # private network
      ssid=morot
      auth_algs=1
      wpa_psk_file=/home/johanan/os/secrets/morot.pw
      wpa=2
      wpa_pairwise=CCMP
      wpa_key_mgmt=WPA-PSK

      bss=wguest
      ssid=icecreamiscream
      auth_algs=1
      ap_isolate=1
      wpa_psk_file=/home/johanan/os/secrets/icecreamiscream.pw
      wpa=2
      wpa_pairwise=CCMP
      wpa_key_mgmt=WPA-PSK
    '';
  };

  nixpkgs.overlays = [
    (self: super: {
      hostapd = super.hostapd.overrideAttrs (old: rec {
        patches = [];
        version = "2.10";
        src = (builtins.fetchGit {
                url = "http://w1.fi/hostap.git";
                ref = "main";
                rev = "72d4ca2fca983adbec82b0ef64dfcc2c9b971f5e";
              });
      });
    })
  ];
}
