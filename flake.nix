{
  description = "Cooper's reproducible development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    # macOS system configuration
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, nix-darwin, ... }:
    let
      # Supported systems
      systems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
      
      # Common packages for all systems
      commonPackages = pkgs: with pkgs; [
        tmux
        git
        curl
        wget
        htop
        jq
        ripgrep
        fd
        tailscale
      ];
    in
    {
      # Development shell - use with `nix develop`
      devShells = forAllSystems (system:
        let pkgs = nixpkgs.legacyPackages.${system};
        in {
          default = pkgs.mkShell {
            buildInputs = commonPackages pkgs;
            shellHook = ''
              echo "Cooper's dev environment loaded"
              echo "tmux, tailscale, and tools available"
            '';
          };
        }
      );

      # Home Manager configurations
      homeConfigurations = {
        # Linux thin (servers, VMs - minimal bash setup)
        "cooper@linux-thin" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          modules = [ ./home/thin.nix ./home/linux.nix ];
        };
        
        # Linux full (dev workstations - zsh, neovim, etc.)
        "cooper@linux-full" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          modules = [ ./home/full.nix ./home/linux.nix ];
        };
        
        # macOS thin (Apple Silicon - minimal)
        "cooper@darwin-thin" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.aarch64-darwin;
          modules = [ ./home/thin.nix ./home/darwin.nix ];
        };
        
        # macOS full (Apple Silicon - full dev setup)
        "cooper@darwin-full" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.aarch64-darwin;
          modules = [ ./home/full.nix ./home/darwin.nix ];
        };

        # Legacy aliases (backward compatibility)
        "cooper@linux" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          modules = [ ./home/thin.nix ./home/linux.nix ];
        };
        "cooper@darwin" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.aarch64-darwin;
          modules = [ ./home/thin.nix ./home/darwin.nix ];
        };
      };

      # Darwin (macOS) system configuration
      darwinConfigurations = {
        # Full setup for main Mac workstation
        "coopers-macbook-pro" = nix-darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          modules = [
            ./darwin/configuration.nix
            home-manager.darwinModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.cooper = { pkgs, ... }: {
                imports = [ ./home/full.nix ./home/darwin.nix ];
              };
            }
          ];
        };
      };

      # NixOS configuration (for VMs/servers)
      nixosConfigurations = {
        # Thin setup for VMs/servers
        "development-vm" = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./nixos/configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.cooper = { pkgs, ... }: {
                imports = [ ./home/thin.nix ./home/linux.nix ];
              };
            }
          ];
        };
      };
    };
}
