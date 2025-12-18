
{ lib, fetchFromGitHub, buildGoModule, installShellFiles }:

buildGoModule rec {
  pname = "Mole";
  version = "1.13.13";

  src = fetchFromGitHub {
    owner = "tw93";
    repo = pname;
    rev = "V${version}";
    name = "Mole-${version}";
    sha256 = "sha256-8Ukaryh3s22cp/wmQXbkadAwyWzLWgcydbIBnwwka8A=";
  };

  vendorHash = "sha256-6FYpesat7hkjhDG+Yt0cZ019cgP7351B8bQgxz1BYAw=";

  nativeBuildInputs = [ installShellFiles ];

  doCheck = false;

  postInstall = ''
    # Copy bin/ and lib/ directories to libexec
    mkdir -p $out/libexec/mole
    cp -r $src/bin $out/libexec/mole/
    cp -r $src/lib $out/libexec/mole/

    # Install the main mole and mo scripts
    install -Dm755 $src/mole $out/bin/mole
    install -Dm755 $src/mo $out/bin/mo

    # Patch the scripts to use the correct SCRIPT_DIR
    substituteInPlace $out/bin/mole \
      --replace-fail 'SCRIPT_DIR="$(cd "$(dirname "''${BASH_SOURCE[0]}")" && pwd)"' \
                     'SCRIPT_DIR="'"$out"'/libexec/mole"'

    substituteInPlace $out/bin/mo \
      --replace-fail 'SCRIPT_DIR="$(cd "$(dirname "''${BASH_SOURCE[0]}")" && pwd)"' \
                     'SCRIPT_DIR="'"$out"'/libexec/mole"'

    # Update references in mo to find the main mole script in bin
    substituteInPlace $out/bin/mo \
      --replace-fail '"$SCRIPT_DIR/mole"' '"'"$out"'/bin/mole"'
  '';

  meta = with lib; {
    description = "🐹 Deep clean and optimize your Mac.";
    license = licenses.mit;
  };

}
