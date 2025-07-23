
{ lib, fetchFromGitHub, buildGoModule, installShellFiles }:

buildGoModule rec {
  pname = "golangci-lint";
  version = "1.64.2";

  src = fetchFromGitHub {
    owner = "golangci";
    repo = pname;
    rev = "v${version}";
    name = "golangci-lint-${version}";
    sha256 = "sha256-ODnNBwtfILD0Uy2AKDR/e76ZrdyaOGlCktVUcf9ujy8";
  };

  vendorHash ="sha256-/iq7Ju7c2gS7gZn3n+y0kLtPn2Nn8HY/YdqSDYjtEkI=";

  doCheck = false;

  meta = with lib; {
    description = "Golang CI lint";
  };

}
