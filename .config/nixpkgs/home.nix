{ pkgs, ... }:

let
  cross-platform-packages = pkgs.callPackage ./cross-platform-packages.nix { inherit pkgs; };
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
  home.packages = cross-platform-packages ++ [
    pkgs.adwaita-qt # QT theme to bend Qt applications to look like they belong into GNOME Shell
    pkgs.docker
    pkgs.gnomeExtensions.appindicator
    pkgs.gnomeExtensions.hide-top-bar
    pkgs.libvirt
    pkgs.virt-manager
    pkgs.wl-clipboard # wayland clipboard
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
    enableSshSupport = true;
    sshKeys = [ "FFC73CEA6D1594D7F473F1FB0ED190BDE0909FE2" ];
    pinentry.package = pkgs.pinentry-tty;
  };

  fonts.fontconfig.enable = true;

  qt = {
    enable = true;
    style = {
      name = "adwaita-dark";
    };
    platformTheme.name = "gtk";
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
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    initContent = (builtins.readFile ./.zshrc);
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
