{ pkgs, neovim, ... }:

let
  common-packages = pkgs.callPackage ../common/packages.nix { inherit pkgs neovim; };
in

{
  imports = [ ../common/registry.nix ];

  environment.variables = { EDITOR = "nvim"; };

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = common-packages ++ [
    pkgs.alt-tab-macos
  ];

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableSyntaxHighlighting = true;
    promptInit = (builtins.readFile ../common/.zshrc);
  };

  fonts = {
    packages = [ pkgs.nerd-fonts.blex-mono ];
  };

  nix.settings = {
    auto-optimise-store = false;
    experimental-features = "nix-command flakes";
    trusted-users = [ "adrian-hesketh" "adrian" ];
  };

  nix.enable = false;
  nix.channel.enable = false;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
  documentation.enable = false;
}

