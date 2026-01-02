{
  description = "Cooper's reproducible development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, nix-darwin, ... }:
    let
      lib = nixpkgs.lib;
    in
    {
      # =======================================================================
      # Linux Thin Client
      # =======================================================================
      # Usage: nix run home-manager -- switch --flake .#cooper@linux
      homeConfigurations = {
        "cooper@linux" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          modules = [
            ./home/core.nix
            {
              home.homeDirectory = "/home/cooper";
            }
          ];
        };
      };

      # =======================================================================
      # macOS Workstation
      # =======================================================================
      # Usage: darwin-rebuild switch --flake .#coopers-macbook-pro
      darwinConfigurations = {
        "coopers-macbook-pro" = nix-darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          modules = [
            ./darwin/system.nix
            home-manager.darwinModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.cooper = { pkgs, lib, ... }: {
                imports = [ 
                  ./home/core.nix 
                  ./home/workstation.nix 
                ];
                home.homeDirectory = "/Users/cooper";
                
                # 1Password SSH agent (macOS)
                programs.zsh.initExtra = lib.mkAfter ''
                  if [[ -S "$HOME/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock" ]]; then
                    export SSH_AUTH_SOCK="$HOME/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
                  fi
                '';
              };
            }
          ];
        };
      };

      # =======================================================================
      # Development Shell
      # =======================================================================
      # Usage: nix develop
      devShells = {
        x86_64-linux.default = nixpkgs.legacyPackages.x86_64-linux.mkShell {
          buildInputs = with nixpkgs.legacyPackages.x86_64-linux; [
            git curl wget htop jq ripgrep fd
          ];
        };
        aarch64-darwin.default = nixpkgs.legacyPackages.aarch64-darwin.mkShell {
          buildInputs = with nixpkgs.legacyPackages.aarch64-darwin; [
            git curl wget htop jq ripgrep fd
          ];
        };
      };
    };
}
