# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:
#let patchedHostapd = pkgs.hostapd.overrideAttrs (oldAttrs: rec {
#    patches = [
#      (builtins.fetchurl {
#        url = "https://raw.githubusercontent.com/openwrt/openwrt/eefed841b05c3cd4c65a78b50ce0934d879e6acf/package/network/services/hostapd/patches/300-noscan.patch";
#        sha256 = "08p5frxhpq1rp2nczkscapwwl8g9nc4fazhjpxic5bcbssc3sb00";
#      })
#   ];
#  });
#in
#
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
    #path = [ patchedHostapd ];
    enable = true;
    interface = "wlp3s0";
    # Experiments:
    # g: ~3Mbit/s
    # a: ~10Mbit/s
    ssid = "beepboop";
    extraConfig = ''
driver=nl80211
logger_syslog=127
logger_syslog_level=2
logger_stdout=127
logger_stdout_level=2
country_code=SE
ieee80211d=1
ieee80211h=1
hw_mode=a
beacon_int=100
dtim_period=2
channel=52
chanlist=52


ieee80211n=1
ht_coex=0
ht_capab=[HT40+][SHORT-GI-40][TX-STBC][RX-STBC1][DSSS_CCK-40]

#radio_config_id=8a0ad72fc63f2d9038e68b4de60c0e59
interface=wlp3s0
#ctrl_interface=/var/run/hostapd
ap_isolate=1
bss_load_update_period=60
chan_util_avg_period=600
disassoc_low_ack=1
skip_inactivity_poll=0
preamble=1
wmm_enabled=1
ignore_broadcast_ssid=0
uapsd_advertisement_enabled=1
utf8_ssid=1
multi_ap=0
wpa_passphrase=foobar123
#wpa_psk_file=/var/run/hostapd-wlan0.psk
auth_algs=1
wpa=2
wpa_pairwise=CCMP
ssid=beepboop
bridge=br-lan
wds_bridge=
#snoop_iface=br-lan
wpa_disable_eapol_key_retries=0
wpa_key_mgmt=WPA-PSK
okc=0
disable_pmksa_caching=1
dynamic_vlan=0
vlan_naming=1
#vlan_no_bridge=1
#vlan_file=/var/run/hostapd-wlan0.vlan
qos_map_set=0,0,2,16,1,1,255,255,18,22,24,38,40,40,44,46,48,56
#config_id=9c850d8e3e9d1dab50cd1902f1e72c7a
bssid=04:f0:21:ac:39:fa


bss=wlp3s0-1
ctrl_interface=/var/run/hostapd
ap_isolate=1
bss_load_update_period=60
chan_util_avg_period=600
disassoc_low_ack=1
skip_inactivity_poll=0
preamble=1
wmm_enabled=1
ignore_broadcast_ssid=0
uapsd_advertisement_enabled=1
utf8_ssid=1
multi_ap=0
wpa_passphrase=foobar123
wpa_psk_file=/var/run/hostapd-wlan0-1.psk
auth_algs=1
wpa=2
wpa_pairwise=CCMP
ssid=beepboop-guest
bridge=br-lan
wds_bridge=
#snoop_iface=br-lan
wpa_disable_eapol_key_retries=0
wpa_key_mgmt=WPA-PSK
okc=0
disable_pmksa_caching=1
dynamic_vlan=0
vlan_naming=1
#vlan_no_bridge=1
#vlan_file=/var/run/hostapd-wlan0-1.vlan
qos_map_set=0,0,2,16,1,1,255,255,18,22,24,38,40,40,44,46,48,56
#config_id=99e2fef80d8184cddaea0f499a3804dc
bssid=06:f0:21:ac:39:fa
    '';
  };

  services.dnsmasq = {
    enable = true;
    servers = [ "9.9.9.9" "1.1.1.1" ];
    extraConfig = ''
      domain-needed
      interface=enp2s0
      interface=wlp3s0
      bind-interfaces
      dhcp-range=192.168.2.10,192.168.2.254,24h
      dhcp-range=192.168.3.10,192.168.3.254,24h
      dhcp-range=::f,::ff,constructor:enp2s0
      dhcp-authoritative
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
