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
      packages.tparse = pkgs.callPackage ./tparse.nix {}; 
      packages.mocktail = pkgs.callPackage ./mocktail.nix {}; 
      packages.yaegi = pkgs.callPackage ./yaegi.nix {}; 
      packages.go_commit = pkgs.go_1_23.overrideAttrs (finalAttrs: rec {
        GOROOT_BOOTSTRAP="${pkgs.go_1_23}/share/go";
        version = "f38d42f2c4c6ad0d7cbdad5e1417cac3be2a5dcb";
        buildInputs = [ pkgs.git ] ++ finalAttrs.buildInputs;
        src = pkgs.fetchFromGitHub {
          owner = "golang";
          repo = "go";
          rev = "f38d42f2c4c6ad0d7cbdad5e1417cac3be2a5dcb";
          sha256 = "JHx/1foo1CEuMO0T4+gmSD6OO02Q5A1tBDPy2MULd5A=";
      
        };
        #patches = nixpkgs.lib.lists.remove (nixpkgs.lib.lists.last finalAttrs.patches) finalAttrs.patches;
        buildPhase = ''
          export PATH="$PATH:${pkgs.git}/bin"
          echo "f38d42f2c4c6ad0d7cbdad5e1417cac3be2a5dcb" > VERSION
          '' + finalAttrs.buildPhase;
      });
    }
    );
    
  
}
