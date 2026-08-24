{ pkgs, ... }:

{
  services.xserver.enable = true;

  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  services.printing = {
    enable = true;
    # The HP_Deskjet_2540 queue uses an hpcups PPD, and that filter ships in
    # hplip rather than with CUPS itself. Without it CUPS flags the queue with
    # cups-missing-filter-warning and GNOME pops a "Printer report" /
    # "There is a missing print filter" notification at login.
    drivers = [ pkgs.hplip ];
  };

  # PipeWire is the sound server, so PulseAudio is off and pulse.enable below
  # provides the PulseAudio protocol in its place. ALSA remains underneath as
  # the kernel driver layer; alsa.enable is the userspace shim that routes
  # ALSA-API clients into PipeWire rather than letting them take the card.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true; # Lets PipeWire acquire realtime priority.
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true; # 32-bit Steam titles.
    pulse.enable = true;
  };

  # Firefox is the only browser, so drop Epiphany from the GNOME core apps.
  # Without this it stays registered as an http/https handler and wins the
  # default by accident. Firefox itself is configured in firefox.nix.
  environment.gnome.excludePackages = [
    pkgs.epiphany
    pkgs.gnome-weather
    pkgs.gnome-contacts
  ];

  # GTK4 apps and Firefox follow this via the prefers-color-scheme media query
  # and GTK theme negotiation.
  programs.dconf.profiles.user.databases = [
    {
      settings."org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
      };

      # The display runs at a fractional 1.5 scale (see hardware/monitors.xml).
      # xwayland-native-scaling makes X11 clients render at the real pixel size
      # and downscale, rather than being drawn at 1x and scaled up blurry.
      # kms-modifiers lets the compositor use tiled/compressed buffer layouts.
      settings."org/gnome/mutter" = {
        experimental-features = [
          "scale-monitor-framebuffer"
          "kms-modifiers"
          "xwayland-native-scaling"
        ];
      };
    }
  ];
}
