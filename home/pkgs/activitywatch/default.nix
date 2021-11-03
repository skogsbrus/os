#with import <nixpkgs> {};
{ stdenv
, python3
, lib
, libsForQt5
, xdg-utils
, mkYarnPackage
}:
stdenv.mkDerivation rec {
  pname = "activitywatch";
  version = "johanan-beta1";

  unpackPhase = "true";

  sources = fetchGit {
    url = "https://github.com/ActivityWatch/activitywatch.git";
    ref = "refs/tags/v0.11.0";
    rev = "62fbdec9c22739fb7c997b6c626b92747e8fd90c";
    submodules = true;
  };


  persist-queue = python3.pkgs.buildPythonPackage rec {
    version = "0.6.0";
    pname = "persist-queue";
    format = "pyproject";

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

    meta = with lib; {
      description = "Thread-safe disk based persistent queue in Python";
      homepage = "https://github.com/peter-wangxu/persist-queue";
      license = licenses.bsd3;
    };
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
      license = licenses.mit;
    };
  };

  aw-core = python3.pkgs.buildPythonPackage rec {
    pname = "aw-core";
    inherit version;
    format = "pyproject";
    src = "${sources}/aw-core";

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

    postPatch = ''
      sed -E 's#python-json-logger = "\^0.1.11"#python-json-logger = "^2.0"#g' -i pyproject.toml
      sed -E 's#tomlkit = "\^0.6.0"#tomlkit = "*"#g' -i pyproject.toml
    '';

    meta = with lib; {
      description = "Core library for ActivityWatch";
      homepage = "https://github.com/ActivityWatch/aw-core";
      maintainers = with maintainers; [ skogsbrus jtojnar ];
      license = licenses.mpl20;
    };
  };

  aw-client = python3.pkgs.buildPythonPackage rec {
    pname = "aw-client";
    inherit version;

    format = "pyproject";

    src = "${sources}/aw-client";

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
      sed -E 's#click = "\^8.0"#click = "^9.0"#g' -i pyproject.toml
    '';

    meta = with lib; {
      description = "Client library for ActivityWatch";
      homepage = "https://github.com/ActivityWatch/aw-client";
      maintainers = with maintainers; [ skogsbrus jtojnar ];
      license = licenses.mpl20;
    };
  };

  aw-watcher-afk = python3.pkgs.buildPythonApplication rec {
    pname = "aw-watcher-afk";
    inherit version;

    format = "pyproject";

    src = "${sources}/aw-watcher-afk";

    nativeBuildInputs = [
      python3.pkgs.poetry
    ];

    propagatedBuildInputs = with python3.pkgs; [
      aw-client
      xlib
      pynput
    ];

    postPatch = ''
      sed -E 's#python-xlib = \{ version = "\^0.28"#python-xlib = \{ version = "^0.29"#g' -i pyproject.toml
    '';

    meta = with lib; {
      description = "Watches keyboard and mouse activity to determine if you are AFK or not (for use with ActivityWatch)";
      homepage = "https://github.com/ActivityWatch/aw-watcher-afk";
      maintainers = with maintainers; [ skogsbrus jtojnar ];
      license = licenses.mpl20;
    };
  };

  aw-watcher-window = python3.pkgs.buildPythonApplication rec {
    pname = "aw-watcher-window";
    inherit version;

    format = "pyproject";

    src = "${sources}/aw-watcher-window";

    nativeBuildInputs = [
      python3.pkgs.poetry
    ];

    propagatedBuildInputs = with python3.pkgs; [
      aw-client
      xlib
    ];

    postPatch = ''
      sed -E 's#python-xlib = \{version = "\^0.28"#python-xlib = \{ version = "^0.29"#g' -i pyproject.toml
    '';

    meta = with lib; {
      description = "Cross-platform window watcher (for use with ActivityWatch)";
      homepage = "https://github.com/ActivityWatch/aw-watcher-window";
      maintainers = with maintainers; [ skogsbrus jtojnar ];
      license = licenses.mpl20;
    };
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
      appdirs
      flask
      flask-restx
      flask-cors
    ];

    # can't pin versions?
    postPatch = ''
      sed -E 's#flask = "\^1.1.1"#flask = "*"#g' -i pyproject.toml
      sed -E 's#flask-restx = "\^0.2.0"#flask-restx = "*"#g' -i pyproject.toml
      sed -E 's#flask-cors = "\^3.0.8"#flask-cors = "*"#g' -i pyproject.toml
    '';

    postFixup = ''
        wrapProgram "$out/bin/aw-server" \
          --prefix XDG_DATA_DIRS : "$out/share"
        mkdir -p "$out/share/aw-server"
        ln -s "${aw-webui}" "$out/share/aw-server/static"
      '';

    meta = with lib; {
      description = "ActivityWatch server for storage of all your Quantified Self data.";
      homepage = "https://github.com/ActivityWatch/aw-server";
      maintainers = with maintainers; [ skogsbrus jtojnar ];
      license = licenses.mpl20;
    };
  };

  aw-webui = mkYarnPackage rec {
    name = "aw-webui";
    src = "${sources}/aw-server/aw-webui";
    packageJSON = "${src}/package.json";
    yarnLock = ./yarn.lock;

    buildPhase = ''
      yarn --offline build
    '';

    installPhase = ''
      mkdir -p $out
      mv deps/aw-webui/dist/* $out
    '';

    distPhase = "true";
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
    ];

    propagatedBuildInputs = with python3.pkgs; [
      aw-core
      pyqt5
      click
    ];

    # Prevent double wrapping
    dontWrapQtApps = true;

    postPatch = ''
      sed -E 's#click = "\^8.0"#click = "^9.0"#g' -i pyproject.toml
      sed -E 's#PyQt5 = "5.15.2"#PyQt5 = "^5.15.2"#g' -i pyproject.toml
    '';

    preBuild = ''
      HOME=$TMPDIR make aw_qt/resources.py
    '';

    postInstall = ''
      install -Dt $out/etc/xdg/autostart resources/aw-qt.desktop
      xdg-icon-resource install --novendor --size 32 media/logo/logo.png activitywatch
      xdg-icon-resource install --novendor --size 512 media/logo/logo.png activitywatch
    '';

    preFixup = ''
      makeWrapperArgs+=(
        "''${qtWrapperArgs[@]}"
      )
    '';

    meta = with lib; {
      description = "Tray icon that manages ActivityWatch processes, built with Qt";
      homepage = "https://github.com/ActivityWatch/aw-qt";
      maintainers = with maintainers; [ skogsbrus jtojnar ];
      license = licenses.mpl20;
    };
  };
  # Why is this needed? Shoud be enough to install the modules separately...?
  installPhase = ''
    mkdir -p $out/bin
    ln -s ${aw-qt}/bin/aw-qt $out/bin/aw-qt
    ln -s ${aw-server}/bin/aw-server $out/bin/aw-server
    ln -s ${aw-watcher-window}/bin/aw-watcher-window $out/bin/aw-watcher-window
    ln -s ${aw-watcher-afk}/bin/aw-watcher-afk $out/bin/aw-watcher-afk
  '';
}
