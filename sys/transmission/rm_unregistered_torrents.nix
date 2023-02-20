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
    rev = "0c7adda166537c4a0f7078131c99dc64e2cc5773";
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
