{ pkgs, ... }:
let
  neovim = pkgs.callPackage ./nvim.nix { };
  adr-tools = pkgs.callPackage ./adr-tools.nix { };
  goreplace = pkgs.callPackage ./goreplace.nix { };
  jdtls = pkgs.callPackage ./jdtls.nix { };

  nerdfonts = (pkgs.nerdfonts.override { fonts = [ "IBMPlexMono" ]; });
in
[
  adr-tools
  pkgs.air # Hot reload for Go.
  pkgs.d2 # Diagramming
  goreplace
  neovim
  nerdfonts
  pkgs.xc # Task executor.
  # Java development.
  pkgs.jdk # Development.
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
  pkgs.direnv # Support loading environment files, and the use of https://marketplace.visualstudio.com/items?itemName=mkhl.direnv
  pkgs.dynamotableviz
  pkgs.entr # Execute command when files change.
  pkgs.fd # Find that respects .gitignore.
  pkgs.flakegap # Transfer flakes across airgaps.
  pkgs.fzf # Fuzzy search.
  pkgs.gcc
  # pkgs.gcc-arm-embedded # Raspberry Pi Pico GCC. # No Darwin ARM support.
  pkgs.gifsicle
  pkgs.git
  pkgs.git-lfs
  pkgs.gh
  pkgs.gnupg
  pkgs.go
  pkgs.go-swagger
  pkgs.gotools
  pkgs.goreleaser
  pkgs.graphviz
  pkgs.html2text
  pkgs.htop
  pkgs.ibm-plex
  pkgs.imagemagick
  pkgs.jq
  pkgs.lua5_4
  pkgs.lua-language-server
  pkgs.llvm # Used by Raspberry Pi Pico SDK.
  pkgs.lynx
  pkgs.mob
  pkgs.minicom # Serial monitor.
  pkgs.nil # Nix Language Server.
  pkgs.nix # Specific version of Nix.
  pkgs.ninja # Used by Raspberry Pi Pico SDK, build tool.
  pkgs.nixpkgs-fmt
  pkgs.nix-prefetch-git
  pkgs.nmap
  pkgs.nodePackages.prettier
  pkgs.nodePackages.typescript
  pkgs.nodePackages.typescript-language-server
  pkgs.nodejs
  pkgs.p7zip
  pkgs.pass
  pkgs.powerline
  pkgs.podman
  pkgs.ripgrep
  pkgs.source-code-pro
  pkgs.rustc # Rust compiler.
  pkgs.rustfmt # Rust formatter.
  pkgs.rust-analyzer # Rust language server.
  pkgs.slides
  pkgs.superhtml # HTML LSP.
  pkgs.terraform-ls
  pkgs.tflint
  pkgs.tmate
  pkgs.tmux
  pkgs.tree
  pkgs.unzip
  pkgs.urlscan
  pkgs.vscode-langservers-extracted
  pkgs.wget
  pkgs.xclip
  pkgs.yaml-language-server
  pkgs.yarn
  pkgs.zip
]
