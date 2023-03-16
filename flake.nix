{
  description = "A very basic flake";


  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
  };

  outputs = { self, nixpkgs }: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree=true;
    };
  in {
    packages.x86_64-linux.prm-bin = import ./prm-bin.nix { inherit pkgs; };
    packages.x86_64-linux.prm = pkgs.callPackage ./prm.nix {}; 
    packages.x86_64-linux.yaegi = pkgs.callPackage ./yaegi.nix {}; 
    
  };
}
