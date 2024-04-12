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
      packages.mocktail = pkgs.callPackage ./mocktail.nix {}; 
      packages.yaegi = pkgs.callPackage ./yaegi.nix {}; 
    }
    );
    
  
}
