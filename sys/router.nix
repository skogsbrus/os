# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

{

  # https://github.com/mdlayher/homelab/blob/391cfc0de06434e4dee0abe2bec7a2f0637345ac/nixos/routnerr-2/configuration.nix#L38
  # https://serverfault.com/questions/248841/ip-forwarding-when-and-why-is-this-required
  boot = {
    kernel = {
      sysctl = {
        # Forward on all interfaces.
        "net.ipv4.conf.all.forwarding" = true;
        "net.ipv6.conf.all.forwarding" = true;

        # By default, not automatically configure any IPv6 addresses.
        #"net.ipv6.conf.all.accept_ra" = 0;
        #"net.ipv6.conf.all.autoconf" = 0;
        #"net.ipv6.conf.all.use_tempaddr" = 0;

        # On WAN, allow IPv6 autoconfiguration and tempory address use.
        #"net.ipv6.conf.${name}.accept_ra" = 2;
        #"net.ipv6.conf.${name}.autoconf" = 1;
      };
    };
  };

  networking.hostName = "router";
  networking.useDHCP = false;
  networking.interfaces.enp1s0.useDHCP = true;
  #networking.nameservers = [ "127.0.0.1" "9.9.9.9" ];

  networking.nat = {
    enable = true;
    internalIPs = [ "192.168.2.0/24" "192.168.3.0/24" ];
  };

  networking.interfaces = {
    wlp3s0 = {
      useDHCP = false;
      ipv4.addresses = [
        {
          address = "192.168.3.1";
          prefixLength = 24;
        }
      ];
    };
    enp2s0 = {
      useDHCP = false;
      ipv4.addresses = [
        {
          address = "192.168.2.1";
          prefixLength = 24;
        }
      ];
    };
  };

  networking.networkmanager.enable = false;
  services.hostapd = {
    enable = true;
    interface = "wlp3s0";
    # Experiments:
    # g: ~3Mbit/s
    # a: ~10Mbit/s
    ssid = "beepboop";
    extraConfig = ''
      ### hostapd configuration file
      driver=nl80211

      ### IEEE 802.11
      ssid=beepboop
      hw_mode=a
      channel=36
      max_num_sta=128
      auth_algs=1
      disassoc_low_ack=1

      ### DFS
      ieee80211h=1
      ieee80211d=1
      country_code=US

      ### IEEE 802.11n
      ieee80211n=1
      ht_capab=[HT40+][SHORT-GI-40][TX-STBC][RX-STBC1][DSSS_CCK-40]

      ### IEEE 802.11ac
      ieee80211ac=1
      vht_oper_chwidth=1
      vht_oper_centr_freq_seg0_idx=42
      # compared against iw list, antenna patterns unclear
      vht_capab=[TX-STBC]

      ### WPA/IEEE 802.11i
      wpa=2
      wpa_key_mgmt=WPA-PSK
      wpa_passphrase=foobar123
      wpa_pairwise=CCMP

      ### hostapd event logger configuration
      logger_syslog=-1
      logger_syslog_level=0
      logger_stdout=-1
      logger_stdout_level=0

      ### WMM
      wmm_enabled=1
      uapsd_advertisement_enabled=1
      wmm_ac_bk_cwmin=4
      wmm_ac_bk_cwmax=10
      wmm_ac_bk_aifs=7
      wmm_ac_bk_txop_limit=0
      wmm_ac_bk_acm=0
      wmm_ac_be_aifs=3
      wmm_ac_be_cwmin=4
      wmm_ac_be_cwmax=10
      wmm_ac_be_txop_limit=0
      wmm_ac_be_acm=0
      wmm_ac_vi_aifs=2
      wmm_ac_vi_cwmin=3
      wmm_ac_vi_cwmax=4
      wmm_ac_vi_txop_limit=94
      wmm_ac_vi_acm=0
      wmm_ac_vo_aifs=2
      wmm_ac_vo_cwmin=2
      wmm_ac_vo_cwmax=3
      wmm_ac_vo_txop_limit=47
      wmm_ac_vo_acm=0

      ### TX queue parameters
      tx_queue_data3_aifs=7
      tx_queue_data3_cwmin=15
      tx_queue_data3_cwmax=1023
      tx_queue_data3_burst=0
      tx_queue_data2_aifs=3
      tx_queue_data2_cwmin=15
      tx_queue_data2_cwmax=63
      tx_queue_data2_burst=0
      tx_queue_data1_aifs=1
      tx_queue_data1_cwmin=7
      tx_queue_data1_cwmax=15
      tx_queue_data1_burst=3.0
      tx_queue_data0_aifs=1
      tx_queue_data0_cwmin=3
      tx_queue_data0_cwmax=7
      tx_queue_data0_burst=1.5

    '';
  };

  services.dnsmasq = {
    enable = true;
    servers = [ "9.9.9.9" "1.1.1.1" ];
    extraConfig = ''
      interface=enp2s0
      interface=wlp3s0
      bind-interfaces
      dhcp-range=192.168.2.10,192.168.2.254,24h
      dhcp-range=192.168.3.10,192.168.3.254,24h
    '';
  };

  networking.firewall = {
    enable = true;
    trustedInterfaces = [ "wlp3s0" ];
    allowedTCPPorts = [
      80
      443
      2222
    ];
  };
}
