# a-h dotfiles

* MacOS configuration shell script at `.macos` to disable pointless
  animations, free up screen space and remove background processes.
* Nix package manager used to install system.
* tmux configuration.
* zsh configuration.
* DZ60 configuration for keyboard layout (https://config.qmk.fm)

## New machine setup

1. Import public SSH key (`gpg --import pubkey.asc`)
1. Clone this repo to `~/dotfiles`
1. Execute the MacOS settings: `./.macos`
1. Install nix and nix-darwin.
1. Execute `darwin-rebuild switch` to install packages.

## Nix setup

Refer to https://hardselius.github.io/2020/nix-please/ and https://github.com/utdemir/dotfiles/blob/master/home.nix

### Install nix

```shell
sh <(curl -L https://nixos.org/nix/install) --darwin-use-unencrypted-nix-store-volume
```

### Install nix-darwin

```shell
nix-build https://github.com/LnL7/nix-darwin/archive/master.tar.gz -A installer
./result/bin/darwin-installer
rm -rf result
```

### Copy the darwin configuration from dotfiles

```shell
rm ~/nixpkgs/darwin-configuration.nix
ln ./dotfiles/.nixpkgs/darwin-configuration.nix ./.nixpkgs/
```

## Further configuration

Find more packages with `nix search <name>` or by browsing
https://github.com/NixOS/nixpkgs/tree/master/pkgs/

Once found, add them to the `darwin-configuration.nix` file and rebuild with
`darwin-rebuild switch`

## Other programs

* EAGLE
* Arduino IDE
* Affinity Photo
* Caffeine
* Chrome
* Etcher
* Flycut
* Giphy capture
* Little Snitch
* Microsoft Remote Desktop
* NoSQL Workbench DynamoDB
* Skype Meetings
* Skype
* Spotify
* Wireshark
* VLC
