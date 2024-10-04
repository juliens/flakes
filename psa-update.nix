
{ lib, fetchFromGitHub, pkgs, rustPlatform, installShellFiles }:

rustPlatform.buildRustPackage
      rec {
        pname = "psa-update";
        version = "684d04c8f1463560a291fb6521070ce5c38c1138";

        src = fetchFromGitHub {
          owner = "zeld";
          repo = pname;
          rev = "1.0.6";
          sha256 = "kBShby0y1h2HPKSxnR4wwsKV0TbJhMFKtR4/IMnuDOM=";
        };
        nativeBuildInputs = [  ];
        buildInputs = [ pkgs.darwin.IOKit pkgs.darwin.apple_sdk.frameworks.SystemConfiguration ];

        cargoHash = "sha256-CGDhEmHmz4Cb0o010nxbaRltDi51xGamEJTlIGu/r5k=";
      }
