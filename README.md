# a-h dotfiles

* MacOS configuration shell script at `.macos` to disable pointless
  animations, free up screen space and remove background processes.
* Nix package manager used to install system.
* tmux configuration.
* zsh configuration.
* DZ60 configuration for keyboard layout (https://config.qmk.fm)

## Layout

The Nix configuration is split so that each machine imports the shared pieces
it needs:

* `neovim/` - A self-contained neovim package. It bakes its own language
  servers and tools into the binary, so it does not depend on any
  system-installed packages. It is exposed as the flake's `neovim` (and
  `default`) package output, so it can be run or installed anywhere with
  `nix run github:a-h/dotfiles#neovim`.
* `common/` - Cross-platform pieces shared by every machine: the development
  package list (`packages.nix`), the zsh configuration (`.zshrc`), and the
  custom package derivations (`pkgs/`).
* `mac/` - The nix-darwin configuration for the personal Mac (`adrian-mac`).
* `work-linux/` - The home-manager configuration for the work Linux machine
  (`adrian-linux`).
* `desktop-linux/` - The NixOS configuration for the desktop machine
  (`desktop-linux`). It runs the standard development environment and GPU
  compute, and can also play games.

The flake outputs are:

* `packages.<system>.neovim` - the self-contained editor.
* `darwinConfigurations.adrian-mac` - the Mac.
* `homeConfigurations.adrian-linux` - the work Linux machine.
* `nixosConfigurations.desktop-linux` - the desktop.

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
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
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

Once found, add them to the relevant machine's configuration and rebuild with
the task for that machine.

## Tasks

### rebuild-mac

Env: NIXPKGS_ALLOW_UNFREE=1

```sh
sudo darwin-rebuild switch --impure --flake ./#adrian-mac
```

### rebuild-linux

The work Linux machine, using home-manager.

Env: NIXPKGS_ALLOW_UNFREE=1

```sh
nix run home-manager/release-26.05 -- switch --impure --flake ./#adrian-linux
```

### rebuild-desktop

The desktop machine, a full NixOS system.

```sh
sudo nixos-rebuild switch --flake ./#desktop-linux
```

### build-neovim

Build the self-contained neovim package.

```sh
nix build ./#neovim
```

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
