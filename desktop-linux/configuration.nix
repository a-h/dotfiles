{ pkgs, neovim, ... }:

{
  imports = [
    ../common/registry.nix
    ./hardware/hardware.nix
    ./hardware/disko.nix
    ./locale.nix
    ./network.nix
    ./desktop.nix
    ./steam.nix
    ./compute.nix
    ./development.nix
    ./shell.nix
    ./users.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  security.sudo.wheelNeedsPassword = false;

  # nixpkgs.config is deliberately unset: the pkgs instance is created in the
  # flake, where allowUnfree, cudaSupport, and rocmSupport are configured.
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
  };

  environment.variables.EDITOR = "nvim";
  environment.systemPackages = [ neovim ];

  fonts.packages = [ pkgs.nerd-fonts.jetbrains-mono ];

  # This value determines the NixOS release from which the default settings for
  # stateful data were taken. Leave it at the release of the first install.
  system.stateVersion = "25.05";
}
