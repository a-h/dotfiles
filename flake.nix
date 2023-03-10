{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-22.11";
    home-manager = {
      url = "github:nix-community/home-manager";
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
  };

  outputs = inputs@{ self, nixpkgs, darwin, home-manager, xc, goreleaser, ... }:
    let
      getPkgsForSystem = system:
        import nixpkgs {
          overlays = [
            (self: super: {
              xc = xc.packages.${system}.xc;
              goreleaser = goreleaser.packages.${system}.goreleaser;
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
