# See https://nixos.org/guides/towards-reproducibility-pinning-nixpkgs.html and https://status.nixos.org
# https://github.com/NixOS/nixpkgs/releases/tag/22.11
{ pkgs, unstablepkgs, ... }:

let
  cross-platform-packages = pkgs.callPackage ./cross-platform-packages.nix { inherit pkgs unstablepkgs; };
  nerdfonts = (pkgs.nerdfonts.override { fonts = [ "IBMPlexMono" ]; });
in

{
  environment.variables = { EDITOR = "vim"; };

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = cross-platform-packages ++ [
    pkgs.alt-tab-macos
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

  nix.package = pkgs.nix;
  nix.distributedBuilds = true;
  nix.extraOptions = ''
    builders-use-substitutes = true
    auto-optimise-store = false
    experimental-features = nix-command flakes
    builders = ssh://adrian@65.109.61.232 x86_64-linux,aarch64-linux - 8 1 kvm -
    trusted-users = adrian-hesketh adrian
  '';

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
  services.nix-daemon.enable = true;
  documentation.enable = false;
}

