{ config, pkgs, ... }:

with import <nixpkgs> { };
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
  upterm = pkgs.callPackage ./upterm.nix { };

  nodePackages = import ./node-env/default.nix {
    inherit pkgs;
  };

  nerdfonts = (pkgs.nerdfonts.override { fonts = [ "IBMPlexMono" ]; });

in

{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "adrian-hesketh";
  home.homeDirectory = "/home/adrian-hesketh";
  home.enableNixpkgsReleaseCheck = true;

  # Don't show home-manager news
  news.display = "silent";

  # Packages for this user.
  home.packages = [
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
      #BROKE pkgs.openjdk17 # Development.
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
      pkgs.rust-analyzer # Rust language server.
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

    programs.gpg = {
      enable = true;
  };
  services.gpg-agent = {
    enable = true;
    enableScDaemon = true;
  };

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "22.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
