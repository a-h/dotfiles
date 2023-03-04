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
    darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, darwin, home-manager, xc, ... }:
    let
      pkgs = import nixpkgs {
        overlays = [
          (self: super: {
            xc = xc.packages.aarch64-darwin.xc;
          })
        ];
      };
    in rec {
      homeConfigurations = {
        adrian-linux = home-manager.lib.homeManagerConfiguration {
          system = "x86_64-linux";
          inherit pkgs;
          modules = [ ./.config/nixpkgs/home.nix ];
        };
      };
      darwinConfigurations = {
        adrian-mac = darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          specialArgs = {inherit inputs;};
          inherit pkgs;
          modules = [ ./.config/nixpkgs/darwin-configuration.nix ];
        };
      };
    };
}
