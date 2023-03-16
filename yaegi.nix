
{ lib, fetchFromGitHub, buildGoModule, installShellFiles }:

buildGoModule rec {
  pname = "yaegi";
  version = "0.15.0";

  src = fetchFromGitHub {
    owner = "traefik";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-++WA6Xdo9YuMQgCL/c485LgKeV4XeodVZBBYCBsmh+M=";
  };

  vendorHash =null;

  subPackages = [ "cmd/yaegi" ];

  doCheck = false;

  ldflags = [
    "-s" "-w"
    " -X main.version=${version}"
  ];

  meta = with lib; {
    description = "Yaegi is Another Elegant Go Interpreter";
    license = licenses.asl20;
    homepage = "https://pkg.go.dev/github.com/traefik/yaegi";
  };

}
