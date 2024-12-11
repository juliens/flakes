
{ lib, fetchFromGitHub, buildGoModule, installShellFiles }:

buildGoModule rec {
  pname = "mocktail";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "traefik";
    repo = pname;
    rev = "v${version}";
    name = "mocktail-${version}";
    sha256 = "sha256-9BQNeaRe/w0i7mP+TfkplwoDmhYr9tXa3Cjo/ajTi88=";
  };

  vendorHash ="sha256-nbEOaQ+KLVMOuxTG1q/SQnxXzkqqzT8o2pQ4wVvjRZY=";

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
