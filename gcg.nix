
{ lib, fetchFromGitHub, buildGoModule, installShellFiles }:

buildGoModule rec {
  pname = "gcg";
  version = "1.7.11";

  src = fetchFromGitHub {
    owner = "ldez";
    repo = pname;
    rev = "v${version}";
    name = "gcg-${version}";
    sha256 = "sha256-g0DsUwYxpC/WRLtPuVL6MgV5qynzMVZ2bsl1LvE8Ze8";
  };

  vendorHash ="sha256-rYloU0itzYIld4yeKCiD/KHGqeL/fhPJQjSfg1pCIbw";

  nativeBuildInputs = [ installShellFiles ];

  doCheck = false;

  ldflags = [
    "-s" "-w"
  ];

  meta = with lib; {
    description = "GCG is a GitHub Changelog Generator.";
    license = licenses.asl20;
    homepage = "https://github.com/ldez/gcg";
  };

}
