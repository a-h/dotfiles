# Cross-platform development packages shared by the macOS and Linux
# configurations. The self-contained neovim package is injected by the caller
# so that every machine uses the same editor from the flake output. Language
# servers and formatters live in the neovim package, not here, since they have
# no use outside the editor.
{ pkgs, neovim, ... }:
let
  goreplace = pkgs.callPackage ./pkgs/goreplace.nix { };
in
[
  pkgs.adr-tools
  pkgs.air # Hot reload for Go.
  pkgs.claude-code
  pkgs.docker # Colima needs the Docker CLI, but not the daemon.
  pkgs.colima # Docker / k8s on macOS (and Linux!).
  pkgs.crush
  pkgs.docker-credential-helpers
  pkgs.d2 # Diagramming
  goreplace
  neovim
  pkgs.nerd-fonts.blex-mono
  pkgs.nerd-fonts.fira-code
  pkgs.nerd-fonts.hack
  pkgs.nerd-fonts.inconsolata
  pkgs.nerd-fonts.jetbrains-mono
  pkgs.nerd-fonts.roboto-mono
  pkgs.ibm-plex
  pkgs.source-code-pro
  pkgs.xc # Task executor.
  pkgs.aha # Converts shell output to HTML.
  pkgs.expect # Provides the unbuffer command used to force programs to pipe color: `unbuffer fd | aha -b -n` (https://joshbode.github.io/remark/ansi.html#5)
  pkgs.bat
  pkgs.silver-searcher
  pkgs.asciinema
  pkgs.cmake # Used by Raspberry Pi Pico SDK.
  pkgs.cargo # Rust tooling.
  pkgs.delve # Go debugger.
  pkgs.direnv # Support loading environment files, and the use of https://marketplace.visualstudio.com/items?itemName=mkhl.direnv
  pkgs.entr # Execute command when files change.
  pkgs.fd # Find that respects .gitignore.
  pkgs.flakegap # Transfer flakes across airgaps.
  pkgs.fzf # Fuzzy search.
  pkgs.gcc
  pkgs.gemini-cli
  pkgs.gifsicle
  pkgs.git
  pkgs.git-lfs
  pkgs.git-remote-gcrypt # Encrypt git repos, see https://github.com/spwhitton/git-remote-gcrypt
  pkgs.gh
  pkgs.gnupg
  pkgs.go
  pkgs.go-swagger
  pkgs.gotools
  pkgs.goreleaser
  pkgs.graphviz
  pkgs.html2text
  pkgs.htop
  pkgs.imagemagick
  pkgs.jq
  pkgs.lua5_4
  pkgs.llvm # Used by Raspberry Pi Pico SDK.
  pkgs.lynx
  pkgs.mob
  pkgs.minicom # Serial monitor.
  pkgs.nix # Specific version of Nix.
  pkgs.ninja # Used by Raspberry Pi Pico SDK, build tool.
  pkgs.nixpkgs-fmt
  pkgs.nix-prefetch-git
  pkgs.nmap
  pkgs.p7zip
  pkgs.pass
  pkgs.powerline
  pkgs.podman
  pkgs.ripgrep
  pkgs.rustc # Rust compiler.
  pkgs.slides
  pkgs.tflint
  pkgs.tmate
  pkgs.tmux
  pkgs.tree
  pkgs.tuicr
  pkgs.unzip
  pkgs.urlscan
  pkgs.wget
  pkgs.xclip
  pkgs.yarn
  pkgs.zip
]
