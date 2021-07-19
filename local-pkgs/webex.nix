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
  #version = "41.5.0.18815";
  version = "41.7.0.19440";

  src = fetchurl {
    url = "https://binaries.webex.com/WebexDesktop-Ubuntu-Official-Package/Webex.deb";
    #sha256 = "sha256-mq4Q1UAm+T2gNLrytfEWeh5vgNe59v/NGxudtm4f8nQ=";
    sha256 = "5b15f4f71024685baa3675e2e1f33d0572cb75943b618ccf67673b04c70904cc";
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
