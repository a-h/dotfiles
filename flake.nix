{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dynamotableviz = {
      url = "github:a-h/dynamotableviz/v0.0.15";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    xc = {
      url = "github:joerdav/xc/de0bb12a9ead25c76398e5d468aecc0510bb18b9";
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
      url = "github:agavra/tuicr";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, nixpkgs-unstable, darwin, home-manager, dynamotableviz, xc, flakegap, tuicr, ... } @inputs:
    let
      getPkgsForSystem = system:
        let
          pkgs-unstable = import nixpkgs-unstable {
            system = system;
            config = { allowUnfree = true; };
          };
        in
        import nixpkgs {
          overlays = [
            (final: prev: {
              dynamotableviz = dynamotableviz.packages.${system}.dynamotableviz;
              xc = xc.packages.${system}.xc.overrideAttrs (old: {
                src = xc;
              });
              #go = prev.callPackage .config/nixpkgs/go.nix { };
              flakegap = flakegap.packages.${system}.default;
              tuicr = tuicr.packages.${system}.default;
              #gemini-cli = pkgs-unstable.gemini-cli;
              crush = pkgs-unstable.crush.overrideAttrs (old: {
                doCheck = false;
              });
              claude-code = pkgs-unstable.claude-code;
            })
          ];
          config = {
            allowUnfree = true;
          };
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
