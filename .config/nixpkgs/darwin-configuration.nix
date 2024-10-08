# See https://nixos.org/guides/towards-reproducibility-pinning-nixpkgs.html and https://status.nixos.org
# https://github.com/NixOS/nixpkgs/releases/tag/22.11
{ pkgs, ... }:

let
  neovim = pkgs.callPackage ./nvim.nix { };
  adr-tools = pkgs.callPackage ./adr-tools.nix { };
  #d2 = pkgs.callPackage ./d2.nix { };
  goreplace = pkgs.callPackage ./goreplace.nix { };
  #html2text = pkgs.callPackage ./html2text.nix { };
  twet = pkgs.callPackage ./twet.nix { };
  jdtls = pkgs.callPackage ./jdtls.nix { };
  go = pkgs.callPackage ./go.nix { };
  #gopls = pkgs.callPackage ./gopls.nix { };
  #upterm = pkgs.callPackage ./upterm.nix { };

  nerdfonts = (pkgs.nerdfonts.override { fonts = [ "IBMPlexMono" ]; });

in

{
  environment.variables = { EDITOR = "vim"; };

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages =
    [
      adr-tools
      pkgs.alt-tab-macos
      pkgs.air # Hot reload for Go.
      goreplace
      neovim
      nerdfonts
      # upterm
      twet
      pkgs.xc # Task executor (from Flake).
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
      #pkgs.cmake-language-server # Broken on Darwin?
      pkgs.cargo # Rust tooling.
      pkgs.delve # Go debugger.
      pkgs.direnv # Environment variable manager.
      pkgs.dynamotableviz
      # pkgs.dotnet-sdk # No Darwin ARM support.
      pkgs.entr # Execute command when files change.
      pkgs.fd # Find that respects .gitignore.
      pkgs.flakegap # Transfer flakes across airgaps.
      pkgs.fzf # Fuzzy search.
      # pkgs.gcalcli # Google Calendar CLI.
      # pkgs.gcc-arm-embedded # Raspberry Pi Pico GCC. # No Darwin ARM support.
      pkgs.gifsicle
      pkgs.git
      pkgs.git-lfs
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
      pkgs.lua-language-server
      pkgs.lima # Alternative to Docker desktop https://github.com/lima-vm/lima
      pkgs.llvm # Used by Raspberry Pi Pico SDK.
      pkgs.lynx
      pkgs.mob
      pkgs.minicom # Serial monitor.
      pkgs.mutt
      pkgs.nil # Nix language server.
      pkgs.ninja # Used by Raspberry Pi Pico SDK, build tool.
      pkgs.nixpkgs-fmt
      pkgs.nix-prefetch-git
      pkgs.nmap
      pkgs.nodePackages.node2nix
      pkgs.nodePackages.prettier
      pkgs.nodePackages.typescript
      pkgs.nodePackages.typescript-language-server
      pkgs.nodejs
      pkgs.pass
      pkgs.ripgrep
      pkgs.rustc # Rust compiler.
      pkgs.rustfmt # Rust formatter.
      pkgs.rust-analyzer # Rust language server.
      # pkgs.ssm-session-manager-plugin # No Darwin ARM support. 
      pkgs.slides
      pkgs.tmate
      pkgs.tmux
      pkgs.tree
      pkgs.unzip
      pkgs.urlscan
      pkgs.wget
      pkgs.yarn
      pkgs.zip
    ];

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableSyntaxHighlighting = true;
    promptInit = (builtins.readFile ./.zshrc);
  };

  fonts = {
    packages = [ nerdfonts ];
  };

  nix.package = pkgs.nixFlakes;
  nix.extraOptions = ''
    auto-optimise-store = true
    experimental-features = nix-command flakes
  '';

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
  services.nix-daemon.enable = true;
  documentation.enable = false;
}

