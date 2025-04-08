{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
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
      url = "github:a-h/flakegap/v0.0.75";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, nixpkgs-unstable, darwin, home-manager, dynamotableviz, xc, goreleaser, nil, flakegap, ... } @inputs:
    let
      getPkgsForSystem = system:
        let
          pkgs-unstable = import nixpkgs-unstable { system = system; };
        in
        import nixpkgs {
          overlays = [
            (final: prev: {
              dynamotableviz = dynamotableviz.packages.${system}.dynamotableviz;
              xc = xc.packages.${system}.xc;
              go = prev.callPackage .config/nixpkgs/go.nix { };
              goreleaser = goreleaser.packages.${system}.goreleaser;
              nil = nil.packages.${system}.nil;
              flakegap = flakegap.packages.${system}.default;
              neovim-unwrapped = prev.neovim-unwrapped.overrideAttrs (old: {
                src = prev.fetchFromGitHub {
                  owner = "neovim";
                  repo = "neovim";
                  rev = "e96f75a4e60c9082e89c7f61e2ce0647e4ebdf43";
                  hash = "sha256-TAuoa5GD50XB4OCHkSwP1oXfedzVrCBRutNxBp/zGLY=";
                };
              });
              tailwindcss-language-server = pkgs-unstable.tailwindcss-language-server;
            })
          ];
        };
    in
    {
      homeConfigurations = {
        adrian-linux = home-manager.lib.homeManagerConfiguration {
          pkgs = getPkgsForSystem "x86_64-linux";
          extraSpecialArgs = {
            inputs = inputs;
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
            inputs = inputs;
          };
        };
      };
    };
}
