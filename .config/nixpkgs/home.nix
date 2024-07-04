{ pkgs, ... }:

let
  neovim = pkgs.callPackage ./nvim.nix { };
  adr-tools = pkgs.callPackage ./adr-tools.nix { };
  goreplace = pkgs.callPackage ./goreplace.nix { };
  # html2text = pkgs.callPackage ./html2text.nix { };
  twet = pkgs.callPackage ./twet.nix { };
  jdtls = pkgs.callPackage ./jdtls.nix { };
  go = pkgs.callPackage ./go.nix { };
  upterm = pkgs.callPackage ./upterm.nix { };

  nerdfonts = (pkgs.nerdfonts.override { fonts = [ "IBMPlexMono" ]; });

in

{
  manual.manpages.enable = false;

  # Don't show home-manager news
  news = {
    display = "silent";
    #json = pkgs.lib.mkForce { output = null; };
    entries = pkgs.lib.mkForce [ ];
  };

  # Packages for this user.
  home.packages = [
    adr-tools
    pkgs.air # Hot reload for Go.
    pkgs.d2 # Diagramming
    goreplace
    neovim
    nerdfonts
    upterm
    twet
    pkgs.xc # Task executor.
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
    pkgs.direnv # Support loading environment files, and the use of https://marketplace.visualstudio.com/items?itemName=mkhl.direnv
    pkgs.docker
    pkgs.dynamotableviz
    # pkgs.dotnet-sdk # No Darwin ARM support.
    pkgs.entr # Execute command when files change.
    pkgs.fd # Find that respects .gitignore.
    pkgs.fzf # Fuzzy search.
    # pkgs.gcalcli # Google Calendar CLI.
    pkgs.gcc
    # pkgs.gcc-arm-embedded # Raspberry Pi Pico GCC. # No Darwin ARM support.
    pkgs.gifsicle
    pkgs.git
    pkgs.git-lfs
    pkgs.gitAndTools.gh
    pkgs.gnomeExtensions.appindicator
    pkgs.gnomeExtensions.hide-top-bar
    pkgs.gnupg
    go
    pkgs.go-swagger
    pkgs.gomuks
    pkgs.gotools
    # pkgs.google-cloud-sdk # No Darwin ARM support.
    pkgs.gopls
    pkgs.graphviz
    pkgs.html2text
    pkgs.htop
    pkgs.hugo
    pkgs.ibm-plex
    pkgs.imagemagick
    pkgs.jq
    pkgs.libvirt
    pkgs.virt-manager
    pkgs.lua5_4
    pkgs.lua-language-server
    pkgs.llvm # Used by Raspberry Pi Pico SDK.
    pkgs.lynx
    pkgs.mob
    pkgs.minicom # Serial monitor.
    pkgs.mutt
    pkgs.nil # Nix Language Server.
    pkgs.ninja # Used by Raspberry Pi Pico SDK, build tool.
    pkgs.nixpkgs-fmt
    pkgs.nix-prefetch-git
    pkgs.nmap
    pkgs.nodePackages.node2nix
    pkgs.nodePackages.prettier
    #pkgs.nodePackages.typescript
    #pkgs.nodePackages.typescript-language-server
    pkgs.nodejs-18_x
    pkgs.pass
    pkgs.powerline
    pkgs.python310Packages.python-lsp-server
    pkgs.podman
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
    pkgs.yaml-language-server
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
    gtk3.extraConfig = { "gtk-application-prefer-dark-theme" = "true"; };
    gtk4.extraConfig = { "gtk-application-prefer-dark-theme" = "true"; };
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
        default-visible-columns = [ "name" "size" "date_modified" ];
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
    historyWidgetOptions = # CTRL-R
      [ ''--preview 'echo {} | sed \"s/  */ /g\" | cut -d\\  -f1 | xargs -I % sh -c \"echo %; git show --color=always %\"' '' ];
  };

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "23.11";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
