{ lib
, fetchurl
, fetchpatch
, fetchFromGitHub
, autoPatchelfHook
# , SDL2
# , SDL2_image
# , SDL2_mixer
# , SDL2_ttf
# , ffmpeg_3
, libopus
, libva
, libvdpau
, qt514
}:

# This derivation is only for x86_64-linux currently.
# It relies on pre-compiled (customized) SDL2 & ffmpeg libraries that Valve compiled
# The source is only available for ffmpeg (haven't been able to get clean compilation), but not SDL2
# Based on https://github.com/flathub/com.valvesoftware.SteamLink
# and https://github.com/flathub/flathub/pull/2142

let
  steamlinkPatchedQt514 = qt514.overrideScope' (
    selfqt: superqt: {
      qtbase = superqt.qtbase.overrideAttrs(oldAttrs: {
        patches = oldAttrs.patches ++ [
          (fetchpatch {
            url = "https://raw.githubusercontent.com/flathub/com.valvesoftware.SteamLink/e4327147e89e424370921a865020ff5f1c3987bb/patches/steamlink/qtbase.patch";
            sha256 = "0p9hp5kps3ilk4xbpfmraj6nh2szxsgwv2awqmdmwpa7ffbbapn2";
            stripLen = 1;
            excludes = [
              # These don't apply cleanly, so excluded.
              # ARM-related patches, probably for Raspbian SteamLink
              "src/corelib/global/qfloat16.cpp"
              "src/gui/image/image.pri"
              "src/gui/painting/painting.pri"
              "src/plugins/platforms/android/qandroidassetsfileenginehandler.cpp"
              # Handled separately in custom patch below b/c it doesn't apply cleanly on 5.14.2 (wants 5.14.1)
              "src/platformsupport/devicediscovery/qdevicediscovery_udev.cpp"
            ];
          })
          ./0001-qtbase-custom-qdevicediscovery-udev.patch
          (fetchpatch {
            url = "https://raw.githubusercontent.com/flathub/com.valvesoftware.SteamLink/e4327147e89e424370921a865020ff5f1c3987bb/patches/org.kde.Sdk/qtbase-avoid-hardcoding-kernel-version.patch";
            sha256 = "16yk45fqfhk8xb29v9vnlavp3yrhql4hj4cp6c3g23i68gdpi3xi";
          })
          (fetchpatch {
            url = "https://raw.githubusercontent.com/flathub/com.valvesoftware.SteamLink/e4327147e89e424370921a865020ff5f1c3987bb/patches/org.kde.Sdk/qtbase-use-wayland-on-gnome.patch";
            sha256 = "1vycrd0khn8z49rgp31vfabs6k6p6437kvv4jcl96bcn7myh4xrh";
          })
          (fetchpatch {
            url = "https://raw.githubusercontent.com/flathub/com.valvesoftware.SteamLink/e4327147e89e424370921a865020ff5f1c3987bb/patches/org.kde.Sdk/qtbase-revert-correct-handling-for-xdg-runtime-dir.patch";
            sha256 = "0p3mkzb5pk2d80rv3fvajnybvg4zc4p9fg48vxisi2s8k5q42w4p";
          })
          (fetchpatch {
            url = "https://raw.githubusercontent.com/flathub/com.valvesoftware.SteamLink/e4327147e89e424370921a865020ff5f1c3987bb/patches/org.kde.Sdk/qtbase-make-sure-to-correctly-construct-base-platform-theme.patch";
            sha256 = "12685zy2n4n614wfiaaw90b3dh5iq4l179ajx3sc51blpsh8h0l6";
          })
          (fetchpatch {
            url = "https://raw.githubusercontent.com/flathub/com.valvesoftware.SteamLink/e4327147e89e424370921a865020ff5f1c3987bb/patches/org.kde.Sdk/open-file-portal-writable.patch";
            sha256 = "0ldn01gcbcjyarjsdfc9s0wr95xpmd8w966bwkrq4ka155k39cx5";
          })
        ];
      });
    }
  );
in

steamlinkPatchedQt514.mkDerivation rec {
  pname = "steamlink";
  version = "1.1.75.187";

  src = fetchurl {
    url = "https://repo.steampowered.com/${pname}/${version}/${pname}-${version}.tgz";
    hash = "sha256-iXbJvnKFgVsd7Kq1fmCmWscn8b/dvY4LpJ+kmjuj2Do=";
  };
  # src = steamlinkFlathubRepo;

  nativeBuildInputs = [
    autoPatchelfHook
  ];

  buildInputs = [
    # Uses bundled, patched SDL2 & ffmpeg, so can't use the Nixpkgs versions (esp b/c the patches aren't available)
    # SDL2
    # SDL2_image
    # SDL2_mixer
    # SDL2_ttf
    # ffmpeg_3
    steamlinkPatchedQt514.qtsvg
    libopus
    libva
    libvdpau
    # full
    # flatpak-builder
  ];

  installPhase = ''
    mkdir -p $out/bin $out/lib
    cp ./bin/* $out/bin
    cp ./lib/* $out/lib
  '';

  # doInstallCheck = true;
  # installCheckPhase = ''
  #   $out/bin/steamlink --help
  # '';

  meta = with lib; {
    description = "Stream games from another computer with Steam";
    homepage = "https://store.steampowered.com/steamlink/about/";
    license = licenses.unfreeRedistributable;
    maintainers = with maintainers; [ drewrisinger ];
    platforms = [ "x86_64-linux" ];
    broken = versionOlder trivial.version "20.08";
  };
}
