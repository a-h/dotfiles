# a-h dotfiles

* MacOS configuration shell script at `.macos` to disable pointless animations, free up screen space and remove background processes.
* Nix package manager used to install system.
* tmux configuration.
* zsh configuration.

# New machine setup

1. Clone this repo to `~/dotfiles`
2. Execute the MacOS settings: `./.macos`
2. Install nix and nix-darwin.
3. Execute `darwin-rebuild switch` to install packages.

## Nix setup

Refer to https://hardselius.github.io/2020/nix-please/ and https://github.com/utdemir/dotfiles/blob/master/home.nix

### Install nix.

```shell
sh <(curl -L https://nixos.org/nix/install) --darwin-use-unencrypted-nix-store-volume
```

### Install nix-darwin.

```shell
nix-build https://github.com/LnL7/nix-darwin/archive/master.tar.gz -A installer
./result/bin/darwin-installer
rm -rf result
```

### Copy the darwin configuration from dotfiles.

```shell
rm ~/nixpkgs/darwin-configuration.nix
ln ./dotfiles/.nixpkgs/darwin-configuration.nix ./.nixpkgs/
```

# Further configuration

Find more packages with `nix-env -qaP <package_name>` or by browsing https://github.com/NixOS/nixpkgs/tree/master/pkgs/

Once found, add them to the `darwin-configuration.nix` file and rebuild with `darwin-rebuild switch`

