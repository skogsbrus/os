{ stdenv
, lib
, fetchurl
, dpkg
, makeWrapper
, autoPatchelfHook
, libGL
, libX11
, libXdamage
, libXfixes
, libXcomposite
, libXrandr
, cups
, libxkbcommon
, libsecret
, libxcb
, xcbutilwm
, xcbutilrenderutil
, xcbutilimage
, xcbutilkeysyms
, libdrm
, libxshmfence
, fontconfig
, mesa
, nss
, wayland
, udev
, dbus
, glib
, libpulseaudio
, alsaLib
, at-spi2-core
, at-spi2-atk
, harfbuzz
}:
stdenv.mkDerivation {
  pname = "webex";
  version = "41.8.0.19732";

  src = fetchurl {
    url = "https://web.archive.org/web/20210812165638/https://binaries.webex.com/WebexDesktop-Ubuntu-Official-Package/Webex.deb"
    sha256 = "a80a379dea851dfc634a9b44d5da2b7cb6f3b86945576f9cddd1aee423ddfb81";
  };

  nativeBuildInputs = [
    dpkg
    autoPatchelfHook
    makeWrapper
  ];

  buildInputs = [
    mesa.dev # for libgbm
    libGL
    libX11
    libXdamage
    libXfixes
    libXcomposite
    libXrandr
    cups
    libxkbcommon
    libsecret
    libxcb
    xcbutilwm
    xcbutilrenderutil
    xcbutilimage
    xcbutilkeysyms
    libdrm
    libxshmfence
    fontconfig
    nss
    wayland
    udev
    dbus
    glib
    libpulseaudio
    alsaLib
    at-spi2-core
    at-spi2-atk
    harfbuzz
  ];

  dontBuild = true;

  unpackPhase = ''
    dpkg-deb -R $src .
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin $out/share/applications
    cp -r opt $out/
    wrapProgram $out/opt/Webex/bin/CiscoCollabHost \
      --prefix LD_LIBRARY_PATH : $out/opt/Webex/lib
    ln -s $out/opt/Webex/bin/CiscoCollabHost $out/bin/webex
    substitute $out/opt/Webex/bin/webex.desktop $out/share/applications/webex.desktop \
      --replace /opt/Webex/bin/ $out/opt/Webex/bin/
    runHook postInstall
  '';

  meta = with lib; {
    license = licenses.unfree;
    maintainers = with maintainers; [ pacman99 ];
    description = "Webex for Linux";
    platforms = platforms.linux;
  };
}
