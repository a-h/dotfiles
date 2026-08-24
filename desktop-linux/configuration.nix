{ pkgs, neovim, ... }:

{
  imports = [
    ../common/registry.nix
    ./hardware/hardware.nix
    ./hardware/disko.nix
    ./locale.nix
    ./network.nix
    ./desktop.nix
    ./firefox.nix
    ./ghostty.nix
    ./steam.nix
    ./development.nix
    ./shell.nix
    ./users.nix
  ];

  boot.loader.systemd-boot = {
    enable = true;
    # The firmware's default GOP mode is 1024x768, which the monitor stretches
    # to 4K. The kernel inherits that mode for simpledrm, so it is also what
    # Plymouth draws on before nvidia-drm loads. "max" selects the highest mode
    # the firmware offers, which makes the DeviceScale=2 set in
    # hardware/hardware.nix the right value rather than a doubling of an
    # already-upscaled surface.
    consoleMode = "max";
  };
  boot.loader.efi.canTouchEfiVariables = true;

  # At the native mode the generation menu is legible but small. It is not
  # needed on a normal boot; hold space during startup to get it back.
  boot.loader.timeout = 0;

  security.sudo.wheelNeedsPassword = false;

  # nixpkgs.config is deliberately unset: the pkgs instance is created in the
  # flake, where allowUnfree is configured.
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
