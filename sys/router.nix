# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:
let patchedHostapd = pkgs.hostapd.overrideAttrs (old: rec {
    patches = [
        (builtins.fetchurl {
            url = "https://raw.githubusercontent.com/openwrt/openwrt/master/package/network/services/hostapd/patches/001-wolfssl-init-RNG-with-ECC-key.patch";
            sha256 = "1h4wqn6dpc5vw19428v6s49i3xsdqc1ikwv6gvdhs2ly98cxwb91";
        })
        (builtins.fetchurl {
            url = "https://raw.githubusercontent.com/openwrt/openwrt/master/package/network/services/hostapd/patches/010-mesh-Allow-DFS-channels-to-be-selected-if-dfs-is-ena.patch";
            sha256 = "06limshm4zprqd2cnjf2911k8dg2rc5wvdkqcdlxw49r5ihb4wmh";
        })
        (builtins.fetchurl {
            url = "https://raw.githubusercontent.com/openwrt/openwrt/master/package/network/services/hostapd/patches/011-mesh-use-deterministic-channel-on-channel-switch.patch";
            sha256 = "1nkp8kmq1dxhrf19cz346jyaxh888vgvl9hnlsdqak5cb5g0k0a6";
            })
        (builtins.fetchurl {
            url = "https://raw.githubusercontent.com/openwrt/openwrt/master/package/network/services/hostapd/patches/021-fix-sta-add-after-previous-connection.patch";
            sha256 = "1nj4h8z8kz335cwz6qq1qd0k0h5c47nhqvpb6n4k0mabw3q19rd5";
            })
        (builtins.fetchurl {
            url = "https://raw.githubusercontent.com/openwrt/openwrt/master/package/network/services/hostapd/patches/022-hostapd-fix-use-of-uninitialized-stack-variables.patch";
            sha256 = "1sfy9j86550g90gw5w80773dgf6i1w22sidichxjqgkhdm507kz7";
            })
        (builtins.fetchurl {
            url = "https://raw.githubusercontent.com/openwrt/openwrt/master/package/network/services/hostapd/patches/023-ndisc_snoop-call-dl_list_del-before-freeing-ipv6-add.patch";
            sha256 = "03pq0h5lmlgn05dkd5vf0v3abaa30vza962vbp9kc66jbga38113";
            })
        (builtins.fetchurl {
            url = "https://raw.githubusercontent.com/openwrt/openwrt/master/package/network/services/hostapd/patches/030-driver_nl80211-rewrite-neigh-code-to-not-depend-on-l.patch";
            sha256 = "0vl3v7b2p17maxnz02jiy89rz6jbmj54sqxkw14j1s6mxji0x510";
            })
        (builtins.fetchurl {
            url = "https://raw.githubusercontent.com/openwrt/openwrt/master/package/network/services/hostapd/patches/040-mesh-allow-processing-authentication-frames-in-block.patch";
            sha256 = "0w56gr3lp6h2y88vc1g6ddjvrymrg9sv65bhq46dcjjc6i6fgq96";
            })
        (builtins.fetchurl {
            url = "https://raw.githubusercontent.com/openwrt/openwrt/master/package/network/services/hostapd/patches/050-build_fix.patch";
            sha256 = "19km2glb39nqd3a25dsh2mnv57yj8mywi0kln86rizncyv0wbp5f";
            })
        (builtins.fetchurl {
            url = "https://raw.githubusercontent.com/openwrt/openwrt/master/package/network/services/hostapd/patches/100-daemonize_fix.patch";
            sha256 = lib.fakeSha256;
            })
        (builtins.fetchurl {
            url = "https://raw.githubusercontent.com/openwrt/openwrt/master/package/network/services/hostapd/patches/200-multicall.patch";
            sha256 = lib.fakeSha256;
            })
        (builtins.fetchurl {
            url = "https://raw.githubusercontent.com/openwrt/openwrt/master/package/network/services/hostapd/patches/300-noscan.patch";
            sha256 = lib.fakeSha256;
            })
        (builtins.fetchurl {
            url = "https://raw.githubusercontent.com/openwrt/openwrt/master/package/network/services/hostapd/patches/301-mesh-noscan.patch";
            sha256 = lib.fakeSha256;
            })
        (builtins.fetchurl {
            url = "https://raw.githubusercontent.com/openwrt/openwrt/master/package/network/services/hostapd/patches/310-rescan_immediately.patch";
            sha256 = lib.fakeSha256;
            })
        (builtins.fetchurl {
            url = "https://raw.githubusercontent.com/openwrt/openwrt/master/package/network/services/hostapd/patches/320-optional_rfkill.patch";
            sha256 = lib.fakeSha256;
            })
        (builtins.fetchurl {
            url = "https://raw.githubusercontent.com/openwrt/openwrt/master/package/network/services/hostapd/patches/330-nl80211_fix_set_freq.patch";
            sha256 = lib.fakeSha256;
            })
        (builtins.fetchurl {
            url = "https://raw.githubusercontent.com/openwrt/openwrt/master/package/network/services/hostapd/patches/340-reload_freq_change.patch";
            sha256 = lib.fakeSha256;
            })
        (builtins.fetchurl {
            url = "https://raw.githubusercontent.com/openwrt/openwrt/master/package/network/services/hostapd/patches/341-mesh-ctrl-iface-channel-switch.patch";
            sha256 = lib.fakeSha256;
            })
        (builtins.fetchurl {
            url = "https://raw.githubusercontent.com/openwrt/openwrt/master/package/network/services/hostapd/patches/350-nl80211_del_beacon_bss.patch";
            sha256 = lib.fakeSha256;
            })
        (builtins.fetchurl {
            url = "https://raw.githubusercontent.com/openwrt/openwrt/master/package/network/services/hostapd/patches/360-ctrl_iface_reload.patch";
            sha256 = lib.fakeSha256;
            })
        (builtins.fetchurl {
            url = "https://raw.githubusercontent.com/openwrt/openwrt/master/package/network/services/hostapd/patches/370-ap_sta_support.patch";
            sha256 = lib.fakeSha256;
            })
        (builtins.fetchurl {
            url = "https://raw.githubusercontent.com/openwrt/openwrt/master/package/network/services/hostapd/patches/380-disable_ctrl_iface_mib.patch";
            sha256 = lib.fakeSha256;
            })
        (builtins.fetchurl {
            url = "https://raw.githubusercontent.com/openwrt/openwrt/master/package/network/services/hostapd/patches/381-hostapd_cli_UNKNOWN-COMMAND.patch";
            sha256 = lib.fakeSha256;
            })
        (builtins.fetchurl {
            url = "https://raw.githubusercontent.com/openwrt/openwrt/master/package/network/services/hostapd/patches/390-wpa_ie_cap_workaround.patch";
            sha256 = lib.fakeSha256;
            })
        (builtins.fetchurl {
            url = "https://raw.githubusercontent.com/openwrt/openwrt/master/package/network/services/hostapd/patches/400-wps_single_auth_enc_type.patch";
            sha256 = lib.fakeSha256;
            })
        (builtins.fetchurl {
            url = "https://raw.githubusercontent.com/openwrt/openwrt/master/package/network/services/hostapd/patches/410-limit_debug_messages.patch";
            sha256 = lib.fakeSha256;
            })
        (builtins.fetchurl {
            url = "https://raw.githubusercontent.com/openwrt/openwrt/master/package/network/services/hostapd/patches/420-indicate-features.patch";
            sha256 = lib.fakeSha256;
        })
        (builtins.fetchurl {
            url = "https://raw.githubusercontent.com/openwrt/openwrt/master/package/network/services/hostapd/patches/430-hostapd_cli_ifdef.patch";
            sha256 = lib.fakeSha256;
        })
        (builtins.fetchurl {
            url = "https://raw.githubusercontent.com/openwrt/openwrt/master/package/network/services/hostapd/patches/431-wpa_cli_ifdef.patch";
            sha256 = lib.fakeSha256;
        })
        (builtins.fetchurl {
            url = "https://raw.githubusercontent.com/openwrt/openwrt/master/package/network/services/hostapd/patches/432-missing-typedef.patch";
            sha256 = lib.fakeSha256;
        })
        (builtins.fetchurl {
            url = "https://raw.githubusercontent.com/openwrt/openwrt/master/package/network/services/hostapd/patches/450-scan_wait.patch";
            sha256 = lib.fakeSha256;
        })
        (builtins.fetchurl {
            url = "https://raw.githubusercontent.com/openwrt/openwrt/master/package/network/services/hostapd/patches/460-wpa_supplicant-add-new-config-params-to-be-used-with.patch";
            sha256 = lib.fakeSha256;
        })
        (builtins.fetchurl {
            url = "https://raw.githubusercontent.com/openwrt/openwrt/master/package/network/services/hostapd/patches/461-driver_nl80211-use-new-parameters-during-ibss-join.patch";
            sha256 = lib.fakeSha256;
        })
        (builtins.fetchurl {
            url = "https://raw.githubusercontent.com/openwrt/openwrt/master/package/network/services/hostapd/patches/463-add-mcast_rate-to-11s.patch";
            sha256 = lib.fakeSha256;
        })
        (builtins.fetchurl {
            url = "https://raw.githubusercontent.com/openwrt/openwrt/master/package/network/services/hostapd/patches/464-fix-mesh-obss-check.patch";
            sha256 = lib.fakeSha256;
        })
        (builtins.fetchurl {
            url = "https://raw.githubusercontent.com/openwrt/openwrt/master/package/network/services/hostapd/patches/470-survey_data_fallback.patch";
            sha256 = lib.fakeSha256;
        })
        (builtins.fetchurl {
            url = "https://raw.githubusercontent.com/openwrt/openwrt/master/package/network/services/hostapd/patches/500-lto-jobserver-support.patch";
            sha256 = lib.fakeSha256;
        })
        (builtins.fetchurl {
            url = "https://raw.githubusercontent.com/openwrt/openwrt/master/package/network/services/hostapd/patches/590-rrm-wnm-statistics.patch";
            sha256 = lib.fakeSha256;
        })
        (builtins.fetchurl {
            url = "https://raw.githubusercontent.com/openwrt/openwrt/master/package/network/services/hostapd/patches/599-wpa_supplicant-fix-warnings.patch";
            sha256 = lib.fakeSha256;
        })
        (builtins.fetchurl {
            url = "https://raw.githubusercontent.com/openwrt/openwrt/master/package/network/services/hostapd/patches/600-ubus_support.patch";
            sha256 = lib.fakeSha256;
        })
        (builtins.fetchurl {
            url = "https://raw.githubusercontent.com/openwrt/openwrt/master/package/network/services/hostapd/patches/610-hostapd_cli_ujail_permission.patch";
            sha256 = lib.fakeSha256;
        })
        (builtins.fetchurl {
            url = "https://raw.githubusercontent.com/openwrt/openwrt/master/package/network/services/hostapd/patches/700-wifi-reload.patch";
            sha256 = lib.fakeSha256;
        })
        (builtins.fetchurl {
            url = "https://raw.githubusercontent.com/openwrt/openwrt/master/package/network/services/hostapd/patches/710-vlan_no_bridge.patch";
            sha256 = lib.fakeSha256;
        })
        (builtins.fetchurl {
            url = "https://raw.githubusercontent.com/openwrt/openwrt/master/package/network/services/hostapd/patches/711-wds_bridge_force.patch";
            sha256 = lib.fakeSha256;
        })
        (builtins.fetchurl {
            url = "https://raw.githubusercontent.com/openwrt/openwrt/master/package/network/services/hostapd/patches/720-iface_max_num_sta.patch";
            sha256 = lib.fakeSha256;
        })
        (builtins.fetchurl {
            url = "https://raw.githubusercontent.com/openwrt/openwrt/master/package/network/services/hostapd/patches/730-ft_iface.patch";
            sha256 = lib.fakeSha256;
        })
        (builtins.fetchurl {
            url = "https://raw.githubusercontent.com/openwrt/openwrt/master/package/network/services/hostapd/patches/740-snoop_iface.patch";
            sha256 = lib.fakeSha256;
        })
        (builtins.fetchurl {
            url = "https://raw.githubusercontent.com/openwrt/openwrt/master/package/network/services/hostapd/patches/750-qos_map_set_without_interworking.patch";
            sha256 = lib.fakeSha256;
        })
        (builtins.fetchurl {
            url = "https://raw.githubusercontent.com/openwrt/openwrt/master/package/network/services/hostapd/patches/751-qos_map_ignore_when_unsupported.patch";
            sha256 = lib.fakeSha256;
        })
    ];
    src =  null;
    srcs = [
        (builtins.fetchGit {
            url = "https://github.com/openwrt/openwrt.git";
            ref = "master";
            rev = "064e7e57b483e6879de0facef4f1fce86ec4ad47";
        })
        (builtins.fetchurl {
            url = "https://w1.fi/releases/hostapd-2.10.tar.gz";
            sha256 = "sha256-IG58eZtnhXLC49EgMCOHhLxKn4IyOwFWtMlGbxSYkV0=";
        })
    ];
    sourceRoot = ".";
    postUnpack = ''
        cp -r source/package/network/services/hostapd/src/src ./hostapd-2.9
        cd hostapd-2.10
    '';
  });
in
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
  systemd.services.hostapd.path = [ patchedHostapd ];

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
    trustedInterfaces = [ "wlp3s0" "enp2s0" ];
    allowedTCPPorts = [
      80
      443
      2222
    ];
  };
}
