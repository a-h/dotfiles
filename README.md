# a-h dotfiles

* MacOS configuration shell script at `.macos` to disable pointless
  animations, free up screen space and remove background processes.
* Nix package manager used to install system.
* tmux configuration.
* zsh configuration.
* DZ60 configuration for keyboard layout (https://config.qmk.fm)

## New machine setup

1. Import public key (`gpg --import public-key.gpg`)
  1. https://security.stackexchange.com/questions/129474/how-to-raise-a-key-to-ultimate-trust-on-another-machine
  1. Remember to disable the Gnome Keyring, since it starts an SSH agent.
1. Remembers to use `keytocard` to migrate the key onto the new card https://developers.yubico.com/PGP/Importing_keys.html
1. Setup the GPG card (`gpg --card-status`)
1. Update the `.gitconfig` to use the new card ID.
1. Set up the ~/.gnupg/sshcontrol file.
1. Clone this repo to `~/dotfiles`
1. Execute the MacOS settings: `./.macos`
1. Install Tmux Plugin Manager (`git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm`) and then install plugins from within tmux (Ctrl-B shift+I)
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
`darwin-rebuild switch --impure --flake ./#adrian-mac`

## Other programs

* ARM SDK
* Affinity Designer
* Affinity Photo
* Amphetamine
* Arduino IDE
* Chrome
* EAGLE
* Flycut
* Fritzing
* Giphy capture
* Little Snitch
* Microsoft Remote Desktop
* NoSQL Workbench DynamoDB
* QMK Toolbox
* Raspberry Pi Imager
* Skype
* Skype Meetings
* Slack
* SnowSQL
* Spotify
* Transporter
* VLC
* VMWare Fusion
* VSCode
* Wireshark
* Yubico Authenticator
