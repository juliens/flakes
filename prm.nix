
{ lib, fetchFromGitHub, buildGoModule, installShellFiles }:

buildGoModule rec {
  pname = "prm";
  version = "3.6.0";

  src = fetchFromGitHub {
    owner = "ldez";
    repo = pname;
    rev = "v${version}";
    name = "prm-${version}";
    sha256 = "sha256-33PMZbajqRaBbY9wwFxtyNpfeNUt2WS+rBF4DNa6uzA";
  };

  vendorHash ="sha256-mlBwTibTOCpRlCTGw7ZVFvSDmuuzc8waXM4SXvm3Z8U";

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
