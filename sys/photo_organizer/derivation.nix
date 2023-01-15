{ stdenv
, pkgs ? import <nixpkgs> { }
}:
let
  inherit (pkgs)
    exiftool
    mkShell
    python310;

  inherit (pkgs.python310.pkgs)
    buildPythonPackage
    fetchPypi
    setuptools;

  # TODO: contribute to nixpkgs
  pyexifinfo = buildPythonPackage
    rec {
      version = "0.4.0";
      pname = "pyexifinfo";
      format = "pyproject";

      meta = with pkgs.lib; {
        description = "Yet Another python wrapper for Phil Harvey' Exiftool";
        homepage = "https://github.com/guinslym/pyexifinfo";
        license = licenses.gpl3Plus;
      };

      nativeBuildInputs = [
        setuptools
      ];

      propagatedNativeBuildInputs = [
        exiftool
      ];

      postPatch = ''
        substituteInPlace pyexifinfo/pyexifinfo.py \
          --replace "exiftool" "${exiftool}/bin/exiftool"
      '';

      src = fetchPypi {
        inherit pname version;
        sha256 = "sha256-V4s0s8WT/ne75rYliPny7GedymP31IYUjJpv8f3Uvck=";
      };
    };
  myPython = python310.withPackages (ps: with ps; [ pyexifinfo ]);
in
stdenv.mkDerivation rec {
  pname = "photo_organizer";
  version = "0.0.0";

  unpackPhase = "true";

  src = fetchGit {
    url = "https://github.com/skogsbrus/photo_organizer.git";
    ref = "master";
    rev = "9d298cf5151dc7f34b7d5b96d33dceb16754fe4f";
  };

  buildInputs = [
    myPython
  ];

  installPhase = ''
    mkdir -p $out/bin
    cp $src/photo_organizer.py $out/bin/photo_organizer.py
  '';

  meta = {
    description = "Organize your photos by date";
    homepage = "https://github.com/skogsbrus/photo_organizer";
  };
}
