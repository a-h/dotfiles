# Pin the flake registry entry for nixpkgs to the same revision this
# configuration was built from, so that `nix run nixpkgs#<name>` and similar
# commands use the installed nixpkgs instead of downloading a newer one. Works
# in NixOS, nix-darwin, and home-manager, which all provide nix.registry.
{ inputs, ... }:

{
  nix.registry.nixpkgs.flake = inputs.nixpkgs;
}
