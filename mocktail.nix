
{ lib, fetchFromGitHub, buildGoModule, installShellFiles }:

buildGoModule rec {
  pname = "mocktail";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "traefik";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-H538oALiPh0bOkpf8850xepiis9ulG5MwFBdUuCWTL0=";
  };

  vendorHash ="sha256-7qx2YZTKwVhMZC/M5hNLQWzf7PbioKtCNSFPyaQ1NxM=";

  nativeBuildInputs = [ installShellFiles ];

  doCheck = false;

  ldflags = [
    "-s" "-w"
  ];

  meta = with lib; {
    description = "Naive code generator that creates mock implementation using testify.mock. ";
    license = licenses.asl20;
    homepage = "https://github.com/traefik/mocktail";
  };

}
