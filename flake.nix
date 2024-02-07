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
      packages.go_1_22 = pkgs.go_1_22.overrideAttrs (finalAttrs: rec {
        version = "1.22.0";
        src = builtins.fetchurl {
          url = "https://go.dev/dl/go${version}.src.tar.gz";
          sha256 ="0p2d3x7268ryrrh70yyqdd1hr2v03z6f612dqvgw3mm084ynq6ad";
        };
        #patches = nixpkgs.lib.lists.remove (nixpkgs.lib.lists.last finalAttrs.patches) finalAttrs.patches;
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
