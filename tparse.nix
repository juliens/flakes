
{ lib, fetchFromGitHub, buildGoModule, installShellFiles }:

buildGoModule rec {
  pname = "tparse";
  version = "0.13.3";

  src = fetchFromGitHub {
    owner = "mfridman";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-MTaxEWRNAXem/DIirrd53YEHA/A5S4wNX4osuMV3gtc=";
  };

  vendorHash ="sha256-j+1B2zWONjFEGoyesX0EW964kD33Jy3O1aB1WEwlESA=";

  doCheck = false;


  meta = with lib; {
    description = "CLI tool for summarizing go test output. Pipe friendly. CI/CD friendly.";
    license = licenses.mit;
  };

}
