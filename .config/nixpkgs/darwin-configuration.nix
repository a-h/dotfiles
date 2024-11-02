# See https://nixos.org/guides/towards-reproducibility-pinning-nixpkgs.html and https://status.nixos.org
# https://github.com/NixOS/nixpkgs/releases/tag/22.11
{ pkgs, lib, inputs, unstablepkgs, ... }:

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

  # Pin the flake registries, e.g. nix run nixpkgs#hello will use the pinned version of nixpkgs.
  nix.registry = (lib.mapAttrs (_: flake: { inherit flake; })) ((lib.filterAttrs (_: lib.isType "flake")) inputs);
  nix.package = pkgs.nix;
  nix.distributedBuilds = true;
  #nix.buildMachines = [
  #{
  #hostName = "65.109.61.232";
  #systems = [ "x86_64-linux" "aarch64-linux" ];
  #sshUser = "adrian";
  #sshKey = "/var/root/.ssh/id_ed25519";
  #protocol = "ssh-ng";
  ## Base64 encoded public key (ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN7DxQnv/xtYyz9D1OeygTXGF1zfi4TprhXt7gjtM0SM)
  #publicHostKey = "ICAgICAgcHVibGljSG9zdEtleSA9ICJzc2gtZWQyNTUxOSBBQUFBQzNOemFDMWxaREkxTlRFNUFBQUFJTjdEeFFudi94dFl5ejlEMU9leWdUWEdGMXpmaTRUcHJoWHQ3Z2p0TTBTTSI7Cg==";
  #supportedFeatures = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];
  #mandatoryFeatures = [ ];
  #maxJobs = 8;
  #speedFactor = 1;
  #}
  #];
  nix.settings = {
    auto-optimise-store = false;
    experimental-features = "nix-command flakes";
    substituters = [ "s3://nix-cache?profile=minio-adrianhesketh-com&endpoint=minio.adrianhesketh.com" ];
    trusted-public-keys = [ "minio.adrianhesketh.com-1:ZsX6S/f92zQxKisV+68OcL5kCH5Z14ruKH+eJcHGs7w=" ];
    trusted-substituters = [ "s3://nix-cache?profile=minio-adrianhesketh-com&endpoint=minio.adrianhesketh.com" ];
    trusted-users = [ "adrian-hesketh" "adrian" ];
  };

  # The Nix store was already setup by adding an S3 profile that allows access to minio.adrianhesketh.com via AWS.
  #
  # ~/.aws/config
  # [profile minio-adrianhesketh-com]
  # endpoint_url = https://minio.adrianhesketh.com
  # region = us-east-1
  # output = json
  #
  # ~/.aws/credentials
  # [minio-adrianhesketh-com]
  # aws_access_key_id = <access-key>
  # aws_secret_access_key = <secret-key>
  #
  # The public and private keys were generated using the following command:
  #
  # sudo nix-store --generate-binary-cache-key minio.adrianhesketh.com-1 minio-adrianhesketh-com-private-key.pem minio-adrianhesketh.com-public-key.pem
  #
  # To build and push to the store...
  # Build...
  # nix build .#devShells.x86_64-linux.default
  # pass minio.adrianhesketh.com/nix-store-private-key.pem > ~/nix-store-private-key.pem
  # Sign...
  # nix store sign -k ~/nix-store-private-key.pem --store 's3://nix-cache?profile=minio-adrianhesketh-com&endpoint=minio.adrianhesketh.com' .#devShells.x86_64-linux.default
  # Verify...
  # nix store verify --store 's3://nix-cache?profile=minio-adrianhesketh-com&endpoint=minio.adrianhesketh.com' .#devShells.x86_64-linux.default
  # Push...
  # nix copy --to 's3://nix-cache?profile=minio-adrianhesketh-com&endpoint=minio.adrianhesketh.com' .#devShells.x86_64-linux.default
  nix.extraOptions = ''
    builders-use-substitutes = true
    builders = ssh://adrian@65.109.61.232 x86_64-linux,aarch64-linux - 8 1 kvm -
  '';
  nix.channel.enable = false;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
  services.nix-daemon.enable = true;
  documentation.enable = false;
}

