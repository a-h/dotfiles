{ pkgs, neovim, ... }:

let
  common-packages = pkgs.callPackage ../common/packages.nix { inherit pkgs neovim; };
in
{
  manual.manpages.enable = false;

  news = {
    display = "silent";
    entries = pkgs.lib.mkForce [ ];
  };

  home.packages = common-packages ++ [
    pkgs.wl-clipboard
  ];

  programs.gpg.enable = true;

  services.gnome-keyring.enable = false;
  services.gpg-agent = {
    enable = true;
    enableScDaemon = true;
    enableSshSupport = true;
    sshKeys = [ "FFC73CEA6D1594D7F473F1FB0ED190BDE0909FE2" ];
    pinentry.package = pkgs.pinentry-gnome3;
  };

  fonts.fontconfig.enable = true;

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    initContent = (builtins.readFile ../common/.zshrc);
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  home.stateVersion = "25.05";

  programs.home-manager.enable = true;
}
