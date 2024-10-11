{
  inputs = {
    nix.url = "github:nixos/nix/2.24.9";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    unstablenixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dynamotableviz = {
      url = "github:a-h/dynamotableviz/v0.0.15";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    xc = {
      url = "github:joerdav/xc/f8e8e658978d6c9fe49c27b684ca7375a74deef1";
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
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flakegap = {
      url = "github:a-h/flakegap";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nix, nixpkgs, unstablenixpkgs, darwin, home-manager, dynamotableviz, xc, goreleaser, nil, flakegap, ... }:
    let
      getPkgsForSystem = system:
        import nixpkgs {
          overlays = [
            (self: super: {
              nix = nix.packages.${system}.nix;
              dynamotableviz = dynamotableviz.packages.${system}.dynamotableviz;
              xc = xc.packages.${system}.xc;
              goreleaser = goreleaser.packages.${system}.goreleaser;
              nil = nil.packages.${system}.nil;
              flakegap = flakegap.packages.${system}.default;
            })
          ];
        };
    in
    {
      homeConfigurations = {
        adrian-linux = home-manager.lib.homeManagerConfiguration {
          pkgs = getPkgsForSystem "x86_64-linux";
          specialArgs = {
            unstablepkgs = import unstablenixpkgs { system = "x86_64-linux"; };
          };
          modules = [
            ./.config/nixpkgs/home.nix
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
          pkgs = getPkgsForSystem "aarch64-darwin";
          modules = [ ./.config/nixpkgs/darwin-configuration.nix ];
          specialArgs = {
            unstablepkgs = import unstablenixpkgs { system = "aarch64-darwin"; };
          };
        };
      };
    };
}
