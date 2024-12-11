{
  description = "A very basic flake";


  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }: let
  in 
    flake-utils.lib.eachDefaultSystem (system:
    let pkgs = nixpkgs.legacyPackages.${system}; in
    {
      packages.prm-bin = import ./prm-bin.nix { inherit pkgs; };
      packages.prm = pkgs.callPackage ./prm.nix {}; 
      packages.gcg = pkgs.callPackage ./gcg.nix {}; 
      packages.tparse = pkgs.callPackage ./tparse.nix {}; 
      packages.mocktail = pkgs.callPackage ./mocktail.nix {}; 
      packages.yaegi = pkgs.callPackage ./yaegi.nix {}; 
      packages.psa-update = pkgs.callPackage ./psa-update.nix {}; 

      packages.go_commit = pkgs.go_1_23.overrideAttrs (finalAttrs: rec {
        GOROOT_BOOTSTRAP="${pkgs.go_1_23}/share/go";
        version = "673a53917043afaf0fd89868251fc08dc98a89df";
        buildInputs = [ pkgs.git ] ++ finalAttrs.buildInputs;
        src = pkgs.fetchFromGitHub {
          owner = "golang";
          repo = "go";
          rev = version;
          name = "go-${version}";
          hash = "sha256-bdDOizxfG3fQhrE4JawtIbqnav3wNY34BMBAohkKlhM=";
      
        };
        #patches = nixpkgs.lib.lists.remove (nixpkgs.lib.lists.last finalAttrs.patches) finalAttrs.patches;
        buildPhase = ''
          export PATH="$PATH:${pkgs.git}/bin"
          echo "dev-${version}" > VERSION
          '' + finalAttrs.buildPhase;
      });
    }
    );
  
}
