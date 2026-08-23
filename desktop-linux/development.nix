# The development tooling itself is installed per-user in users.nix
# (common/packages.nix). This module holds only what must be set system-wide.
{ ... }:

{
  virtualisation.docker.enable = true;

  programs.git.enable = true;
}
