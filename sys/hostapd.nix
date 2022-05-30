{ config, pkgs, lib, ... }:
{
  services.hostapd = {
    enable = true;
    interface = "wlp3s0";
    extraConfig = ''
### hostapd configuration file
ssid=beepboop
interface=wlp3s0

driver=nl80211
country_code=SE

logger_syslog=127
logger_syslog_level=2
logger_stdout=127
logger_stdout_level=2

ieee80211d=1
# Disable due to `DFS start_dfs_cac() failed, -1`
ieee80211h=0
ieee80211n=1

# 'a' means 5ghz
hw_mode=a

beacon_int=100
channel=36
chanlist=36

ht_capab=[HT40+][SHORT-GI-40][TX-STBC][RX-STBC1][DSSS_CCK-40]

wpa_psk_file=/home/johanan/os/secrets/beepboop.pw
wpa=2
wpa_pairwise=CCMP
wpa_key_mgmt=WPA-PSK
    '';
  };
  nixpkgs.overlays = [ (self: super: {
    hostapd = super.hostapd.overrideAttrs (old: rec {
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
                sha256 = "1wsxnanirdjf75zqdp6ff5yny8vaxnlb9ss2b3zwwca9ixl41fr1";
                })
            (builtins.fetchurl {
                url = "https://raw.githubusercontent.com/openwrt/openwrt/master/package/network/services/hostapd/patches/200-multicall.patch";
                sha256 = "0y305476mq8zp83hy45spsb16aw8a7720s3cnmc1msj1wx0axvl2";
                })
            (builtins.fetchurl {
                url = "https://raw.githubusercontent.com/openwrt/openwrt/master/package/network/services/hostapd/patches/300-noscan.patch";
                sha256 = "0qfn9in5ly7yk8y4psvbhn3sh667b6v0yjnimga20gclabfylpyb";
                })
            (builtins.fetchurl {
                url = "https://raw.githubusercontent.com/openwrt/openwrt/master/package/network/services/hostapd/patches/301-mesh-noscan.patch";
                sha256 = "1awln2b489j3nam8b81kjjvi91xwm46f5pcjag3smks8ra0v1zw7";
                })
            (builtins.fetchurl {
                url = "https://raw.githubusercontent.com/openwrt/openwrt/master/package/network/services/hostapd/patches/310-rescan_immediately.patch";
                sha256 = "0hvmwkkd2vfhz8yf1rbz11s3x7ll21f12r6kz9pl9mcn80dljicd";
                })
            (builtins.fetchurl {
                url = "https://raw.githubusercontent.com/openwrt/openwrt/master/package/network/services/hostapd/patches/320-optional_rfkill.patch";
                sha256 = "1i243v8sjcxb3bhwy2vmgkrmy622a2v484g8b10y7pr4qzn9z2zg";
                })
            (builtins.fetchurl {
                url = "https://raw.githubusercontent.com/openwrt/openwrt/master/package/network/services/hostapd/patches/330-nl80211_fix_set_freq.patch";
                sha256 = "0zspfajraipx0p50nlj0ym69hx47g4z1hk6f7dpra3ds61l7m7fq";
                })
            (builtins.fetchurl {
                url = "https://raw.githubusercontent.com/openwrt/openwrt/master/package/network/services/hostapd/patches/340-reload_freq_change.patch";
                sha256 = "0cj4almw5aaj908jyy4h3a2klwyyvqhgy76lxml3czfcavylrf47";
                })
            (builtins.fetchurl {
                url = "https://raw.githubusercontent.com/openwrt/openwrt/master/package/network/services/hostapd/patches/341-mesh-ctrl-iface-channel-switch.patch";
                sha256 = "1avv33hghsc23hjxizkh5ppxs1jk0gskkhfy1yj8r73iabgs5m6s";
                })
            (builtins.fetchurl {
                url = "https://raw.githubusercontent.com/openwrt/openwrt/master/package/network/services/hostapd/patches/350-nl80211_del_beacon_bss.patch";
                sha256 = "1701bqy3glm26zy3c2mn3hxyj357xhjfl44c4rcnd8059bspcnxy";
                })
            (builtins.fetchurl {
                url = "https://raw.githubusercontent.com/openwrt/openwrt/master/package/network/services/hostapd/patches/360-ctrl_iface_reload.patch";
                sha256 = "07cialpbc6dl5rmijb7knaq4pgf1vnizq5m9g3caw8czczal9d46";
                })
            (builtins.fetchurl {
                url = "https://raw.githubusercontent.com/openwrt/openwrt/master/package/network/services/hostapd/patches/370-ap_sta_support.patch";
                sha256 = "0a636ihrxqq09vivvcmm6a1x7vxpprhba5izin0f5y7b2vqk4cl6";
                })
            (builtins.fetchurl {
                url = "https://raw.githubusercontent.com/openwrt/openwrt/master/package/network/services/hostapd/patches/380-disable_ctrl_iface_mib.patch";
                sha256 = "1gkf43gbpcqk1h0kjlbx1d3llzx4m23rpw9hc9ijs35zs159yfs1";
                })
            (builtins.fetchurl {
                url = "https://raw.githubusercontent.com/openwrt/openwrt/master/package/network/services/hostapd/patches/381-hostapd_cli_UNKNOWN-COMMAND.patch";
                sha256 = "1l3vdp6z0chcri32prx15mky9dk1wsdzlc6cxwhbpn1yil05yfq3";
                })
            (builtins.fetchurl {
                url = "https://raw.githubusercontent.com/openwrt/openwrt/master/package/network/services/hostapd/patches/390-wpa_ie_cap_workaround.patch";
                sha256 = "107nyd34x9kl3spcfnzwpc8jva36f72jmzdkrjapkjks685vl6sc";
                })
            (builtins.fetchurl {
                url = "https://raw.githubusercontent.com/openwrt/openwrt/master/package/network/services/hostapd/patches/400-wps_single_auth_enc_type.patch";
                sha256 = "0nzfj2fjl9pic4siadahx8wm4vy7v9immvc224k22hbmffaqz98v";
                })
            (builtins.fetchurl {
                url = "https://raw.githubusercontent.com/openwrt/openwrt/master/package/network/services/hostapd/patches/410-limit_debug_messages.patch";
                sha256 = "1nmq4gb3ff9zsrfxiqpfrnv8j9w79m77ahjw6mx53dyxwp0zmy0f";
                })
            (builtins.fetchurl {
                url = "https://raw.githubusercontent.com/openwrt/openwrt/master/package/network/services/hostapd/patches/420-indicate-features.patch";
                sha256 = "16zb20kyfhxqnh03i0nwcy4ky08x27ickh8c0im5cgw6fmggi9sh";
            })
            (builtins.fetchurl {
                url = "https://raw.githubusercontent.com/openwrt/openwrt/master/package/network/services/hostapd/patches/430-hostapd_cli_ifdef.patch";
                sha256 = "10jf1pl8jpl0yp09f6al42j63j82r869lhfpan4iprh8hvnb77mj";
            })
            (builtins.fetchurl {
                url = "https://raw.githubusercontent.com/openwrt/openwrt/master/package/network/services/hostapd/patches/431-wpa_cli_ifdef.patch";
                sha256 = "0zy5548v4d20l6m10pa4ggdcfm0nxpihj17h82kva0aqd2n53nfr";
            })
            (builtins.fetchurl {
                url = "https://raw.githubusercontent.com/openwrt/openwrt/master/package/network/services/hostapd/patches/432-missing-typedef.patch";
                sha256 = "0qw7nxriv6dmpxzgbpbl33spgllxph9qyjnsbqhqq67spii1j6cf";
            })
            (builtins.fetchurl {
                url = "https://raw.githubusercontent.com/openwrt/openwrt/master/package/network/services/hostapd/patches/450-scan_wait.patch";
                sha256 = "1jp9ffbsb537k95w3dllzivarv913i6n3znlfim5qp416yjx75yr";
            })
            (builtins.fetchurl {
                url = "https://raw.githubusercontent.com/openwrt/openwrt/master/package/network/services/hostapd/patches/460-wpa_supplicant-add-new-config-params-to-be-used-with.patch";
                sha256 = "1cpj1fh9r2g8vmhm6nhl0p8mg0sdqvsacqxda03mmpb0i8phznmh";
            })
            (builtins.fetchurl {
                url = "https://raw.githubusercontent.com/openwrt/openwrt/master/package/network/services/hostapd/patches/461-driver_nl80211-use-new-parameters-during-ibss-join.patch";
                sha256 = "0dcq4ik7bjwfpmazq0bb4p3j58inyjlnf3c8m01fkmh8ax422rl8";
            })
            (builtins.fetchurl {
                url = "https://raw.githubusercontent.com/openwrt/openwrt/master/package/network/services/hostapd/patches/463-add-mcast_rate-to-11s.patch";
                sha256 = "0sg64azsgr8d4z8my81y862r2cjxa6x06v3sjbmllz5i0a7sxgz9";
            })
            (builtins.fetchurl {
                url = "https://raw.githubusercontent.com/openwrt/openwrt/master/package/network/services/hostapd/patches/464-fix-mesh-obss-check.patch";
                sha256 = "08chf9rwwzj2aa33qmcgx2dabrmvph6gyd512nms31dvk55l8sxc";
            })
            (builtins.fetchurl {
                url = "https://raw.githubusercontent.com/openwrt/openwrt/master/package/network/services/hostapd/patches/470-survey_data_fallback.patch";
                sha256 = "195y6k22nq5y5vm1xddxrqgx7n0np5bq66xmib0b6xarnmks1m4h";
            })
            (builtins.fetchurl {
                url = "https://raw.githubusercontent.com/openwrt/openwrt/master/package/network/services/hostapd/patches/500-lto-jobserver-support.patch";
                sha256 = "0k13fgidgylv9w9ghdzrip20rxz9y9phibafcilc945rixjvr49p";
            })
            (builtins.fetchurl {
                url = "https://raw.githubusercontent.com/openwrt/openwrt/master/package/network/services/hostapd/patches/590-rrm-wnm-statistics.patch";
                sha256 = "0gmvf6f8v39z1i5ya3rsw8dxbzkblsmizdizvbi93zasbf1lslm2";
            })
            (builtins.fetchurl {
                url = "https://raw.githubusercontent.com/openwrt/openwrt/master/package/network/services/hostapd/patches/599-wpa_supplicant-fix-warnings.patch";
                sha256 = "0hssi2j0cinp028fkcvc1q9ns7q37gvs0rhbw348h61bsm1ddgij";
            })
            # Need to compile with added files to enable this
            #(builtins.fetchurl {
            #    url = "https://raw.githubusercontent.com/openwrt/openwrt/master/package/network/services/hostapd/patches/600-ubus_support.patch";
            #    sha256 = "1rd3dnjhk0lrhi8ci40zzlp5bijyyjj8gvg9pgf7d1ws36n6pvvz";
            #})
            (builtins.fetchurl {
                url = "https://raw.githubusercontent.com/openwrt/openwrt/master/package/network/services/hostapd/patches/610-hostapd_cli_ujail_permission.patch";
                sha256 = "06vpg82lmnq6jkj2qx1z3dvvj6f487rpz1gkfzq61l6xh4amdaq8";
            })
            # depends on 600-ubus
            #(builtins.fetchurl {
            #    url = "https://raw.githubusercontent.com/openwrt/openwrt/master/package/network/services/hostapd/patches/700-wifi-reload.patch";
            #    sha256 = "14g0nyx4gs8kfqn7vmgglysk7k9dv8ppi2vm6dsy608g8qrlr5vq";
            #})
            #(builtins.fetchurl {
            #    url = "https://raw.githubusercontent.com/openwrt/openwrt/master/package/network/services/hostapd/patches/710-vlan_no_bridge.patch";
            #    sha256 = "05fxjsdnzajwq8kb9znp48lhg7x3kic2l1y4z6sn2j0i1n0yqlz3";
            #})
            (builtins.fetchurl {
                url = "https://raw.githubusercontent.com/openwrt/openwrt/master/package/network/services/hostapd/patches/711-wds_bridge_force.patch";
                sha256 = "1xwkpg79178qafb2qlb26blk7m58zadzwlwrgjnxylrbmh6lv79s";
            })
            #(builtins.fetchurl {
            #    url = "https://raw.githubusercontent.com/openwrt/openwrt/master/package/network/services/hostapd/patches/720-iface_max_num_sta.patch";
            #    sha256 = "1iy09zp1xr8mya3kzv7pv60k0h830mnxxxhs1rlgg98fd7p8i0ld";
            #})
            (builtins.fetchurl {
                url = "https://raw.githubusercontent.com/openwrt/openwrt/master/package/network/services/hostapd/patches/730-ft_iface.patch";
                sha256 = "03qrd5q825a60nrh0kndgmycyzbpziqf6bz65avllcy2pm6b27ff";
            })
            (builtins.fetchurl {
                url = "https://raw.githubusercontent.com/openwrt/openwrt/master/package/network/services/hostapd/patches/740-snoop_iface.patch";
                sha256 = "07q23gixnyvz20ih87z25rcim7388jx7c63djgprp7pl4hrbnsgk";
            })
            (builtins.fetchurl {
                url = "https://raw.githubusercontent.com/openwrt/openwrt/master/package/network/services/hostapd/patches/750-qos_map_set_without_interworking.patch";
                sha256 = "1ak72l0n7s1j87671w85nyz590m0js4sm08zg5npj4ykdi8b0iz6";
            })
            (builtins.fetchurl {
                url = "https://raw.githubusercontent.com/openwrt/openwrt/master/package/network/services/hostapd/patches/751-qos_map_ignore_when_unsupported.patch";
                sha256 = "0zp7y7zac0hf9w7bm2lzqz4mkziiq10bn077vhvxaqmyli0hq2gg";
            })
        ];
        version = "2.10";
        src =  null;
        srcs = [
            (builtins.fetchGit {
                url = "https://github.com/openwrt/openwrt.git";
                ref = "master";
                rev = "064e7e57b483e6879de0facef4f1fce86ec4ad47";
            })
            (builtins.fetchGit {
                url = "http://w1.fi/hostap.git";
                ref = "main";
                rev = "72d4ca2fca983adbec82b0ef64dfcc2c9b971f5e";
            })
        ];
        sourceRoot = "./hostapd";
        unpackPhase = ''
            runHook preUnpack
            mkdir -p hostapd/src/utils
            # $srcs will a be space separated string, so can be wrapped as an array
            sources=($srcs)
            cp --no-preserve=mode,ownership -r ''${sources[1]}/* hostapd/
            cp --no-preserve=mode,ownership -r ''${sources[0]}/package/network/services/hostapd/src/src/ap hostapd/src/
            cp --no-preserve=mode,ownership -r ''${sources[0]}/package/network/services/hostapd/src/src/utils hostapd/src/
            cp --no-preserve=mode,ownership -r ''${sources[0]}/package/network/services/hostapd/src/wpa_supplicant hostapd/src/
            runHook postUnpack
        '';
      });
  }) ];
}
