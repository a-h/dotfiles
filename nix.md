# Nix usage

Refer to https://hardselius.github.io/2020/nix-please/

## Install nix.

```shell
sh <(curl -L https://nixos.org/nix/install) --darwin-use-unencrypted-nix-store-volume
```

# Install nix-darwin.

```shell
nix-build https://github.com/LnL7/nix-darwin/archive/master.tar.gz -A installer
./result/bin/darwin-installer
rm -rf result
```

# Copy the darwin configuration from dotfiles.

```shell
rm ~/nixpkgs/darwin-configuration.nix
ln ./dotfiles/.nixpkgs/darwin-configuration.nix ./.nixpkgs/
```

# Add packages

Find them by browsing https://github.com/NixOS/nixpkgs/tree/master/pkgs/

Or by using the CLI tool

```
nix-env -qaP gnupg
```

Once found, add them to the `darwin-configuration.nix` file.

# Rebuild the system

```
darwin-rebuild switch
```
