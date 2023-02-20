{ stdenv
, pkgs ? import <nixpkgs> { }
}:
let
  inherit (pkgs)
    python310;
  myPython = python310.withPackages (ps: with ps; [ transmission-rpc ]);
in
stdenv.mkDerivation rec {
  pname = "rm_unregistered_torrents";
  version = "0.0.0";

  unpackPhase = "true";

  src = fetchGit {
    url = "https://github.com/skogsbrus//studious-octo-palm-tree.git";
    ref = "main";
    rev = "98883187b8b6332446738b5c744b7cf8d2acf675";
  };

  buildInputs = [
    myPython
  ];

  installPhase = ''
    mkdir -p $out/bin
    cp $src/rm_unregistered_torrents.py $out/bin/rm_unregistered_torrents.py
  '';

  meta = {
    description = "Remove unregistered torrents from transmission";
    homepage = "https://github.com/skogsbrus/studious-octo-palm-tree";
  };
}
