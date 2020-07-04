{ config, pkgs, ... }:

{
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages =
    [ 
	pkgs.awscli
	pkgs.docker
	pkgs.fzf
	pkgs.git
	pkgs.gitAndTools.gh
	pkgs.gnupg
	pkgs.go
	pkgs.gopass
	pkgs.graphviz
	pkgs.htop
	pkgs.hugo
	pkgs.jq
	pkgs.lynx
	pkgs.neovim
	pkgs.nmap
	pkgs.nodejs
	pkgs.ripgrep
	pkgs.terraform
	pkgs.tmux
	pkgs.tree
	pkgs.unzip
	pkgs.wget
	pkgs.yarn
	pkgs.zip
    ];

  # Use a custom configuration.nix location.
  # $ darwin-rebuild switch -I darwin-config=$HOME/.config/nixpkgs/darwin/configuration.nix
  # environment.darwinConfig = "$HOME/.config/nixpkgs/darwin/configuration.nix";

  # Auto upgrade nix package and the daemon service.
  # services.nix-daemon.enable = true;
  # nix.package = pkgs.nix;

  # Create /etc/bashrc that loads the nix-darwin environment.
  programs.zsh.enable = true;  # default shell on catalina
  # programs.fish.enable = true;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}
