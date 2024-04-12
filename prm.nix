
{ lib, fetchFromGitHub, buildGoModule, installShellFiles }:

buildGoModule rec {
  pname = "prm";
  version = "3.5.1";

  src = fetchFromGitHub {
    owner = "ldez";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-cuVJW/PybP7+7qBxXjVfL2webvyQzWgHL7nJXDV/554=";
  };

  vendorHash ="sha256-TseXk1lKpxBmTwYjuDH8ycWUd6lOCMZmIHStl7MDvsY=";

  nativeBuildInputs = [ installShellFiles ];

  doCheck = false;

  ldflags = [
    "-s" "-w"
    " -X \"github.com/ldez/prm/v3/meta.version=v${version}\""
    " -X \"github.com/ldez/prm/v3/meta.version=v${version}\""
    " -X \"github.com/ldez/prm/v3/meta.date=01/01/1970\""
  ];
  postInstall = ''
        for shell in bash zsh fish; do
          HOME=$TMPDIR $out/bin/prm completion $shell > prm.$shell
          installShellCompletion prm.$shell
        done
  '';

  meta = with lib; {
    description = "Pull Request Manager for Maintainers ";
    license = licenses.asl20;
    homepage = "https://ldez.github.io/prm/";
  };

}
