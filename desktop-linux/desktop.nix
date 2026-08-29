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

  # GNOME has no built-in auto-hide for the top bar the way macOS does for the
  # menu bar, so this extension supplies it. It matters for games: the panel is
  # always-on-top, and a game that sizes itself to the screen without setting
  # _NET_WM_STATE_FULLSCREEN (most "borderless windowed" modes) stays a normal
  # window underneath it, so the bar covers the top of the picture. Mutter only
  # hides the panel for windows that actually request the fullscreen state.
  environment.systemPackages = [ pkgs.gnomeExtensions.hide-top-bar ];

  # GTK4 apps and Firefox follow this via the prefers-color-scheme media query
  # and GTK theme negotiation.
  programs.dconf.profiles.user.databases = [
    {
      settings."org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
      };

      # Auto-hide the top bar, matching the macOS "automatically hide and show
      # the menu bar" behaviour: the panel stays hidden, slides down when the
      # pointer reaches the top edge, and always reappears in the Activities
      # overview. Reveal behaviour is tuned in Extensions -> Hide Top Bar;
      # "intellihide" there hides the panel only when a window needs the space
      # rather than unconditionally.
      #
      # /etc/dconf/profile/user lists user-db:user ahead of the system db, so a
      # value already present in ~/.config/dconf/user wins over this one. That
      # file holds an explicit empty enabled-extensions, which shadows this
      # setting until it is cleared once with:
      #   dconf reset /org/gnome/shell/enabled-extensions
      settings."org/gnome/shell" = {
        enabled-extensions = [ "hidetopbar@mathieu.bidon.ca" ];
      };

      # The display runs at a fractional 1.5 scale: a 2560x1440 logical desktop
      # on a 3840x2160 panel, which is the readable size on a 27" screen. 1.0
      # was tried and left the chrome too small; 2.0 is larger than wanted.
      #
      # The cost is that X11 has no fractional buffer scale - a client renders
      # at 1x, 2x or 3x, never 1.5x - so mutter rounds up to buffer scale 2,
      # composites the logical desktop into a 5120x2880 stage and downsamples
      # that to the panel. xwayland-native-scaling hands X11 clients that stage
      # as their screen, so games see 5120x2880 and offer it as "native";
      # picking it supersamples and burns GPU for nothing. The rest of the mode
      # ladder is an ordinary 16:9 set - 3200x1800, 2560x1440, 1920x1080 and so
      # on - so choose one of those in-game. Only an integer scale would drop
      # the intermediate stage entirely.
      #
      # This is not what put the top bar over fullscreen games. That was the
      # panel being always-on-top above windows that never set
      # _NET_WM_STATE_FULLSCREEN, which most "borderless windowed" modes do not;
      # the hide-top-bar extension above fixes it independently of scale.
      #
      # xwayland-native-scaling makes X11 clients render at the real pixel size
      # and downscale, rather than being drawn at 1x and scaled up blurry.
      # kms-modifiers lets the compositor use tiled/compressed buffer layouts.
      #
      # hardware/monitors.xml is a reference copy of ~/.config/monitors.xml;
      # nothing deploys it, GNOME owns that file.
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
