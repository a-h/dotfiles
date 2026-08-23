{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    xc = {
      url = "github:joerdav/xc/5dc73db31b9f29e69e40705a2c5a13797a15cfa6";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    darwin = {
      url = "github:lnl7/nix-darwin/nix-darwin-26.05";
    };
    flakegap = {
      url = "github:a-h/flakegap/v0.0.84";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    tuicr = {
      url = "github:agavra/tuicr/48e4b123fd7e59f4da094a317d1d9187110df2f7";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, nixpkgs-unstable, darwin, home-manager, xc, flakegap, tuicr, disko, ... } @inputs:
    let
      # Build a nixpkgs instance for a system. extraConfig is merged into the
      # nixpkgs config, so machines that need it (e.g. the desktop for CUDA and
      # ROCm) can opt in without affecting the others. allowUnfree is set here
      # so unfree packages are permitted at the nixpkgs level everywhere,
      # rather than with per-package predicates.
      getPkgsForSystem = system: extraConfig:
        let
          pkgs-unstable = import nixpkgs-unstable {
            system = system;
            config = { allowUnfree = true; } // extraConfig;
          };
        in
        import nixpkgs {
          system = system;
          overlays = [
            (final: prev: {
              xc = xc.packages.${system}.xc.overrideAttrs (old: {
                src = xc;
              });
              flakegap = flakegap.packages.${system}.default;
              tuicr = tuicr.packages.${system}.default;
              crush = pkgs-unstable.crush.overrideAttrs (old: {
                doCheck = false;
              });
              claude-code = pkgs-unstable.claude-code;
              go = pkgs-unstable.go;
            })
          ];
          config = {
            allowUnfree = true;
          } // extraConfig;
        };

      # Built with the default config: the editor needs no GPU support.
      neovimFor = system: (getPkgsForSystem system { }).callPackage ./neovim { };
    in
    {
      # Expose the self-contained neovim as a flake output so it can be run or
      # installed anywhere: nix run .#neovim, or added to any other flake.
      packages = nixpkgs.lib.genAttrs [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin" ] (system: {
        neovim = neovimFor system;
        default = neovimFor system;
      });

      homeConfigurations = {
        # The work Linux machine.
        adrian-linux = home-manager.lib.homeManagerConfiguration {
          pkgs = getPkgsForSystem "x86_64-linux" { };
          extraSpecialArgs = {
            inputs = inputs;
            neovim = neovimFor "x86_64-linux";
          };
          modules = [
            ./work-linux/home.nix
            {
              home = {
                username = "adrian-hesketh";
                homeDirectory = "/home/adrian-hesketh";
                stateVersion = "23.11";
              };
            }
          ];
        };
      };

      darwinConfigurations = {
        adrian-mac = darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          pkgs = getPkgsForSystem "aarch64-darwin" { };
          modules = [ ./mac/configuration.nix ];
          specialArgs = {
            inputs = inputs;
            neovim = neovimFor "aarch64-darwin";
          };
        };
      };

      nixosConfigurations = {
        # CUDA and ROCm are enabled so GPU compute and ML packages are built
        # with hardware acceleration.
        desktop-linux =
          let
            desktopPkgs = getPkgsForSystem "x86_64-linux" {
              cudaSupport = true;
              rocmSupport = true;
            };
          in
          nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            specialArgs = {
              inputs = inputs;
              neovim = neovimFor "x86_64-linux";
            };
            modules = [
              disko.nixosModules.disko
              ./desktop-linux/configuration.nix
              home-manager.nixosModules.home-manager
              {
                nixpkgs.pkgs = desktopPkgs;
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.extraSpecialArgs = {
                  inputs = inputs;
                  neovim = neovimFor "x86_64-linux";
                };
                home-manager.users.adrian = import ./desktop-linux/home.nix;
              }
            ];
          };
      };
    };
}
