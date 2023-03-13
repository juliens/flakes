{ pkgs ? import <nixpkgs> {} }:
pkgs.stdenv.mkDerivation rec {
  name = "prm";
  version="v3.5.0";
  src = pkgs.fetchzip {
    url = "https://github.com/ldez/prm/releases/download/v3.5.0/prm_${version}_linux_amd64.tar.gz";
    sha256="A1cuCtwDMTqYi1kqctOD7JC8zCMnpeRbN1bm/fbSX1Q=";
    stripRoot=false;
  };
  phases = ["installPhase" "patchPhase"];
  installPhase = ''
    mkdir -p $out/bin
    cp $src/prm $out/bin/prm
    mkdir -p $out/share
    cp $src/LICENSE $out/share/LICENSE
    chmod +x $out/bin/prm
  '';
}
