# Copy config into operating system.
# This includes the ~/.config/nixpkgs/home.nix that configures the system.
cp -r ./home /home
cp -r ./etc /etc

# Rebuild NixOS.
nixos-rebuild switch

# Add home manager.
nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --update
nix-shell '<home-manager>' -A install
