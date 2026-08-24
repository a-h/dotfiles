{ pkgs, ... }:

let
  # Ghostty only reads $XDG_CONFIG_HOME/ghostty/config.ghostty; it does not
  # search XDG_CONFIG_DIRS, so there is no /etc location to drop this in.
  # systemd-tmpfiles links it into the user's config directory instead, and
  # L+ replaces whatever is already there.
  ghosttyConfig = pkgs.writeText "ghostty-config" ''
    # JetBrains Mono draws "!=", "->" and friends as single glyphs through its
    # contextual alternates. Turn the ligature features off so "if err != nil"
    # renders as the two characters that are actually in the source.
    font-feature = -calt
    font-feature = -liga
    font-feature = -dlig
  '';
in
{
  systemd.user.tmpfiles.users.adrian.rules = [
    "L+ %h/.config/ghostty/config.ghostty - - - - ${ghosttyConfig}"
  ];
}
