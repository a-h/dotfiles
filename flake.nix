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
    # naersk is tuicr's Rust builder. It fetched crates from crates.io/api/v1,
    # which now answers 403 to curl's default User-Agent, so building tuicr fails
    # with "cannot download ... from any mirror". Upstream fixed this in
    # nix-community/naersk#391 (merged 2026-06-08) by switching to
    # static.crates.io, but every released tuicr tag - v0.24.0 included - still
    # locks the January 2026 naersk from before the fix, so bumping tuicr does not
    # pick it up and the override has to happen here. Pinned to a revision rather
    # than tracking master, like the other inputs, so naersk cannot break a build
    # unannounced.
    naersk = {
      url = "github:nix-community/naersk/9aa07bb0256d300219b30622d2454e85f7f3667e";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    tuicr = {
      url = "github:agavra/tuicr/v0.22.0";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.naersk.follows = "naersk";
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

              # The 32-bit (i686) libcap build enables its Go bindings, but sets
              # GOARCH from the 64-bit build platform, so the Go compiler fails
              # with "64-bit not compiled in". The 32-bit libcap pulled in by
              # Steam and pipewire (via enable32Bit) only needs the C library, so
              # disable the Go bindings there. See libcap package.nix withGo.
              libcap =
                if prev.stdenv.hostPlatform.system == "i686-linux"
                then prev.libcap.override { withGo = false; }
                else prev.libcap;
            })
          ];
          config = {
            allowUnfree = true;
          } // extraConfig;
        };

      # The latest Go from nixpkgs-unstable, so gopls in the editor can analyse
      # recent Go language features ahead of the stable nixpkgs release.
      unstableGoFor = system: (import nixpkgs-unstable { system = system; }).go;

      # Built with the default config: the editor needs no GPU support. The Go
      # toolchain is overridden to the unstable version for gopls.
      neovimFor = system: (getPkgsForSystem system { }).callPackage ./neovim {
        go = unstableGoFor system;
      };
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
        desktop-linux =
          nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            specialArgs = {
              inputs = inputs;
              neovim = neovimFor "x86_64-linux";
            };
            modules = [
              disko.nixosModules.disko
              ./desktop-linux/configuration.nix
              { nixpkgs.pkgs = getPkgsForSystem "x86_64-linux" { }; }
            ];
          };
      };
    };
}
