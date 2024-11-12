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
      packages.psa-update = pkgs.callPackage ./psa-update.nix {}; 

      packages.go_commit = pkgs.go_1_23.overrideAttrs (finalAttrs: rec {
        GOROOT_BOOTSTRAP="${pkgs.go_1_23}/share/go";
        version = "201b9f6d6b46e0ae311e8a8b2cbe2ad6652f5680";
        buildInputs = [ pkgs.git ] ++ finalAttrs.buildInputs;
        src = pkgs.fetchFromGitHub {
          owner = "golang";
          repo = "go";
          rev = "201b9f6d6b46e0ae311e8a8b2cbe2ad6652f5680";
          sha256 = "JHx/1foo1CEuMO0T4+gmSD6OO02Q5A1tBDPy2MULd5A=";
      
        };
        #patches = nixpkgs.lib.lists.remove (nixpkgs.lib.lists.last finalAttrs.patches) finalAttrs.patches;
        buildPhase = ''
          export PATH="$PATH:${pkgs.git}/bin"
          echo "201b9f6d6b46e0ae311e8a8b2cbe2ad6652f5680" > VERSION
          '' + finalAttrs.buildPhase;
      });
    }
    );
  
}
