# See https://nixos.org/guides/towards-reproducibility-pinning-nixpkgs.html and https://status.nixos.org
# https://github.com/NixOS/nixpkgs/releases/tag/22.11
{ config, pkgs ? import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/4d2b37a84fad1091b9de401eb450aae66f1a741e.tar.gz") { }, ... }:

let
  neovim = pkgs.callPackage ./nvim.nix { };

  adr-tools = pkgs.callPackage ./adr-tools.nix { };
  goreplace = pkgs.callPackage ./goreplace.nix { };
  html2text = pkgs.callPackage ./html2text.nix { };
  air = pkgs.callPackage ./air.nix { };
  twet = pkgs.callPackage ./twet.nix { };
  pact = pkgs.callPackage ./pact.nix { };
  jdtls = pkgs.callPackage ./jdtls.nix { };
  xc = pkgs.callPackage ./xc.nix { };
  go = pkgs.callPackage ./go.nix { };
  gopls = pkgs.callPackage ./gopls.nix { };
  upterm = pkgs.callPackage ./upterm.nix {
    go = go;
  };

  nodePackages = import ./node-env/default.nix {
    inherit pkgs;
  };

  nerdfonts = (pkgs.nerdfonts.override { fonts = [ "IBMPlexMono" ]; });

in

{
  nixpkgs.config.allowUnfree = true;
  environment.variables = { EDITOR = "vim"; };

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages =
    [
      adr-tools
      air # Hot reload for Go.
      goreplace
      neovim
      nerdfonts
      pact
      upterm
      twet
      xc # Task executor.
      # Java development.
      pkgs.jdk # Development.
      pkgs.openjdk17 # Development.
      pkgs.jre # Runtime.
      pkgs.gradle # Build tool.
      jdtls # Language server.
      pkgs.maven
      # Other.
      pkgs.aerc
      pkgs.aha # Converts shell output to HTML.
      pkgs.expect # Provides the unbuffer command used to force programs to pipe color: `unbuffer fd | aha -b -n` (https://joshbode.github.io/remark/ansi.html#5)
      pkgs.bat
      pkgs.silver-searcher
      pkgs.asciinema
      pkgs.astyle # Code formatter for C.
      pkgs.aws-vault
      pkgs.awscli2
      pkgs.awslogs
      pkgs.ccls # C LSP Server.
      pkgs.cmake # Used by Raspberry Pi Pico SDK.
      pkgs.cargo # Rust tooling.
      pkgs.delve # Go debugger.
      # pkgs.dotnet-sdk # No Darwin ARM support.
      pkgs.entr # Execute command when files change.
      pkgs.fd # Find that respects .gitignore.
      pkgs.fzf # Fuzzy search.
      # pkgs.gcalcli # Google Calendar CLI.
      # pkgs.gcc-arm-embedded # Raspberry Pi Pico GCC. # No Darwin ARM support.
      pkgs.gifsicle
      pkgs.git
      pkgs.gitAndTools.gh
      pkgs.gnupg
      go
      pkgs.go-swagger
      pkgs.gomuks
      pkgs.gotools
      # pkgs.google-cloud-sdk # No Darwin ARM support.
      #gopls
      pkgs.goreleaser
      pkgs.graphviz
      pkgs.html2text
      pkgs.htop
      pkgs.hugo
      pkgs.ibm-plex
      pkgs.imagemagick
      pkgs.jq
      pkgs.lua5_4
      pkgs.sumneko-lua-language-server
      pkgs.lima # Alternative to Docker desktop https://github.com/lima-vm/lima
      pkgs.llvm # Used by Raspberry Pi Pico SDK.
      pkgs.lynx
      pkgs.mob
      pkgs.minicom # Serial monitor.
      pkgs.mutt
      pkgs.ninja # Used by Raspberry Pi Pico SDK, build tool.
      pkgs.nixpkgs-fmt
      pkgs.nix-prefetch-git
      pkgs.nmap
      pkgs.nodePackages.node2nix
      pkgs.nodePackages.prettier
      pkgs.nodePackages.typescript
      pkgs.nodePackages.typescript-language-server
      pkgs.nodejs-16_x
      pkgs.pass
      pkgs.ripgrep
      pkgs.rustc # Rust compiler.
      pkgs.rustfmt # Rust formatter.
      pkgs.rls # Rust language server.
      # pkgs.ssm-session-manager-plugin # No Darwin ARM support. 
      pkgs.slides
      pkgs.terraform
      pkgs.tmate
      pkgs.tmux
      pkgs.tree
      pkgs.unzip
      pkgs.urlscan
      pkgs.wget
      pkgs.yarn
      pkgs.zip
    ];

  programs.zsh.enable = true; # default shell on catalina

  fonts = {
     enableFontDir = true;
     fonts = [ nerdfonts ];
  };

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
  services.nix-daemon.enable = true;
}

