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
      packages.yaegi = pkgs.callPackage ./yaegi.nix {}; 
      packages.go_1_21 = pkgs.go.overrideAttrs (finalAttrs: rec {
        version = "1.21rc2";
        src = builtins.fetchurl {
          url = "https://go.dev/dl/go${version}.src.tar.gz";
          sha256 ="0vh72fv443bb7hdmrnbpwxrqbpcvyclrid6jwrxjs7yr4b76snci";
        };
        patches = nixpkgs.lib.lists.remove (nixpkgs.lib.lists.last finalAttrs.patches) finalAttrs.patches;
      });

#     packages.traefikImage = pkgs.dockerTools.buildImage {
#       name = "traefik";
#       tag = "nix";
#       copyToRoot=[ pkgs.traefik ];
#       config = {
#         Cmd = [ "${pkgs.traefik}/bin/traefik" ];
#       };

#     };
    }
    );
    
  
}
