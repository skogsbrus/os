#with import <nixpkgs> {};
{ stdenv
, python3
, makeWrapper
, xorg
, lib
, libsForQt5
, xdg-utils
, mkYarnPackage
}:
stdenv.mkDerivation rec {
  pname = "activitywatch";
  version = "0.11.0-alpha";

  unpackPhase = "true";

  sources = fetchGit {
    url = "https://github.com/ActivityWatch/activitywatch.git";
    ref = "refs/tags/v0.11.0";
    rev = "62fbdec9c22739fb7c997b6c626b92747e8fd90c";
    submodules = true;
  };

  installPhase = ''
    mkdir -p $out/bin
    ln -s ${aw-qt}/bin/aw-qt $out/bin/aw-qt

    # Include these as well, if users want to only use a subset of the services (e.g. everything but the system tray)
    ln -s ${aw-server}/bin/aw-server $out/bin/aw-server
    ln -s ${aw-watcher-window}/bin/aw-watcher-window $out/bin/aw-watcher-window
    ln -s ${aw-watcher-afk}/bin/aw-watcher-afk $out/bin/aw-watcher-afk
    ln -s ${aw-webui} $out/bin/aw-webui
  '';

  meta = with lib; {
    description = "Records what you do so that you can know how you've spent your time. All in a secure way where you control the data.";
    homepage = "https://github.com/ActivityWatch";
  };

  persist-queue = python3.pkgs.buildPythonPackage rec {
    version = "0.6.0";
    pname = "persist-queue";
    format = "pyproject";

    meta = with lib; {
      description = "Thread-safe disk based persistent queue in Python";
      homepage = "https://github.com/peter-wangxu/persist-queue";
      license = licenses.bsd3;
    };

    src = python3.pkgs.fetchPypi {
      inherit pname version;
      sha256 = "5z3WJUXTflGSR9ljaL+lxRD95mmZozjW0tRHkNwQ+Js=";
    };

    checkInputs = with python3.pkgs; [
      msgpack
      nose2
    ];

    checkPhase = ''
      runHook preCheck
      nose2
      runHook postCheck
    '';
  };

  TakeTheTime = python3.pkgs.buildPythonPackage rec {
    pname = "TakeTheTime";
    version = "0.3.1";
    format = "pyproject";

    src = python3.pkgs.fetchPypi {
      inherit pname version;
      sha256 = "2+MEU6G1lqOPni4/qOGtxa8tv2RsoIN61cIFmhb+L/k=";
    };

    checkInputs = [
      python3.pkgs.nose
    ];

    doCheck = false; # tests not available on pypi

    checkPhase = ''
      runHook preCheck
      nosetests -v tests/
      runHook postCheck
    '';

    meta = with lib; {
      description = "Simple time taking library using context managers";
      homepage = "https://github.com/ErikBjare/TakeTheTime";
      maintainers = with maintainers; [ skogsbrus jtojnar ];
      license = licenses.mit;
    };
  };

  timeslot = python3.pkgs.buildPythonPackage rec {
    pname = "timeslot";
    version = "0.1.2";

    src = python3.pkgs.fetchPypi {
      inherit pname version;
      sha256 = "oqyZhlfj87nKkodXtJBq3SwFOQxfwU7XkruQKNCFR7E=";
    };

    meta = with lib; {
      description = "Data type for representing time slots with a start and end";
      homepage = "https://github.com/ErikBjare/timeslot";
      maintainers = with maintainers; [ skogsbrus jtojnar ];
      license = licenses.mit; # TODO: no license
    };
  };

  aw-core = python3.pkgs.buildPythonPackage rec {
    format = "pyproject";
    inherit version;
    pname = "aw-core";
    src = "${sources}/aw-core";

    meta = with lib; {
      description = "Core library for ActivityWatch";
      homepage = "https://github.com/ActivityWatch/aw-core";
      maintainers = with maintainers; [ skogsbrus jtojnar ];
      license = licenses.mpl20;
    };

    nativeBuildInputs = [
      python3.pkgs.poetry
    ];

    propagatedBuildInputs = with python3.pkgs; [
      jsonschema
      peewee
      appdirs
      iso8601
      python-json-logger
      TakeTheTime
      pymongo
      strict-rfc3339
      tomlkit
      deprecation
      timeslot
    ];

    # TODO: pin versions
    postPatch = ''
      substituteInPlace pyproject.toml \
        --replace 'python-json-logger = "^0.1.11"' 'python-json-logger = "^2.0"'

      substituteInPlace pyproject.toml \
        --replace 'tomlkit = "^0.6.0"' 'tomlkit = "*"'
    '';
  };

  aw-client = python3.pkgs.buildPythonPackage rec {
    format = "pyproject";
    inherit version;
    pname = "aw-client";
    src = "${sources}/aw-client";

    meta = with lib; {
      description = "Client library for ActivityWatch";
      homepage = "https://github.com/ActivityWatch/aw-client";
      maintainers = with maintainers; [ skogsbrus jtojnar ];
      license = licenses.mpl20;
    };

    nativeBuildInputs = [
      python3.pkgs.poetry
    ];

    propagatedBuildInputs = with python3.pkgs; [
      aw-core
      requests
      persist-queue
      click
    ];

    postPatch = ''
      substituteInPlace pyproject.toml \
        --replace 'click = "^7.1.1"' 'click = "^8.0"'
    '';
  };

  aw-watcher-afk = python3.pkgs.buildPythonApplication rec {
    format = "pyproject";
    inherit version;
    pname = "aw-watcher-afk";
    src = "${sources}/aw-watcher-afk";

    meta = with lib; {
      description = "Watches keyboard and mouse activity to determine if you are AFK or not (for use with ActivityWatch)";
      homepage = "https://github.com/ActivityWatch/aw-watcher-afk";
      maintainers = with maintainers; [ skogsbrus jtojnar ];
      license = licenses.mpl20;
    };

    nativeBuildInputs = [
      python3.pkgs.poetry
    ];

    propagatedBuildInputs = with python3.pkgs; [
      aw-client
      xlib
      pynput
    ];

    postPatch = ''
      substituteInPlace pyproject.toml \
        --replace 'python-xlib = { version = "^0.28"' 'python-xlib = { version = "^0.29"'
    '';
  };

  aw-watcher-window = python3.pkgs.buildPythonApplication rec {
    format = "pyproject";
    inherit version;
    pname = "aw-watcher-window";
    src = "${sources}/aw-watcher-window";

    meta = with lib; {
      description = "Cross-platform window watcher (for use with ActivityWatch)";
      homepage = "https://github.com/ActivityWatch/aw-watcher-window";
      maintainers = with maintainers; [ skogsbrus jtojnar ];
      license = licenses.mpl20;
    };

    nativeBuildInputs = [
      python3.pkgs.poetry
    ];

    propagatedBuildInputs = with python3.pkgs; [
      aw-client
      xlib
    ];

    postPatch = ''
      substituteInPlace pyproject.toml \
        --replace 'python-xlib = {version = "^0.28"' 'python-xlib = {version = "^0.29"'
    '';
  };

  aw-server = python3.pkgs.buildPythonApplication rec {
    pname = "aw-server";
    inherit version;
    format = "pyproject";
    out = "./out";
    src = "${sources}/aw-server";

    nativeBuildInputs = [
      python3.pkgs.poetry
    ];

    propagatedBuildInputs = with python3.pkgs; [
      aw-core
      aw-client
      aw-webui
      appdirs
      flask
      flask-restx
      flask-cors
      setuptools # for pkg_resources
    ];

    # TODO: pin flask versions
    postPatch = ''
      substituteInPlace pyproject.toml \
        --replace 'flask = "^1.1.1"' 'flask = "*"'

      substituteInPlace pyproject.toml \
        --replace 'flask-restx = "^0.2.0"' 'flask-restx = "*"'

      substituteInPlace pyproject.toml \
        --replace 'flask-cors = "^3.0.8"' 'flask-cors = "*"'
    '';

    # TODO: Possible to use wildcard for python version, e.g. python*?
    postInstall = ''
      # Couldn't get this configured correctly with
      # https://python-poetry.org/docs/pyproject/#include-and-exclude.
      # Symlink manually instead
      ln -s ${aw-webui} "$out/lib/python3.9/site-packages/aw_server/static"
    '';

    meta = with lib; {
      description = "ActivityWatch server for storage of all your Quantified Self data.";
      homepage = "https://github.com/ActivityWatch/aw-server";
      maintainers = with maintainers; [ skogsbrus ];
      license = licenses.mpl20;
    };
  };

  aw-webui = mkYarnPackage rec {
    name = "aw-webui";
    src = "${sources}/aw-server/aw-webui";
    packageJSON = "${src}/package.json";
    yarnLock = ./yarn.lock;

    buildPhase = ''
      yarn build --offline
    '';

    installPhase = ''
      mkdir -p $out
      mv deps/aw-webui/dist/* $out
    '';

    distPhase = "true";

    meta = with lib; {
      description = "A web-based UI for ActivityWatch, built with Vue.js";
      homepage = "https://github.com/ActivityWatch/aw-webui";
      maintainers = with maintainers; [ skogsbrus meain ];
      license = licenses.mpl20;
    };
  };

  aw-qt = python3.pkgs.buildPythonApplication rec {
    pname = "aw-qt";
    inherit version;

    format = "pyproject";

    src = "${sources}/aw-qt";

    nativeBuildInputs = [
      python3.pkgs.poetry
      python3.pkgs.pyqt5 # for pyrcc5
      libsForQt5.wrapQtAppsHook
      xdg-utils
      makeWrapper
    ];

    propagatedBuildInputs = with python3.pkgs; [
      aw-core
      pyqt5
      click
      xorg.xauth
    ];

    # Prevent error: `qt.qpa.plugin: Could not find the Qt platform plugin "xcb" in ""`
    # https://discourse.nixos.org/t/how-can-i-build-a-python-package-that-uses-qt/7657/5
    dontWrapQtApps = true;
    preFixup = ''
      makeWrapperArgs+=(
        "''${qtWrapperArgs[@]}"
      )
    '';

    postPatch = ''
      substituteInPlace pyproject.toml \
        --replace 'PyQt5 = "5.15.2"' 'PyQt5 = "^5.15.2"'

      substituteInPlace pyproject.toml \
        --replace 'click = "^7.1.2"' 'click = "^8.0"'
    '';

    preBuild = ''
      HOME=$TMPDIR make aw_qt/resources.py
    '';

    postInstall = ''
      install -Dt $out/etc/xdg/autostart resources/aw-qt.desktop
      xdg-icon-resource install --novendor --size 32 media/logo/logo.png activitywatch
      xdg-icon-resource install --novendor --size 512 media/logo/logo.png activitywatch

      # Bundle all binaries with aw-qt, so it can find & launch them
      ln -s ${aw-watcher-window}/bin/aw-watcher-window "$out"/lib/python3*/site-packages/aw_qt/aw-watcher-window
      ln -s ${aw-watcher-afk}/bin/aw-watcher-afk "$out"/lib/python3*/site-packages/aw_qt/aw-watcher-afk
      ln -s ${aw-server}/bin/aw-server "$out"/lib/python3*/site-packages/aw_qt/aw-server

      # https://bugs.launchpad.net/ubuntu/+source/python-xlib/+bug/1885304
      wrapProgram $out/bin/aw-qt \
        --run 'xauth add $DISPLAY $(xauth list $DISPLAY | cut -d: -f2- | tail -1)'
    '';

    meta = with lib; {
      description = "Tray icon that manages ActivityWatch processes, built with Qt";
      homepage = "https://github.com/ActivityWatch/aw-qt";
      maintainers = with maintainers; [ skogsbrus jtojnar ];
      license = licenses.mpl20;
    };
  };

}
