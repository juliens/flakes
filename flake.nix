{
  description = "A very basic flake";


  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }: let
  in 
  flake-utils.lib.eachDefaultSystem (system:
  let
    pkgs = nixpkgs.legacyPackages.${system}; 
    python = pkgs.python3;
    pythonPackages = python.pkgs;

    mcp-client-cli = pythonPackages.buildPythonApplication {
      pname = "mcp-client-cli";
      version = "0.1.0";  # Ajustez la version selon celle que vous utilisez

      src = pkgs.fetchPypi {
        pname="mcp-client-cli";
        version="0.1.0";
        sha256 = ""; # Vous devrez remplir ce hash après la première tentative de build
      };

      propagatedBuildInputs = with pythonPackages; [
      ];

      doCheck = false;  # Désactiver les tests pour simplifier
    };
  in
  {
    packages.prm-bin = import ./prm-bin.nix { inherit pkgs; };
    packages.prm = pkgs.callPackage ./prm.nix {}; 
    packages.Mole = pkgs.callPackage ./mole.nix {}; 
    packages.golangci-lint = pkgs.callPackage ./golangci-lint.nix {}; 
    packages.gcg = pkgs.callPackage ./gcg.nix {}; 
    packages.tparse = pkgs.callPackage ./tparse.nix {}; 
    packages.mocktail = pkgs.callPackage ./mocktail.nix {}; 
    packages.yaegi = pkgs.callPackage ./yaegi.nix {}; 
    packages.psa-update = pkgs.callPackage ./psa-update.nix {}; 
    packages.mcp-client-cli = mcp-client-cli;
    packages.aerospace = pkgs.callPackage ./aerospace/package.nix {};
    packages.audiveris = pkgs.callPackage ./audiveris.nix {};

    packages.go_commit = pkgs.go_1_23.overrideAttrs (finalAttrs: rec {
      GOROOT_BOOTSTRAP="${pkgs.go_1_23}/share/go";
      version = "368a9ec99834652ca3f7d8fe24862a7581e12358";
      buildInputs = [ pkgs.git ] ++ finalAttrs.buildInputs;
      src = pkgs.fetchFromGitHub {
        owner = "golang";
        repo = "go";
        rev = version;
        name = "go-${version}";
        hash = "sha256-B1aGebi0JhR9iXUWhgj+IVHwPDHRHkTfNweAP37mhu4";

      };
        #patches = nixpkgs.lib.lists.remove (nixpkgs.lib.lists.last finalAttrs.patches) finalAttrs.patches;
        buildPhase = ''
          export PATH="$PATH:${pkgs.git}/bin"
          echo "dev-${version}" > VERSION
        '' + finalAttrs.buildPhase;
      });

      devShells.kube = pkgs.mkShell {

        shellHook = ''
	export TERM=xterm-256color
        export ZSH="$HOME/.oh-my-zsh"
        export ZSH_CUSTOM="$ZSH/custom"
        export PLUGIN_DIR="$ZSH_CUSTOM/plugins"

        if [ ! -d "$ZSH" ]; then
          echo "[*] Installing Oh My Zsh..."
          sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
          rm "$HOME/.zshrc"
        fi

        if [ ! -d "$PLUGIN_DIR/zsh-autosuggestions" ]; then
          echo "[*] Installing zsh-autosuggestions..."
          git clone https://github.com/zsh-users/zsh-autosuggestions "$PLUGIN_DIR/zsh-autosuggestions"
        fi

        if [ ! -f "$HOME/.zshrc" ]; then
          echo "[*] Creating .zshrc..."
          cat > "$HOME/.zshrc" <<EOF
export ZSH="\$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
plugins=(git zsh-autosuggestions)

source \$ZSH/oh-my-zsh.sh

# Autosuggestion style
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'

export GPU_1=\$(nvidia-smi -L | grep "Device  0" | grep -oE 'UUID: [^)]+' | cut -d' ' -f2)
export GPU_2=\$(nvidia-smi -L | grep "Device  1" | grep -oE 'UUID: [^)]+' | cut -d' ' -f2)

EOF
        fi

        echo "[*] Dev shell ready. Starting zsh..."
        exec zsh
        '';
        packages = [
          pkgs.kubernetes-helm
          pkgs.kubectl
          pkgs.k9s
          pkgs.k3d
          pkgs.zsh
          pkgs.zsh-autosuggestions
          pkgs.oh-my-zsh
          pkgs.docker-compose
        ];
      };
    });
  }
