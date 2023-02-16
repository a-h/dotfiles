{ config, pkgs, ... }:

with import <nixpkgs> { };
let
  neovim = pkgs.callPackage ./nvim.nix { };
  adr-tools = pkgs.callPackage ./adr-tools.nix { };
  d2 = pkgs.callPackage ./d2.nix { };
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
      d2 # Diagramming
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
      pkgs.adwaita-qt # QT theme to bend Qt applications to look like they belong into GNOME Shell
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
      pkgs.docker
      # pkgs.dotnet-sdk # No Darwin ARM support.
      pkgs.entr # Execute command when files change.
      pkgs.fd # Find that respects .gitignore.
      pkgs.fzf # Fuzzy search.
      # pkgs.gcalcli # Google Calendar CLI.
      pkgs.gcc
      # pkgs.gcc-arm-embedded # Raspberry Pi Pico GCC. # No Darwin ARM support.
      pkgs.gifsicle
      pkgs.git
      pkgs.gitAndTools.gh
      pkgs.gnomeExtensions.appindicator
      pkgs.gnomeExtensions.hide-top-bar
      pkgs.gnupg
      go
      pkgs.go-swagger
      pkgs.gomuks
      pkgs.gotools
      # pkgs.google-cloud-sdk # No Darwin ARM support.
      gopls
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
      #pkgs.nodePackages.typescript
      #pkgs.nodePackages.typescript-language-server
      pkgs.nodejs-16_x
      pkgs.pass
      pkgs.powerline
      pkgs.python310Packages.python-lsp-server
      pkgs.source-code-pro
      pkgs.ripgrep
      pkgs.rustc # Rust compiler.
      pkgs.rustfmt # Rust formatter.
      pkgs.rust-analyzer # Rust language server.
      # pkgs.ssm-session-manager-plugin # No Darwin ARM support. 
      pkgs.slides
      pkgs.terraform
      pkgs.terraform-ls
      pkgs.tflint
      pkgs.tmate
      pkgs.tmux
      pkgs.tree
      pkgs.unzip
      pkgs.urlscan
      pkgs.wl-clipboard # wayland clipboard
      pkgs.wget
      pkgs.xclip
      pkgs.yarn
      pkgs.zip
    ];

  programs.gpg = {
    enable = true;
  };
  services.gnome-keyring = {
    enable = false;
  };
  services.gpg-agent = {
    enable = true;
    enableScDaemon = true;
    pinentryFlavor = "gnome3"; # can be "curses", "tty", "gtk2", "emacs", "gnome3", "qt"
    enableSshSupport = true;
    sshKeys = [ "FFC73CEA6D1594D7F473F1FB0ED190BDE0909FE2" ];
  };

  fonts.fontconfig.enable = true;

  qt = {
    enable = true;
    style = {
      name = "adwaita-dark";
    };
    platformTheme = "gtk";
  };

  gtk = {
    enable = true;
    theme = {
      name = "Adwaita-dark"; # Enable dark mode for GTK2
    };
    gtk2.extraConfig = "gtk-application-prefer-dark-theme = \"true\"";
    gtk3.extraConfig = {"gtk-application-prefer-dark-theme" = "true";};
    gtk4.extraConfig = {"gtk-application-prefer-dark-theme" = "true";};
  };

  dconf = {
    enable = true;
    settings = {
      "org/gnome/desktop/interface" = {
        clock-format = "24h";
        color-scheme = "prefer-dark"; # Enable dark mode on GNOME
      };
      "org/gnome/nautilus/compression" = {
        default-compression-format = "7z";
      };
      "org/gnome/nautilus/icon-view" = {
        default-zoom-level = "medium";
      };
      "org/gnome/nautilus/list-view" = {
        default-zoom-level = "small";
        use-tree-view = true;
        default-column-order = [ "name" "size" "type" "owner" "group" "permissions" "mime_type" "where" "date_modified" "date_modified_with_time" "date_accessed" "date_created" "recency" "starred" ];
        default-visible-columns = ["name" "size" "date_modified"];
      };
      "org/gnome/shell/extensions/dash-to-dock" = {
        dock-fixed = false;
      };
     };
  };

  programs.gnome-terminal = {
    enable = true;
    showMenubar = false;
    profile = {
      "5ddfe964-7ee6-4131-b449-26bdd97518f7" = {
        default = true;
        visibleName = "Home Manager Custom";
        cursorShape = "block";
        font = "BlexMono Nerd Font 11"; # Size: 11
        showScrollbar = false;
        colors = {
          backgroundColor = "#000000";
          foregroundColor = "#ffffff";
          palette = [
            "#000000"
            "#aa0000"
            "#00aa00"
            "#aa5500"
            "#0000aa"
            "#aa00aa"
            "#00aaaa"
            "#aaaaaa"
            "#555555"
            "#ff5555"
            "#55ff55"
            "#ffff55"
            "#5555ff"
            "#ff55ff"
            "#55ffff"
            "#ffffff"
          ];
        };
      };
    };
  };

  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    enableSyntaxHighlighting = true;
    initExtra = (builtins.readFile ./.zshrc);
  };

  programs.fzf = {
   enable = true;
   enableZshIntegration = true;
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
