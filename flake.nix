{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/23.05";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dynamotableviz = {
      url = "github:a-h/dynamotableviz";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    xc = {
      url = "github:joerdav/xc";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    goreleaser = {
      url = "github:a-h/nix-goreleaser";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nil = {
      url = "github:oxalica/nil";
    };
  };

  outputs = inputs@{ self, nixpkgs, darwin, home-manager, dynamotableviz, xc, goreleaser, nil, ... }:
    let
      getPkgsForSystem = system:
        import nixpkgs {
          overlays = [
            (self: super: {
              dynamotableviz = dynamotableviz.packages.${system}.dynamotableviz;
              xc = xc.packages.${system}.xc;
              goreleaser = goreleaser.packages.${system}.goreleaser;
              nil = nil.packages.${system}.nil;
            })
          ];
        };
    in {
      homeConfigurations = {
        adrian-linux = home-manager.lib.homeManagerConfiguration {
          pkgs = getPkgsForSystem "x86_64-linux";
          modules = [
            ./.config/nixpkgs/home.nix
            {
              home = {
                username = "adrian-hesketh";
                homeDirectory = "/home/adrian-hesketh";
                stateVersion = "22.05";
              };
            }
          ];
        };
      };
      darwinConfigurations = 
        let
          pkgs = getPkgsForSystem "aarch64-darwin";
        in {
          adrian-mac = darwin.lib.darwinSystem {
            system = "aarch64-darwin";
            pkgs = getPkgsForSystem "aarch64-darwin";
            modules = [ ./.config/nixpkgs/darwin-configuration.nix ];
          };
       };
    };
}
