{ pkgs ? import <nixpkgs> {} }:
pkgs.stdenv.mkDerivation rec {
  name = "prm";
  version="v3.5.0";
  src = pkgs.fetchzip {
    url = "https://github.com/ldez/prm/releases/download/v3.5.0/prm_v3.5.0_linux_amd64.tar.gz";
    sha256="0m2zsbvgvrjn6xdy99974g6br47chg9p4ajrifc3lc83vh52wmq3";
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
